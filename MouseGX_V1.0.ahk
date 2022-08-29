;[ ◎MouseGX.ahk]
;===============================================================================.
;LOG-> FileAppend, [DateTime: %A_YYYY%/%A_MM%/%A_DD% %A_Hour%:%A_Min%:%A_Sec%.%A_MSec%]`n, AutoHotKey.Log
;2021/08/01 V1.00 初版(Guesture按鍵INI化:基本款)

;[-* Global *-]
#NoEnv         ;
SendMode Input ;
#SingleInstance

Applicationname=MouseGX
ToggleMarkCopyFG=-1  ;ToggleCheckOff
Gosub,INIRead

;===============================================================================.
;[-* Tray Menu *-]
  ClipDir =
  Menu, Tray, NoStandard ;#Remark for Debug Used Window Spy
  Menu, Tray, DeleteAll
  Menu, Tray, Add, [* ---------  MouseGX 易控鼠 V1.0  --------- *],Label
  Menu, Tray, Add
  Menu, Tray, Add, Suspend / Resume,SuspendRun
  Menu, Tray, Add, Reload,RELOAD
  Menu, Tray, Add, &Exit,EXIT
  Menu, Tray, Add
  Menu, Tray, Add, (RightButton) + ↑　 =>(U  ) Copy ,Label
  Menu, Tray, Add, (RightButton) + →　 =>(R  ) Paste ,Label
  Menu, Tray, Add, (RightButton) + ←　 =>(L  ) Backspace ,Label
  Menu, Tray, Add, (RightButton) + ←→ =>(LR) Delete ,Label
  Menu, Tray, Add, (RightButton) + ↓← =>(DL) Enter ,Label
  Menu, Tray, Add, (RightButton) + ←↓ =>(LD) UnDo ,Label
  Menu, Tray, Add, (RightButton) + ←↑ =>(LU) ReDo ,Label
  Menu, Tray, Add
  Menu, Tray, Add, LA↑↓=Transparent ,Label
  Menu, Tray, Add, LA(MB)=TransparentOff ,Label
  Menu, Tray, Add, [Win]+(MB)=AlwayOnTop ,Label
  Menu, Tray, add
  Menu, Tray, add, ABOUT ,ABOUT
  Return

ABOUT:
  about=[----------------------  ● Mouse Gesture 滑鼠手勢 ●  ----------------------]`n ;
  about=%about%`n(▼ 滑鼠動作 )
  about=%about%`n  (RightButton) + ↑　 => (U  ) 複製
  about=%about%`n  (RightButton) + →　 => (R  ) 貼上
  about=%about%`n  (RightButton) + ←　 => (L  ) 退格
  about=%about%`n  (RightButton) + ←→ => (LR) 刪除
  about=%about%`n  (RightButton) + ↓← => (DL) 換行
  about=%about%`n  (RightButton) + ←↓ => (LD) 還原
  about=%about%`n  (RightButton) + ←↑ => (LU) 重作
  about=%about%`n
  about=%about%`n(▼ 視窗動作 )
  about=%about%`n  LeftAlt   +    ↑  ↓            => 視窗半透明
  about=%about%`n  LeftAlt   + (MiddleButton) => 取消半透明
  about=%about%`n  [Win]     + (MiddleButton) => 視窗置頂
  Gui, New , , MouseGX
  Gui, Add, Text,  , %about%
  Gui, Add, Link,, <a href="MailTo: MouseGX@gmail.com">[-----------------  ★ Power By:  MouseGX@gmail.com ★  -----------------]</a> 
  Gui, Add, Link,, <a href="https://mousegxhome.blogspot.com">【Https://mousegxhome.blogspot.com】</a> 
  Gui, Show
  Return

Label:
  Return

SuspendRun:
  Suspend,Toggle
  Return

RELOAD:
  Reload

#(MB)=AlwayOnTop:
  Return

LA↑↓=Transparent:
  Return
LA(MB)=TransparentOff:
  Return

EXIT:
  ExitApp

;===============================================================================.
;[ ▼Mouse Gesture]
RButton::
  MouseGetPos, , , id
  WinGetClass, class, ahk_id %id%
  if (class = "TTOTAL_CMD" or class = "VNCMDI_Window" or class = "TSSHELLWND")
  {  ;Special Action for TotalCommander/VNC/RemoteDesktop
    MouseClick, right,,, 1, 0, D
    Loop
    {
      Sleep, 100
      GetKeyState, state, RButton, P
      if state = U
        break
    }
    MouseClick, right,,, 1, 0, U
  }
  else
  {
    Gesture := MG_Recognize()
    if Gesture
    {
      if Gesture = U
      {
        Send %GX_U%
      }
      if Gesture = R
      {
        Send %GX_R%
      }
      if Gesture = L
      {
        Send %GX_L%
      }
      if Gesture = LR
      {
        Send %GX_LR%
      }
      if Gesture = DL
      {
        Send %GX_DL%
      }
      if Gesture = LD
      {
        Send %GX_LD%
      }
      if Gesture = LU
      {
        Send %GX_LU%
      }
    }
  }
  Return

;===============================================================================.
;[ ▼Window Action]
#MButton::              ;Alway on Top
  MouseGetPos,,, MouseWin
  WinSet, AlwaysOnTop,Toggle , ahk_id %MouseWin%
  Return

;-------------------------------------------------------------------------------.
;[-* Window Transparency *-]
~LAlt & WheelUp::  ;Transparent Up
  MouseGetPos,,, MouseWin
  WinGet, CurTrans, Transparent, ahk_id %MouseWin%
  If not CurTrans
  {
     CurTrans := 255
  }
  CurTrans += 20
  If CurTrans > 255
  {
     CurTrans := 255
  }
  WinSet, Transparent, %CurTrans% , ahk_id %MouseWin%
  Return

~LAlt & WheelDown::  ;Transparent Down
  MouseGetPos,,, MouseWin
  WinGet, CurTrans, Transparent, ahk_id %MouseWin%
  If not CurTrans
  {
     CurTrans := 255
     WinSet, TransColor, Off, ahk_id %MouseWin%
  }
  CurTrans -= 20
  If CurTrans < 50
  {
     CurTrans := 50
  }
  WinSet, Transparent, %CurTrans% , ahk_id %MouseWin%
  Return

~LAlt & MButton::    ;Transparent Reset
  MouseGetPos,,, MouseWin
  WinSet, Transparent, 255 , ahk_id %MouseWin%
  Return

;===============================================================================.
;[-* (Common Function) *-]
INIRead:
  IfNotExist,%Applicationname%.ini
  {
    GX_U         := "{CTRLDOWN}c{CTRLUP}"   ;Copy
    GX_R         := "{CTRLDOWN}v{CTRLUP}"   ;Paste
    GX_L         := "{Backspace}"           ;Backspace
    GX_LR        := "{Delete}"              ;Delete
    GX_DL        := "{Enter}"               ;Enter
    GX_LD        := "^z"                    ;UnDo
    GX_LU        := "^y"                    ;ReDo

    Gosub,INIWrite
  }

  IniRead,GX_U        ,%Applicationname%.ini,Settings,GX_U
  IniRead,GX_R        ,%Applicationname%.ini,Settings,GX_R
  IniRead,GX_L        ,%Applicationname%.ini,Settings,GX_L
  IniRead,GX_LR       ,%Applicationname%.ini,Settings,GX_LR
  IniRead,GX_DL       ,%Applicationname%.ini,Settings,GX_DL
  IniRead,GX_LD       ,%Applicationname%.ini,Settings,GX_LD
  IniRead,GX_LU       ,%Applicationname%.ini,Settings,GX_LU
  Return


INIWrite:
  IniWrite,%GX_U%        ,%Applicationname%.ini,Settings,GX_U
  IniWrite,%GX_R%        ,%Applicationname%.ini,Settings,GX_R
  IniWrite,%GX_L%        ,%Applicationname%.ini,Settings,GX_L
  IniWrite,%GX_LR%       ,%Applicationname%.ini,Settings,GX_LR
  IniWrite,%GX_DL%       ,%Applicationname%.ini,Settings,GX_DL
  IniWrite,%GX_LD%       ,%Applicationname%.ini,Settings,GX_LD
  IniWrite,%GX_LU%       ,%Applicationname%.ini,Settings,GX_LU
  Return

;===============================================================================.
;[-* (Mouse Gesture Function) *-]
MG_GetMove(Angle)
{
    Loop, 4
    {
        if (Angle <= 90*A_Index-45)
        {
            Sector := A_Index
            Break
        }
        Else if (A_Index = 4)
        Sector = 1
    }

    if Sector = 1
    Return "U"
    else if Sector = 2
    Return "R"
    else if Sector = 3
    Return "D"
    else if Sector = 4
    Return "L"
}

MG_GetAngle(StartX, StartY, EndX, EndY)
{
    x := EndX-StartX, y := EndY-StartY
    if x = 0
    {
        if y > 0
        return 180
        Else if y < 0
        return 360
        Else
        return
    }
    deg := ATan(y/x)*57.295779513
    if x > 0
    return deg + 90
    Else
    return deg + 270
}

MG_GetRadius(StartX, StartY, EndX, EndY)
{
    a := Abs(endX-startX), b := Abs(endY-startY), Radius := Sqrt(a*a+b*b)
    Return Radius
}

MG_Recognize(MGHotkey="", ToolTip=0, MaxMoves=3, ExecuteMGFunction=1, SendIfNoDrag=1)
{
   CoordMode, mouse, Screen
   MouseGetPos, mx1, my1
   if MGHotkey =
   MGHotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W)")
   Loop
   {
        if !(GetKeyState(MGHotkey, "p"))
        {
            if Gesture =
            {
                if ToolTip = 1
                ToolTip
                if SendIfNoDrag = 1
                {
                    SendInput, {%MGHotkey%}
                }
                Return 0
            }
            if ToolTip = 1
            ToolTip
            if (IsFunc("MG_" Gesture) <> 0 and ExecuteMGFunction = 1)
            MG_%Gesture%()
            Return Gesture
        }
        Sleep, 20
        MouseGetPos, EndX, EndY
        Radius := MG_GetRadius(mx1, my1, EndX, EndY)
        if (Radius < 9)
        Continue

        Angle := MG_GetAngle(mx1, my1, EndX, EndY)
        MouseGetPos, mx1, my1
        CurMove := MG_GetMove(Angle)

        if !(CurMove = LastMove)
        {
            Gesture .= CurMove
            LastMove := CurMove
            {
                if (StrLen(Gesture) > MaxMoves)
                {
                    if ToolTip = 1
                    ToolTip
                    Progress, m2 b fs10 zh0 w180 WMn700, 【● Gesture Canceled ●】
                    Sleep, 200
                    KeyWait, %MGHotkey%
                    Progress, off
                    Return
                }
            }
        }
        if ToolTip = 1
        ToolTip, %Gesture%
    }
}

