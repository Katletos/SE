        org 100h
EntryPoint:
        ;Input string
        mov     ah,    $0A
        mov     dx,    bufInput
        int     21h
        
        ;Print \n \r for windows
        mov     ah,     $02
        mov     dl,     10
        int     21h
        mov     dl,     13
        int     21h

        ;Swap symbols
        mov     al,     [bufInput+1+2]
        mov     cl,     [bufInput+1+8]
        mov     [bufInput+1+2], cl
        mov     [bufInput+1+8], al

        ;Calculations with symbols
        mov     al,     [bufInput+1+3]
        sub     al,     [bufInput+1+5]
        add     cl,     [bufInput+1+7]
        mov     [bufInput+1+6], cl

        ;Print String
        mov     ah,     $09
        mov     dx,     bufInput+2
        int     21h

        mov     ah,     $08
        int     21h

        ret
bufInput db 10,0, 11 dup('$')
