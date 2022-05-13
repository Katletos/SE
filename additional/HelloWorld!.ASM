        org 100h

Start:
        mov ah, $09
        mov dx, strHello
        int 21h

        mov ah,$08
        int 21h
        ret

strHello
        db "Hello, world!$"

