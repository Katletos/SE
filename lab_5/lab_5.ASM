        org     100h
EntryPoint:

        mov     al,     [SearchWord]
        mov     di,     String
        mov     cx,     StrLen
@@:
        repne scasb

        jne     .exit

        mov     dx,     di
        sub     dx,     String

        push    dx
        call    PrintChar

        cmp     cx,     0
        jnz     @B
.exit:
        call    Waiting
        ret

num_input:
        xor     bx,     bx
        xor     cx,     cx
        mov     dl,     1

.input:
        mov     ah,     01h ;функцияя ввода char
        int     21h
        cmp     al,     0Dh   ; проверка на Enter
        je      @F
        sub     al,     30h
        mov     ah,     0
        push    ax      ;цифру в стек
        inc     cx
        jmp     .input
 
@@:     pop     ax      ; достаём цифру из стека
        mul     dl      ; умножаем на множитель
        add     bx,     ax  ;складываем результат и то, что было
        mov     ax,     dx
        mov     dx,     10
        mul     dl      ;умножаем множитель на 10
        mov     dx,     ax
        loop    @B

        mov     ax,     bx
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Выводит число в регистре ax, регистры не трогает
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
num_output:
        push    bp
        mov     bp,     sp

        push    ax
        push    bx
        push    cx
        push    dx

        mov     ax,     [bp+4]

        mov     bx,     10
        mov     cx,     0

@@:
        mov     dx,     0
        div     bx
        push    dx
        inc     cx
        cmp     ax,     0
        jnz     @B

@@:
        pop     dx
        add     dx,     '0'
        mov     ah,     02h
        int     21h
        loop    @B

        pop     dx
        pop     cx
        pop     bx
        pop     ax

        pop     bp
        ret     2


PrintChar:
        push    bp
        mov     bp,     sp

        pusha

        mov     dx,     [bp+4]

        mov     ah,     $02
        add     dx,     '0'
        int     21h

        popa

        pop     bp
        ret     2

Waiting:
        mov     ah,     $08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ret

SearchWord: db '/'
String: db '1/34/67/9'
StrLen = $ - String
