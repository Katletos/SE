        org 100h
EntryPoint:
        push    42
        call PrintHex

        mov     ah, $09
        mov     dx, strCRLF
        int     21h

        mov     bx,65534
        call PrintHex

        call Waiting
        ret


;
Waiting:
        mov     ah, $08
        int     21h
        test    al, al
        jnz     @F
        mov     ah, $08
        int     21h
@@:
        ret


;Input  hexademical representation of a number.
;
;Input:
;  stack
;Output:
;  None.
PrintHex:
        push    bp
        mov     bp, sp

        mov     bx, [bp + 4];Number to convert
        mov     cx, 4

.PrintLoop:
        rol     bx, 4
        mov     ax, bx
        and     ax, 0000'0000_0000'1111b

        cmp     al, 10
        sbb     al, $69
        das

        mov     ah, $02
        mov     dl, al
        int 21h
        loop .PrintLoop

        pop     bp
        ret

strCRLF db 13, 10, '$'