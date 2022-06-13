        org  100h
EntryPoint:

        mov     bx, Arr
        call    PrintArr
        call    PrintCLRF
        mov     bx, Arr
        call    PrintEven
        call    Waiting

PrintEven:
        mov     ah, $02
        mov     cx, SIZE
@@:
        mov     byte  dl, [bx]

        test    dl, 1
        jnz     .Odd    

        test    dl, dl
        jns     .ifPositiveNumber

        mov     dl, '-'
        int     21h

        mov     byte dl, [bx]
        ;Ïåðåâîä â ïðÿìîé êîä
        not     dl
        add     dl, 1

.ifPositiveNumber:
        add     dl, '0'
        int     21h
        
        inc     bx
        loop    @B
        ret
        

PrintArr:
        mov     ah, $02
        mov     cx, SIZE
@@:
        mov     dl, [bx]

        test    dl, dl
        js      .ifNegativeNumber
        jns     .ifPositiveNumber

.ifNegativeNumber:
        mov     dl, '-'
        int     21h

        mov     dl, [bx]
        not     dl
        add     dl, 1
        add     dl, '0'
        int     21h
        jmp    .success

.ifPositiveNumber:
        add     dl, '0'
        int     21h
        jmp    .success

.success:
        inc     bx
        loop    @B
        ret


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
strCRLF db 13, 10, '$'
Arr db 4 ,-2,3,4,5,6,7,8,9,6
Counter db 0
