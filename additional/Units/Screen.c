proc Screen.Clear
     mov        ah, $0F
     int        10h
     movzx      bx, al

     cmp        bx, Screen.Clear.ModeCount
     jae        .EndProc

     shl        bx, 1
     mov        bx, [Screen.Clear.Impls + bx]
     test       bx, bx
     jz         .EndProc

     stdcall    bx

.EndProc:
     ret
endp

Screen.Clear.Impls      dw      nil, nil, nil, Screen.Clear.Mode03h,\
                                nil, nil, nil, nil,\
                                nil, nil, nil, nil,\
                                nil, nil, nil, nil,\
                                nil, nil, nil, Screen.Clear.Mode13h
Screen.Clear.ModeCount  = ($ - Screen.Clear.Impls) / 2

proc Screen.Clear.Mode03h uses es di
     push       $B800
     pop        es
     mov        cx, 80 * 25
     xor        ax, ax
     xor        di, di
     rep stosw
     ret
endp

proc Screen.Clear.Mode13h uses es di
     push       $A000
     pop        es
     mov        cx, 320 * 200 / 2
     xor        ax, ax
     xor        di, di
     rep stosw
     ret
endp

proc Screen.Rectangle uses es di,\
     x, y, w, h, color: BYTE

     push       $A000
     pop        es
     mov        al, [color]
     imul       di, [y], 320
     add        di, [x]

     mov        cx, [h]
.RowLoop:
     push       cx
     mov        cx, [w]
     rep stosb
     pop        cx
     sub        di, [w]
     add        di, 320
     loop       .RowLoop
     ret
endp

proc Screen.WriteString uses es si di,\
     ofsString, nLine, alAlign, bAttr: BYTE

     push       $B800
     pop        es
     mov        di, 80 * 2
     imul       di, [nLine]

     mov        si, [ofsString]
     lodsb
     movzx      cx, al

     mov        ax, [alAlign]
     cmp        ax, alLeft
     je         .DoWriteString

     mov        dx, 80
     sub        dx, cx
     cmp        ax, alRight
     je         @F
     shr        dx, 1
@@:
     shl        dx, 1
     add        di, dx
.DoWriteString:

     mov        ah, [bAttr]
.WriteLoop:
     lodsb
     stosw
     loop       .WriteLoop
     ret
endp

proc Screen.SetMode uses si di,\
     wModeInfo

     mov        ah, $0F
     int        10h
     mov        dl, al
     mov        dh, bh

     movzx      ax, byte [wModeInfo]
     int        10h
     mov        ah, $05
     mov        al, byte [wModeInfo + 1]
     int        10h

     mov        ax, dx
     ret
endp