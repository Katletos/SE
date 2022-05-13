        org 100h

        include 'macro\proc16.inc'

nil     = 0

        include 'Units\Screen.h'
        include 'Units\Keyboard.h'

EntryPoint:
        stdcall Screen.SetMode, $0003
        mov     bx, ax

        mov     [Model.nBorderPos], 40
        stdcall View.Update, [Model.nBorderPos]
.GameLoop:
        stdcall Keyboard.ReadKey
        cmp     ax, KEY_LEFT
        je      .KeyLeft
        cmp     ax, KEY_RIGHT
        je      .KeyRight
        cmp     ax, KEY_ESCAPE
        je      .EndGameLoop
        jmp     .GameLoop
.KeyLeft:
        inc     [Model.nBorderPos]
        jmp     @F
.KeyRight:
        dec     [Model.nBorderPos]
@@:
        cmp     [Model.nBorderPos], 0
        je      .EndGameLoop
        cmp     [Model.nBorderPos], 80
        je      .EndGameLoop

        stdcall View.Update, [Model.nBorderPos]
        jmp     .GameLoop
.EndGameLoop:

        stdcall Screen.SetMode, bx
        ret

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

        include 'Units\Screen.c'
        include 'Units\Keyboard.c'

        include 'Units\Screen.di'
        include 'Units\Keyboard.di'

Model.nBorderPos        dw      ?

        include 'Units\Screen.du'
        include 'Units\Keyboard.du'