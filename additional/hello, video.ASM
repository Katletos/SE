        org     100h

Start:
        mov     ah,     $0f
        int     10h
        mov     [bOldMode], al
        mov     [bOldPage], bh

        ;set video mode
        mov     ax,     $0003
        int     10h

        ;.....
        ;set segment
        push    $B800
        pop     es
        mov     di,     24 * 80 * 2
        mov     ax,     $0700 or '='
        mov     cx,     80
        rep stosw

        ;waiting
        mov     ax,     $0C08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ;.....

        movzx   ax,     [bOldPage]
        int     10h
        mov     ah,     $05
        mov     al,     [bOldPage]
        int     10h
        ret


bOldMode:       db      ?
bOldPage:       db      ?