        org 100h

        include 'macro\proc16.inc'

nil     = 0
TT_MIN  = 2
TT_MAX  = 5

        include 'Units\Random.h'
        include 'Units\Screen.h'
        include 'Units\Keyboard.h'

EntryPoint:
        stdcall Random.Initialize
        stdcall Screen.SetMode, $0003
        mov     bx, ax

        mov     [Model.nBorderPos], 40
        stdcall View.Update, [Model.nBorderPos]

        stdcall Random.Get, TT_MIN, TT_MAX
        mov     [nTimerTicksLeft], ax
        stdcall SetIntVector, $1C, cs, Controller.OnTimer
        mov     word [lpOldISR], ax
        mov     word [lpOldISR + 2], dx
.GameLoop:
        stdcall Keyboard.ReadKey
        cmp     ax, ' '
        je      .KeyLeft
        cmp     ax, KEY_ESCAPE
        je      .EndGameLoop
        jmp     .GameLoop
.KeyLeft:
        inc     [Model.nBorderPos]

        cmp     [Model.nBorderPos], 0
        je      .EndGameLoop
        cmp     [Model.nBorderPos], 80
        je      .EndGameLoop

        stdcall View.Update, [Model.nBorderPos]
        jmp     .GameLoop
.EndGameLoop:

        stdcall SetIntVector, $1C, word [lpOldISR + 2], word [lpOldISR]
        stdcall Screen.SetMode, bx
        ret

Controller.OnTimer:
        push    ds ax cx dx

        push    cs
        pop     ds

        dec     [nTimerTicksLeft]
        jnz     @F

        stdcall Random.Get, TT_MIN, TT_MAX
        mov     [nTimerTicksLeft], ax

        dec     [Model.nBorderPos]
        stdcall View.Update, [Model.nBorderPos]
@@:
        pop     dx cx ax ds
        iret

proc SetIntVector uses es bx,\
     nInt: BYTE, segISR, ofsISR

     push       0
     pop        es
     movzx      bx, [nInt]
     shl        bx, 2

     mov        dx, [segISR]
     mov        ax, [ofsISR]

     pushf
     cli
     xchg       [es:bx], ax
     xchg       [es:bx + 2], dx
     popf
     ret
endp

proc View.Update uses es di,\
     nBorderPos

     push       $B800
     pop        es
     xor        di, di
     mov        cx, 25
.RowLoop:
     push       cx
     mov        cx, [nBorderPos]
     mov        ax, $07B1       ; 07 - color, B1 - character
     rep stosw

     mov        cx, 80
     sub        cx, [nBorderPos]
     mov        ax, $0700 or ' '
     rep stosw
     pop        cx
     loop       .RowLoop
     ret
endp

        include 'Units\Random.c'
        include 'Units\Screen.c'
        include 'Units\Keyboard.c'

        include 'Units\Random.di'
        include 'Units\Screen.di'
        include 'Units\Keyboard.di'

        include 'Units\Random.du'
        include 'Units\Screen.du'
        include 'Units\Keyboard.du'

Model.nBorderPos        dw      ?
nTimerTicksLeft         dw      ?
lpOldISR                dd      ?