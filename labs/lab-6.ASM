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


        ;�������� ���������� ����� ����, ������� �����
        push    [X]
        push    [Y]
        push    [Z]
        call    CalcExpression
        push    ax
        call    Console.NumOutput
        call    Console.PrintCRLF

        ;�������� ���������� ����� ��������, ������� �����
        mov     ax,     [X]
        mov     bx,     [Y]
        mov     dx,     [Z]
        call    far     Procedures:CalcExpressionRegisters
        push    ax
        call    Console.NumOutput
        call    Console.PrintCRLF

        ;�������� ���������� ����� ���������� ����������,
        ;������� �����
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
        mul     ax      ;���������� � �������

        shl     ax,     1 ;��������� �� 2
        add     ax,     [bp+6] ;�������� Y

        mov     bx,     ax;��������� ���������

        mov     ax,     5; �������� �� 5
        mov     dx,      [bp+4] ;Z
        mul     dx

        sub     bx,     ax

        mov     cx,     [bp+8]
@@:
        rol     bx,     1
        loop    @B   ;����� �� � ���

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
        mov     ah,     01h ;�������� ����� char
        int     21h
        cmp     al,     0Dh   ; �������� �� Enter
        je      @F
        sub     al,     30h
        mov     ah,     0
        push    ax      ;����� � ����
        inc     cx
        jmp     .input
 
@@:     pop     ax      ; ������ ����� �� �����
        mul     dl      ; �������� �� ���������
        add     bx,     ax  ;���������� ��������� � ��, ��� ����
        mov     ax,     dx
        mov     dx,     10
        mul     dl      ;�������� ��������� �� 10
        mov     dx,     ax
        loop    @B

        mov     ax,     bx
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ������� ����� � �������� ax, �������� �� �������
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
        mul     ax      ;���������� � �������
        shl     ax,     1 ;��������� �� 2
        add     ax,     [Y] ;�������� Y

        mov     bx,     ax;��������� ���������

        mov     ax,     5; �������� �� 5
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

        retf                         ;��, ������ retf, ��� retFar

CalcExpressionRegisters:
        ;ax-x
        ;bx-y
        ;dx-z
        mov     cx,     ax
        push    dx
        mul     ax      ;���������� � �������
        shl     ax,     1 ;��������� �� 2
        add     ax,     bx ;�������� Y

        mov     bx,     ax;��������� ���������

        mov     ax,     5; �������� �� 5
        pop     dx
        mul     dx
        sub     bx,     ax

@@:
        rol     bx,     1
        loop    @B

        mov     ax,     bx

        retf