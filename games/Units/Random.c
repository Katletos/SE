proc Random.Initialize
     mov        ah, $2C
     int        21h
     mov        [Random.wPrevNumber], dx
     ret
endp

proc Random.Get\
     wMin, wMax

     mov        ax, [Random.wPrevNumber]
     rol        ax, 7
     adc        ax, 23
     mov        [Random.wPrevNumber], ax

     mov        cx, [wMax]
     sub        cx, [wMin]
     inc        cx
     xor        dx, dx
     div        cx
     add        dx, [wMin]
     mov        ax, dx
     ret
endp