        org 100h
Start:
        ;Display string
        mov     ah,    $09
        mov     dx,    TaskStr
        int     21h

        ;Bufrd input
        mov     ah,     $0A
        mov     dx,     bufInput
        int     21h

        ;3 <= String length <= 10
        cmp     [bufInput+1], 10
        ja      Error
        cmp     [bufInput+1], 3
        jb      Error

        ;Equality test 1 and 3 symbol
        mov     bl,     [bufInput+1+1]
        cmp     bl,     [bufInput+1+3]
        jnz     Error

        ;Digit test
        cmp     [bufInput+1+2], '9'
        ja      Error
        cmp     [bufInput+1+2], '0'
        jb      Error

        ;Letter test
        mov     bl,     [bufInput+1]
        cmp     [(bufInput+1)+(bx-2)], 'z'
        ja      Error
        cmp     [(bufInput+1)+(bx-2)], 'A'
        jb      Error

Sucsess:
        ;Print \n \r for windows
        mov     ah,     $02
        mov     dl,     10
        int     21h
        mov     dl,     13
        int     21h

        ;Display string
        mov     ah,    $09
        mov     dx,    YesStr
        int     21h

        jmp     Escape

Error:
        ;Print \n \r for windows
        mov     ah,     $02
        mov     dl,     10
        int     21h
        mov     dl,     13
        int     21h

        ;Display string
        mov     ah,    $09
        mov     dx,    NoStr
        int     21h

        jmp     Escape

Escape:
        ;Waiting
        mov     ah,     $08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ret

bufInput db 11, 0, 12 dup('$')
TaskStr db  'Enter string: $'
NoStr  db 'No =[$'
YesStr db 'Yes!$'