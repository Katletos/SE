proc Keyboard.ReadKey
     mov        ax, $0C08
     int        21h
     movzx      cx, al
     test       al, al
     jnz        @F
     mov        ah, $08
     int        21h
     mov        ch, al
@@:
     mov        ax, cx
     ret
endp
