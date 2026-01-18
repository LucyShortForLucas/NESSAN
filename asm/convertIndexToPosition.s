;; IMPORTS AND EXPORTS
.export ConvertIndexToPosition

.importzp math_buffer      

; ------------------------------------------------------------------------

.segment "CODE"

; input: Index in register A
; using registers: A & X & math_buffer+7
; output: in X
ConvertIndexToPosition:
    tax ; load into x, index
    dex ; x-1 | if amount = 1 go to index 0
    ; Now lets say index is 0 1 2
    txa ; load back int a
    asl ; bitshift left, thus 0 -> 0, 1 -> 2, 2 -> 4
    
    sta math_buffer+7
    txa ; store bitshift index and load index into a
    clc ; ensure carry is 0
    adc math_buffer+7 ; add bitshift index to index, thus 0->0, 2 -> 3, 4 -> 6

    tax 
    inx; add 1 to the amount to get the position of the first element 
    rts ; return