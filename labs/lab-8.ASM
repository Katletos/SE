        org 100h

        mov     ah,     0Fh
        int     10h
        mov     [bOldMode], al
        mov     [bOldPage], bh

        mov     ax,     $0013
        int     10h

        push    $A000
        pop     es
        mov     di,     320*20+80

        mov     cx,     16
        mov     al,     16
Start:
        push    cx
        mov     cx,     8
Square:
        push    cx
        sub     al,     16
        mov     cx,     16

Line:
        push    cx
        mov     cx,     8
        rep     stosb
        pop     cx
        add     di,     2
        add     al,     1
        loop    Line

        add     di,     320-160
        pop     cx
        loop    Square

        add     di,     320*2
        add     al,     16
        pop     cx
        loop    Start

        mov     ax,     0C08h
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     08h
        int     21h
        @@:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        movzx   ax,     [bOldMode]
        int     10h
        mov     ah,     05h
        mov     al,     [bOldPage]
        int     10h
        ret

bOldMode db ?
bOldPage db ?
