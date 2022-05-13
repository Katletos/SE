        org 100h
Start:
        ;Enter name
        mov     ah,    $09
        mov     dx,    strEnter
        int     21h

        ;Buf input
        mov     ah,     $0A
        mov     dx,     bufInput
        int     21h

        ;Print \n \r for windows
        mov     ah,     $02
        mov     dl,     10
        int     21h
        mov     dl,     13
        int     21h

        ;Display string
        mov     ah,    $09
        mov     dx,    strHello
        int     21h

        ;Display string
        mov     ah,    $09
        mov     dx,    bufInput+1+1
        int     21h

        ;Waiting
        mov     ah,     $08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ret

strEnter     db  'Enter your name: $'
strHello     db  'Hello, $'
bufInput     db  13, 0, 13 dup('$')


