.export aabb_collision
.importzp math_buffer

.segment "CODE"

; aabb_collison
; input: mathbuffer in the following order:
; a_X 0, a_Y 1, a_width 2, a_height 3
; b_X 4, b_Y 5, b_width 6, b_height 7
; out: carry set if collision, no carry if no collision

aabb_collision:
    ; x overlap 1
    lda math_buffer+4 ; b_X
    clc 
    adc math_buffer+6 ; + b_width
    cmp math_buffer+0 ; a_X
    bcc no_collision

    ; x overlap 2
    lda math_buffer+0 ; a_X
    clc
    adc math_buffer+2 ; + a_width
    cmp math_buffer+4 ; b_X 
    bcc no_collision

    ; y overlap 1
    lda math_buffer+5 ; b_Y
    clc
    adc math_buffer+7 ; + b_height
    cmp math_buffer+1 ; a_Y
    bcc no_collision

    ; y overlap 2
    lda math_buffer+1 ; a_Y
    clc
    adc math_buffer+3 ; + a_height
    cmp math_buffer+5 ; b_Y
    bcc no_collision

; collision!
    sec ; set carry to indicate collision
    rts

no_collision:
    clc ; clear carry to indicate no collision
    rts