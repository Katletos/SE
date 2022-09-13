        org     100h
EntryPoint:
        mov     bx, OLD
        call    PrintArr
        call    PrintCLRF

        call    NegativeToZero

        mov     bx, OLD
        call    PrintArr

        call    Waiting

PrintArr:
        mov     ah, $02
        mov     cx, SIZE
@@:
        mov     dl, [bx]

        test    dl, dl
        js      .ifNegativeNumber
        jns     .ifPositiveNumber
.success:
        inc     bx
        loop    @B
        ret

.ifNegativeNumber:
        mov     dl, '-'
        int     21h

        mov     dl, [bx]
        ;Перевод в прямой код
        not     dl
        add     dl, 1
        add     dl, '0'
        int     21h
        jmp    .success

.ifPositiveNumber:
        add     dl, '0'
        int     21h
        jmp    .success



NegativeToZero:
        mov     bx, OLD
        mov     cx, SIZE
@@:     ;bx-inp
        mov     dl, [bx]
        test    dl, dl
        jns     .notInsert

        mov     byte [bx],  0
        inc     [Counter]
        .notInsert:

        inc     bx
        loop    @B

        mov     ah, $02
        mov     dl, [Counter]
        int     21h

PrintCLRF:
        mov     ah, $09
        mov     dx, strCRLF
        int     21h
        ret



Waiting:
        mov     ah,     $08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ret


SIZE = 10
OLD db 1,2,-3,4,5,6,-7,8,9,0
strCRLF db 13, 10, '$'
Counter db 0