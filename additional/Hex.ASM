        org 100h
EntryPoint:
        mov     bx,42
        call PrintHex



        mov     bx,65534
        call PrintHex

        call Waiting
        ret

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
;  EX      Number tobe printed
;Output:
;  None.
PrintHex:
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
        ret

strCRLF db 13, 10, '$'