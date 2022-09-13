- [Лабораторная работа №1](#лабораторная-работа-№1)
- [Лабораторная работа №2](#лабораторная-работа-№2)
- [Лабораторная работа №3](#лабораторная-работа-№3)
- [Лабораторная работа №4](#лабораторная-работа-№4)
- [Лабораторная работа №5](#лабораторная-работа-№5)
- [Лабораторная работа №6](#лабораторная-работа-№6)
- [Лабораторная работа №7](#лабораторная-работа-№7)
- [Лабораторная работа №8](#лабораторная-работа-№8)
 
## Лабораторная работа №1
### Задание
Разработать программу на языке ассемблера, которая запрашивает у пользователя ввод произвольного текста (строки), преобразует введённую строку в соответствии с вариантом и выводит полученную строку на экран. Считать, что пользователь всегда вводит строку достаточной длины. Вычисления выполняются над кодами символов. Перед вводом строки вывести поясняющий текст. После вывода результата дождаться нажатия клавиши. При изменении строки использовать обращение к памяти различными способами.

> S[2] ↔ S[8], S[6] ← S[7] + (S[3] – S[5])

В таблице вариантов S[i] означает i-й символ строки. Действия обозначены следующим образом: a ↔ b — поменять местами a и b; a ← b — в a записать значение b.
### Текст программы
```assembly
        org 100h

EntryPoint:
        ;Input string
        mov ah, $0A
        mov dx, bufInput
        int 21h

        ;Print \n \r for windows
        mov ah, $02
        mov dl, 10
        int 21h
        mov dl, 13
        int 21h

        ;Swap symbols
        mov al, [bufInput+1+2]
        mov cl, [bufInput+1+8]
        mov [bufInput+1+2], cl
        mov [bufInput+1+8], al

        ;Calculations with symbols
        mov al, [bufInput+1+3]
        sub al, [bufInput+1+5]
        add cl, [bufInput+1+7]
        mov [bufInput+1+6], cl

        ;Print String
        mov ah, $09
        mov dx, bufInput+2
        int 21h
        mov ah, $08
        int 21h
        ret

bufInput db 10,0, 11 dup('$')
```

## Лабораторная работа №2
### Задание
Разветвляющиеся алгоритмы и пользовательский ввод
Постановка задачи Разработать программу, проверяющую на корректность введённую пользователем строку. Ответ вывести в формате: «Yes» или «No».
Выбор варианта Требования к вводимым строкам задаются в таблице по вариантам. Условные обозначения: L, — длина строки, S[1] — 1-Й символ строки.
В колонке «Длина строки» указаны требования к длине строки, введённой пользователем.
В колонке «Равные символы» указаны (нумерация начинается с 1), которые должны совпадать. Например, если в
этой колонке указано «З и 8», третий символ строки должен совпадать с
индексы символов строки
восьмым. другие требования к
В колонке «Другие требования» указаны символам строки. Буквами считать заглавные буквы латинского алфавита.
Требования к программе Программа не должна позволять пользователю ввести строку, длина которой заведомо больше, чем длина корректной строки. Например, если требования  длине строки заданы как «15 < L < 18», пользователю нужно
запретить ввод более чем 17 символов.
Требования к исходному коду Для ввода строки использовать функцию ОАh операционной системы
М5-DOS. Буфер для вводимой строки должен быть объявлен как неинициализированные данные (байт максимальной длины может быть инициализирован).
Вариант 15 Длина строки 3 <= L <= 10, равные 1 и 3 символы, S[2] - цифра S[L-2] - буква.
### Текст программы
```assembly
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
```

## Лабораторная работа №3
### Задание
В одномерном массиве заменить отрицательные элементы нулями. Подсчитать число замен и вывести на экран полученный массив. Массив задать в сегменте данных.
### Текст программы
```assembly

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
        ;two's complement
        not     dl
        add     dl, 1
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
```

## Лабораторная работа №4
### Задание
Дан целочисленный одномерный массив. Вывести на экран четные элементы массива и подсчитать их количество.
### Текст программы
```assembly
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
        jnz     .ifPositiveNumber

        mov     dl, '-'
        int     21h

        mov     byte dl, [bx]
        ;Ïåðåâîä â ïðÿìîé êîä
        not     dl
        add     dl, 1

.ifPositiveNumber:
        add     dl, '0'
        int     21h
.Odd:
        inc     bx
        loop    @B
        ret
        

PrintArr:
        mov     ah, $02
        mov     cx, SIZE
@@:
        mov     dl, [bx]

        test    dl, dl
        jns     .ifPositiveNumber

        mov     dl, '-'
        int     21h

        mov     dl, [bx]
        not     dl
        add     dl, 1

.ifPositiveNumber:
        add     dl, '0'
        int     21h

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
```

## Лабораторная работа №5
### Задание
Вывести номера указанного элемента в строке. (использовать команду scas). Строку описать в сегменте данных.
### Текст программы
```assembly
        org     100h
EntryPoint:

        mov     al,     [SearchWord]
        mov     di,     String
        mov     cx,     StrLen
@@:
        repne scasb

        mov     dx,     di ;scabs возвращает адрес памяти в di
        sub     dx,     String

        push    dx
        call    PrintChar

        test    cx,     cx
        jnz     @B

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


; Выводит число в регистре ax, регистры не трогает
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
```

## Лабораторная работа №6
### Задание
Для ряссчитаиного варианта индивидуального задания написать ня языке Ассемблер и отлядить три программы, содержящие процедуру. 
Программы различаются между собой способом передачи параметров в проиедуру и типом процедуры: 
- Программа 1 Передача параметров через регистр. Тип процедуры -дальний. 
- Программа 2. Передача параметров через глобальные переменные. Тип процедуры -дальний. 
- Программа З. Передача параметров через стек. Тип процедуры -ближний. 

В программе предусмотреть ввод данных в соответствии с вариантом индивидуального задания, передачу этих данных в процедуру заданного типа с 
использованием соответствующего способа передачи параметров и необходимые в соответствии с вариантом вычисления в теле процедуры. 
Программа должна содержать комментарии для каждой команды. 

Варианты индивидуальных заданий:

15. Ввести три 16-битовых целых числа: X, Y и Z. Вычеслить результат циклического сдвига влево значения выражения 2*X^2+Y-5*Z на количество битов, равное числу X.

### Текст программы
```assembly
        Format  MZ
        entry Main:CallingProgram
;----------------------------------------

segment Main
CallingProgram:

        mov     ax,      cs
        mov     ds,      ax

        push    str_task
        call    Console.DisplayStr
        call    Console.PrintCRLF


        push    str_x
        call    Console.DisplayStr
        call    Console.NumInput
        mov     [X],     ax
        call    Console.PrintCRLF

        push    str_y
        call    Console.DisplayStr
        call    Console.NumInput
        mov     [Y],     ax
        call    Console.PrintCRLF

        push    str_z
        call    Console.DisplayStr
        call    Console.NumInput
        mov     [Z],     ax
        call    Console.PrintCRLF


        ;передача параметров через стек, ближний вызов
        push    [X]
        push    [Y]
        push    [Z]
        call    CalcExpression
        push    ax
        call    Console.NumOutput
        call    Console.PrintCRLF

        ;передача параметров через регистры, дальний вызов
        mov     ax,     [X]
        mov     bx,     [Y]
        mov     dx,     [Z]
        call    far     Procedures:CalcExpressionRegisters
        push    ax
        call    Console.NumOutput
        call    Console.PrintCRLF

        ;передача параметров через глобальные переменные,
        ;дальний вызов
        call    far     Procedures:CalcExpressionGlobal
        push    ax
        call    Console.NumOutput
        call    Console.PrintCRLF

        call    Console.ReadKey

        mov     ah,     4Ch
        int     21h
;----------------------------------------
CalcExpression:
        push    bp
        mov     bp,     sp

        push    bx
        push    dx

        mov     ax,     [bp+8]; X
        mul     ax      ;возведение в квадрат

        shl     ax,     1 ;умножение на 2
        add     ax,     [bp+6] ;добавить Y

        mov     bx,     ax;сохраняем результат

        mov     ax,     5; умножить на 5
        mov     dx,      [bp+4] ;Z
        mul     dx

        sub     bx,     ax

        mov     cx,     [bp+8]
@@:
        rol     bx,     1
        loop    @B   ;сдвиг на Х бит

        mov     ax,     bx

        pop     dx
        pop     bx

        pop     bp
        ret     6


Console.NumInput:
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
Console.NumOutput:
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
;----------------------------------------
Console.PrintCRLF:
        push    ax
        push    dx

        mov     ah,     09h
        mov     dx,     str_crlf
        int     21h

        pop     dx
        pop     ax
        ret

Console.DisplayStr:
        push    bp
        mov     bp,     sp

        mov     dx,     [bp+4]

        mov     ah,     09h
        int     21h

        pop     bp
        ret     2

Console.ReadKey:
        ;ret pressed button
        mov     ax,     0C08h
        int     21h
        movzx   cx,     al
        test    al,     al
        jnz     @F
        mov     ah,     08h
        int     21h
        mov     ch,     al
@@:
        mov     ax,     cx
        ret

Console.Waiting:
        waiting:
        mov     ah,     08h
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     08h
        int     21h
@@:
        ret

str_crlf:     db 10, 13, '$'
str_task:     db 'Enter X, Y, Z and get rol expression 2*X^2+Y-5*Z by X bit', '$'
str_x:        db 'Input X: ', '$'
str_y:        db 'Input Y: ', '$'
str_z:        db 'Input Z: ', '$'

X dw ?
Y dw ?
Z dw ?
;----------------------------------------
segment Procedures
CalcExpressionGlobal:

        push    bx
        push    dx

        mov     ax,     [X]; X
        mul     ax      ;возведение в квадрат
        shl     ax,     1 ;умножение на 2
        add     ax,     [Y] ;добавить Y

        mov     bx,     ax;сохраняем результат

        mov     ax,     5; умножить на 5
        mov     dx,     [Z] ;Z
        mul     dx

        sub     bx,     ax

        mov     cx,     [X]
@@:
        rol     bx,     1
        loop    @B

        mov     ax,     bx

        pop     dx
        pop     bx

        retf                         ;Да, теперь retf, ибо retFar

CalcExpressionRegisters:
        ;ax-x
        ;bx-y
        ;dx-z
        mov     cx,     ax
        push    dx
        mul     ax      ;возведение в квадрат
        shl     ax,     1 ;умножение на 2
        add     ax,     bx ;добавить Y

        mov     bx,     ax;сохраняем результат

        mov     ax,     5; умножить на 5
        pop     dx
        mul     dx
        sub     bx,     ax

@@:
        rol     bx,     1
        loop    @B

        mov     ax,     bx

        retf
```

## Лабораторная работа №7
### Задание
Разработать программу на Delphi с использованием ассемблерной вставки
### Текст программы
```
program laba4;
{$APPTYPE CONSOLE}

uses
  SysUtils;

Const
  N = 9;

Type
  Tarr = array [1 .. N] of integer;

Var
  Arr: Tarr;
  i: integer;
  sum: integer;

begin
  randomize;

  for i := Low(Arr) to High(Arr) do
  begin
    Arr[i] := random(400);
    write(Arr[i]:8);
  end;

  sum := 0;

  asm
    mov ebx, 0 // start with a[1]
    mov ecx, N/2 + 1
    mov eax, sum
    mov esi, 1

  @Sum:
    add eax, dword[Arr[ebx*4]]
    add ebx, 2
    loop @Sum
    mov dword[sum], eax
  end;

  writeln;
  write('Sum of elems: ');
  for i := 1 to N - 2 do
  begin
    if (i mod 2) <> 0 then
    begin
      write(Arr[i], '+');
    end;
  end;

  if (N mod 2 = 0) then
  begin
    write(Arr[N - 1], '=');
  end
  else
  begin
    write(Arr[N], '=');
  end;
  writeln(sum);
  readln;

end.
```

## Лабораторная работа №8
### Задание
Разработать программу использующую видеорежим операционной системы MS-DOS
### Текст программы
```assembly
        org 100h

        mov     ah,     0Fh
        int     10h
        mov     [bOldMode], al
        mov     [bOldPage], bh

        mov     ax,     $0013
        int     10h

        push    $A000
        pop     es
        mov     di,     320*20+80

        mov     cx,     16
        mov     al,     16
Start:
        push    cx
        mov     cx,     8
Square:
        push    cx
        sub     al,     16
        mov     cx,     16

Line:
        push    cx
        mov     cx,     8
        rep     stosb
        pop     cx
        add     di,     2
        add     al,     1
        loop    Line

        add     di,     320-160
        pop     cx
        loop    Square

        add     di,     320*2
        add     al,     16
        pop     cx
        loop    Start

        mov     ax,     0C08h
        int     21h
        test    al,     al
        jnz     @F
        mov     ah,     08h
        int     21h
        @@:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        movzx   ax,     [bOldMode]
        int     10h
        mov     ah,     05h
        mov     al,     [bOldPage]
        int     10h
        ret

bOldMode db ?
bOldPage db ?
```
