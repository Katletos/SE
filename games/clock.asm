; WARNING!
;
; The line drawing algorithm used here is chosen for simplicity, not efficiency.
; Real-world applications use DDA, Bresenham’s line drawing algorithm or even more
; sophisticated solutions.
;

        org 100h

        include 'macro\proc16.inc'

EntryPoint:
     stdcall    Screen.SetMode, $0013
     mov        [wOldMode], ax

.PaintLoop:
     mov        ah, $2C
     int        21h
     movzx      ax, ch
     movzx      cx, cl
     movzx      dx, dh

     cmp        [wOldHours], ax
     jne        .Draw
     cmp        [wOldMinutes], cx
     jne        .Draw
     cmp        [wOldSeconds], dx
     je         @F
.Draw:
     mov        [wOldHours], ax
     mov        [wOldMinutes], cx
     mov        [wOldSeconds], dx
     stdcall    Screen.Clear
     stdcall    DrawClock, [wOldHours], [wOldMinutes], [wOldSeconds]
@@:

     mov        ah, $01
     int        16h
     jz         .PaintLoop
     xor        ax, ax
     int        16h

     stdcall    Screen.SetMode, [wOldMode]
     ret

wOldHours       dw      ?
wOldMinutes     dw      ?
wOldSeconds     dw      ?

proc DrawClock\
     wHours, wMinutes, wSeconds

     stdcall    DrawClockFace, 99, $30

     cmp        [wHours], 12
     jb         @F
     sub        [wHours], 12
@@:
     stdcall    DrawClockHand,   [wHours], 12, 50, $40
     stdcall    DrawClockHand, [wMinutes], 60, 70, $50
     stdcall    DrawClockHand, [wSeconds], 60, 90, $60

     ret
endp

proc DrawClockFace uses es di,\
     wRadius, bColor

     locals
        iPixel          dw      ?
        nPixels         dw      ?
        x               dw      ?
        y               dw      ?
     endl

     push       $A000
     pop        es
     mov        [iPixel], 0
     mov        cx, 60
     mov        [nPixels], cx
     mov        al, byte [bColor]

     fldpi                              ; => [Pi]
     fadd       st0, st0                ; => [2 * Pi]
.PixelLoop:
     fild       [iPixel]                ; => [2 * Pi] [iPixel]
     fidiv      [nPixels]               ; => [2 * Pi] [iPixel / nPixels]
     fmul       st0, st1                ; => [2 * Pi] [fAngle]
     fsincos                            ; => [2 * Pi] [Sin] [Cos]
     fimul      [wRadius]               ; => [2 * Pi] [Sin] [R * Cos]
     fistp      [y]                     ; => [2 * Pi] [Sin]
     fimul      [wRadius]               ; => [2 * Pi] [R * Sin]
     fistp      [x]                     ; => [2 * Pi]

     mov        di, 100
     sub        di, [y]
     imul       di, di, 320
     add        di, [x]
     add        di, 160
     stosb

     inc        [iPixel]
     loop       .PixelLoop

     fstp       st0                     ; =>
     ret
endp

proc DrawClockHand uses es di,\
     wCurr, wTotal, wLength, bColor

     locals
        iPixel          dw      ?
        nPixels         dw      ?
        x               dw      ?
        y               dw      ?
     endl

     push       $A000
     pop        es

     mov        cx, [wLength]
     shl        cx, 1
     mov        [iPixel], 0
     mov        [nPixels], cx
     mov        al, byte [bColor]

     fild       [wCurr]                 ; => [wCurr]
     fidiv      [wTotal]                ; => [wCurr / wTotal]
     fldpi                              ; => [wCurr / wTotal] [Pi]
     fadd       st0, st0                ; => [wCurr / wTotal] [2 * Pi]
     fmulp                              ; => [fAngle]
     fsincos                            ; => [Sin] [Cos]

.PixelLoop:
     fild       [iPixel]                ; => [Sin] [Cos] [iPixel]
     fidiv      [nPixels]               ; => [Sin] [Cos] [iPixel / nPixels]
     fimul      [wLength]               ; => [Sin] [Cos] [R]
     fld        st0                     ; => [Sin] [Cos] [R] [R]
     fmul       st0, st2                ; => [Sin] [Cos] [R] [R * Cos]
     fistp      [y]                     ; => [Sin] [Cos] [R]
     fmul       st0, st2                ; => [Sin] [Cos] [R * Sin]
     fistp      [x]                     ; => [Sin] [Cos]

     mov        di, 100
     sub        di, [y]
     imul       di, di, 320
     add        di, [x]
     add        di, 160
     stosb

     inc        [iPixel]
     loop       .PixelLoop

     fstp       st0                     ; => [Sin]
     fstp       st0                     ; =>
     ret
endp

wOldMode        dw      ?

proc Keyboard.ReadKey
     mov        ax, $0C08
     int        21h
     movzx      dx, al
     test       al, al
     jnz        @F
     mov        ah, $08
     int        21h
     mov        dh, al
@@:
     mov        ax, dx
     ret
endp

proc Screen.SetMode uses bx,\
     wModeInfo

     mov        ah, $0F
     int        10h
     mov        bl, al

     movzx      ax, byte [wModeInfo]
     int        10h

     mov        ah, $05
     mov        al, byte [wModeInfo + 1]
     int        10h

     mov        ax, bx
     ret
endp

proc Screen.Clear uses es di
     push       $A000
     pop        es
     xor        ax, ax
     xor        di, di
     mov        cx, 320 * 200
     rep stosb
     ret
endp
