Написать игру «Отгадай число». Компьютер загадывает число от 1 до 100 включительно. Пользователю даётся 10 попыток, чтобы его отгадать. Каждая попытка заключается в том, то пользователь вводит предполагаемое число и получает один из ответов:
Задуманное число больше.
Задуманное число меньше.
Число отгадано.


Если число не удалось отгадать с 10 попыток, выводится сообщение:
Число NN не отгадано с 10 попыток. (NN — искомое число)


Некорректный ввод (всё, кроме чисел от 1 до 100 включительно) попыткой не считать.


Идеи для повышения сложности:
Придумать способ начисления очков за каждый ход.
Реализовать игру в обратном направлении: человек загадывает, программа отгадывает. Предусмотреть возможность того, что человек будет пытаться обмануть программу.
Добавить таблицу рекордов с её сохранением в файл и загрузкой из файла.

```assembly
        org     100h
calling_proc:

        push    str_rules
        call    display_str
        call    print_crlf

        mov     cx,     attempts;êîëè÷åñòâî ïîïûòîê
@@:
        push    str_input
        call    display_str

        call    num_input       ;÷èñëî -> ax
      ;  mov     [input], ax
        call    print_crlf

      ;  mov     ax,     [input]
        cmp     ax,     [rnd_number]  ;ñðàâíåíèå ââåä¸ííîãî ÷èñëà ñ ñãåíåðèðîâàííûì
        jg      .greater
        jl      .less
        je      .win

.greater:
        push    str_greater
        call    display_str
        call    print_crlf
        jmp     .iteration

.less:
        push    str_less
        call    display_str
        call    print_crlf
        jmp     .iteration

.iteration:
        loop    @B

.lose:
        push    str_loose_1
        call    display_str

        push    word [rnd_number]
        call    num_output

        push    str_loose_2
        call    display_str

        call    print_crlf
        call    waiting
        ret

.win:
        push    str_win
        call    display_str
        call    waiting
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;íè÷åãî íå ïðîñèò, ââîäèò ÷èñëî è ïèõàåò åãî â ax, ðåãèñòðû íå òðîãàåò
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
num_input:


        xor     bx,     bx
        xor     cx,     cx
        mov     dl,     1

.input:
        mov     ah,     01h ;ôóíêöèÿÿ ââîäà char
        int     21h
        cmp     al,     0Dh   ; ïðîâåðêà íà Enter
        je      @F
        sub     al,     30h
        mov     ah,     0
        push    ax      ;öèôðó â ñòåê
        inc     cx
        jmp     .input
 
@@:     pop     ax      ; äîñòà¸ì öèôðó èç ñòåêà
        mul     dl      ; óìíîæàåì íà ìíîæèòåëü
        add     bx,     ax  ;ñêëàäûâàåì ðåçóëüòàò è òî, ÷òî áûëî
        mov     ax,     dx
        mov     dx,     10
        mul     dl      ;óìíîæàåì ìíîæèòåëü íà 10
        mov     dx,     ax
        loop    @B

        mov     ax,     bx
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Âûâîäèò ÷èñëî â ðåãèñòðå ax, ðåãèñòðû íå òðîãàåò
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_str:
        push    bp
        mov     bp,    sp

        mov     dx,    [bp+4]

        mov     ah,    $09
        int     21h

        pop     bp
        ret     2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_crlf:
        push    ax
        push    dx

        mov     ah,     $09
        mov     dx,     str_crlf
        int     21h

        pop     dx
        pop     ax
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
waiting:
        mov     ah,     $08
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     $08
        int     21h
@@:
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
str_rules:    db 'Try to guess the number 1 out of 100$'
str_input:    db 'Input number: $'
str_greater:  db 'The intended number is greater$'
str_less:     db 'The intended number is less$'
str_win:      db 'Number guessed$'

str_loose_1:  db 'Number $'
str_loose_2:  db ' is not guessed after 10 attempts$'

str_crlf:     db 10, 13, '$'

rnd_number:   dw 42
input:        dw 0
attempts      =  10
```
