        org     100h

Start:
        mov     ah,     $0F
        int     10h
        mov     [bOldMode], al
        mov     [bOldPage], bh

        ;set video mode
        mov     ax,     $0013
        int     10h

        ;.....
        ;set segment
        push    $A000
        pop     es
;        xor     di,     di
;        mov     al,     $30
;        mov     cx,     320*200*1
;        rep stosb



;        xor     dl,     dl
;        mov     cx,     200
;.RowLoop:
;        push    cx
;        mov     cx,     256
;.ColLoop:
;        stosb
;        inc     al
;        loop    .ColLoop
;
;        add     di,     320-256
;        pop     cx
;        loop    .RowLoop



        mov     cx,     320*200
        xor     di,     di



        ;waiting
        mov     ax,     $0C08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ;.....

        ;reset video mode
        movzx   ax,     [bOldPage]
        int     10h
        mov     ah,     $05
        mov     al,     [bOldPage]
        int     10h
        ret


bOldMode:       db      ?
bOldPage:       db      ?