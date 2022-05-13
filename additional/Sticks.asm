        include 'macro\proc16.inc'

        include 'Units\Random.h'
        include 'Units\Keyboard.h'
        include 'Units\Screen.h'

FALSE           = 0
TRUE            = 1
nil             = 0

LINE_STICKS     = 12
LINE_HINT       = 14

STICK_WIDTH     = 5
STICK_HEIGHT    = 50
GAP_WIDTH       = 5

plComputer      = 0
plUser          = 1

struc String Params&
{
  local length
  . db length, Params
  length = $ - . - 1
}

        org 100h

Start:
     cld
     stdcall    Random.Initialize
     stdcall    Screen.SetMode, $0003
     mov        bx, ax
     stdcall    Model.SetView, TextView.Update

     stdcall    Controller.StartGame
.GameLoop:
     stdcall    Keyboard.ReadKey
     stdcall    Controller.OnKeyPress, ax
     test       ax, ax
     jz         .GameLoop

     stdcall    Screen.SetMode, bx
     ret

proc Controller.StartGame
     stdcall    Model.StartGame
     ret
endp

proc Controller.OnKeyPress\
     wKey

     mov        ax, TRUE
     cmp        [wKey], KEY_ESCAPE
     je         .EndProc

     stdcall    Model.IsGameOver
     test       ax, ax
     jnz        .EndProc

     stdcall    Model.GetNextPlayer
     cmp        ax, plComputer
     je         .AnyKey
.UserKey:
     mov        ax, [wKey]
     cmp        ax, '1'
     jb         .EndProc
     cmp        ax, '3'
     ja         .EndProc
     sub        ax, '0'
     stdcall    Model.MakeUserMove, ax
     jmp        .Done
.AnyKey:
     cmp        [wKey], KEY_ENTER
     jne        .Done
     stdcall    Model.MakeComputerMove

.Done:
     xor        ax, ax
.EndProc:
     ret
endp

proc Model.SetView\
     pfnView

     mov        ax, [pfnView]
     mov        [Model.pfnView], ax
     ret
endp

proc Model.StartGame
     stdcall    Random.Get, 20, 20
     mov        [Model.nSticksTotal], ax
     mov        [Model.nSticksLeft], ax
     mov        [Model.plNext], plUser

     stdcall    [Model.pfnView]
     ret
endp

proc Model.MakeUserMove\
     nSticks

     mov        ax, [nSticks]
     cmp        ax, [Model.nSticksLeft]
     ja         .EndProc

     xor        [Model.plNext], 1
     sub        [Model.nSticksLeft], ax
     jz         .DoUpdate

     mov        ax, [Model.nSticksLeft]
     dec        ax
     and        ax, 0000'0000_0000'0011b
     jnz        @F

     mov        ax, [Model.nSticksLeft]
     sub        ax, 3
     cwd
     and        ax, dx
     add        ax, 3
     stdcall    Random.Get, 1, ax
@@:
     mov        [Model.nNextMove], ax
.DoUpdate:
     stdcall    [Model.pfnView]
.EndProc:
     ret
endp

proc Model.MakeComputerMove
     mov        ax, [Model.nNextMove]
     sub        [Model.nSticksLeft], ax
     xor        [Model.plNext], 1

     stdcall    [Model.pfnView]
     ret
endp

proc Model.GetNextMove
     mov        ax, [Model.nNextMove]
     ret
endp

proc Model.GetNextPlayer
     mov        ax, [Model.plNext]
     ret
endp

proc Model.IsGameOver
     xor        ax, ax
     cmp        [Model.nSticksLeft], 0
     sete       al
     ret
endp

proc Model.GetTotalStickCount
     mov        ax, [Model.nSticksTotal]
     ret
endp

proc Model.GetStickCount
     mov        ax, [Model.nSticksLeft]
     ret
endp

proc GraphView.Update uses es bx di
     stdcall    Screen.Clear

     stdcall    Model.GetTotalStickCount
     imul       ax, ax, STICK_WIDTH + GAP_WIDTH
     sub        ax, GAP_WIDTH
     mov        bx, 320
     sub        bx, ax
     shr        bx, 1

     stdcall    Model.GetStickCount
     mov        cx, ax
     jcxz       .Done
.StickLoop:
     push       cx
     stdcall    Screen.Rectangle, bx, (200 - STICK_HEIGHT) / 2, STICK_WIDTH, STICK_HEIGHT, 15
     pop        cx
     add        bx, STICK_WIDTH + GAP_WIDTH
     loop       .StickLoop
.Done:
     ret
endp

proc TextView.Update uses es di
     stdcall    Screen.Clear

     stdcall    Model.GetTotalStickCount
     push       $B800
     pop        es
     mov        di, 80
     sub        di, ax
     shr        di, 1
     add        di, (LINE_STICKS * 80)
     shl        di, 1
     stdcall    Model.GetStickCount
     mov        cx, ax
     mov        ax, $0700 or '|'
     rep stosw

     stdcall    Model.GetNextPlayer
     mov        di, ax
     stdcall    Model.IsGameOver
     test       ax, ax
     jz         .NotGameOver
.GameOver:
     mov        ax, strUserWon
     cmp        di, plComputer
     jne        .PrintHint
     mov        ax, strComputerWon
     jmp        .PrintHint
.NotGameOver:
     mov        ax, strUserMove
     cmp        di, plComputer
     jne        .PrintHint

     stdcall    Model.GetNextMove
     add        ax, '0'
     mov        [cNumSticks], al
     mov        ax, strComputerMove


.PrintHint:
     stdcall    Screen.WriteString, ax, LINE_HINT, alCenter, $07
     ret
endp

        include 'Units\Random.c'
        include 'Units\Keyboard.c'
        include 'Units\Screen.c'

        include 'Units\Random.di'
        include 'Units\Keyboard.di'
        include 'Units\Screen.di'

strUserMove     String  'Press 1, 2 or 3 to make move. Press Esc to quit.'
strComputerMove db      strComputerMove.Length, 'I take '
cNumSticks      db      ?
                db      ' sticks.'
strComputerMove.Length = $ - strComputerMove - 1

strUserWon      String  'You won, cheater! :-('
strComputerWon  String  'Ha-ha, I won, loser! :-)'

        include 'Units\Random.du'
        include 'Units\Keyboard.du'
        include 'Units\Screen.du'

Model.nSticksTotal      dw      ?
Model.nSticksLeft       dw      ?
Model.nNextMove         dw      ?
Model.plNext            dw      ?
Model.pfnView           dw      ?