.export aabb_collision
.export wall_collisions

.importzp math_buffer
.importzp ptr

.import collision_aabb_2x2
.import collision_aabb_2x3
.import collision_aabb_3x3
.import collision_aabb_9x2

.segment "CODE"

.include "consts.s"

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


; collider_types format:
; [0] width
; [1] height
; [2] table_lo
; [3] table_hi

wall_collider_types: ; This table describes the properties of the varies collider types, making adding more sizes of collider trivial
    .byte $10, $10, <collision_aabb_2x2, >collision_aabb_2x2
    .byte $10, $18, <collision_aabb_2x3, >collision_aabb_2x3
    .byte $18, $18, <collision_aabb_3x3, >collision_aabb_3x3
    .byte $48, $10, <collision_aabb_9x2, >collision_aabb_9x2



; This subroutine checks an aabb against ALL level colliders that represent the walls.
; Uses math_buffer 0-3 as described above, to define the collider to check against. Mangles the rest
; Sets the Carry bit if ANY collider was hit, unsets it otherwise

wall_collisions:
    lda math_buffer + 0 ; check x out of bounds
    cmp #8 ; check left bound
    bcc @set_and_return
    cmp #240
    bcs @set_and_return

    lda math_buffer + 1 ; check x out of bounds
    cmp #16 ; check left bound
    bcc @set_and_return
    cmp #216
    bcs @set_and_return

    jmp @no_return

@set_and_return:
    sec
    rts

@no_return:

    ldx #0

type_loop: ; choose collider type
    cpx #WALL_COLLIDER_TYPES*4
    beq @return_clear_carry ; All colliders finished, none hit.

    lda wall_collider_types,x
    sta math_buffer+6 ; load width
    inx
    lda wall_collider_types,x
    sta math_buffer+7 ; load height
    inx
    lda wall_collider_types,x
    sta ptr ; load in pointer to the appropriate collider buffer
    inx
    lda wall_collider_types,x
    sta ptr+1 ; pointer hi-byte
    inx

    ldy #0 ; must use indirect indexed adressing with y = 0, because regular indirect adressing ONLY works with JMP (for some arcane reason that is beyond me)
    lda (ptr), y          ; load count
    asl ; double the count (2 bytes per item so effective byte count is doubled)
    tay
@no_overflow:

@coll_loop:
    beq type_loop

    lda (ptr),y
    asl
    asl
    asl ; mulitply by 8
    sta math_buffer+5 ; load true y
    dey
    lda (ptr),y
    asl
    asl
    asl ; mulitply by 8
    sta math_buffer+4 ; load true x

    jsr aabb_collision
    bcs @return ; Hit found, return. Carry is already set by collision check

    dey
    bne @coll_loop
    jmp type_loop

@return_clear_carry:
    clc ; clear carry and return = No hit
@return:
    rts