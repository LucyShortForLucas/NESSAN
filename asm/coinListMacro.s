; uses list_pickup  0th element for how many are active, max 3 coins: 1th for x, 2st for y, 3nd for type, then next coin...

.macro CheckForCoinCollision player_x, player_y
.scope
    clc
    lda list_pickup ; load amount into pickup
    beq @endCoinCollision ; if 0 then we're done! nothing to check!

    jsr ConvertIndexToPosition

    ; put player x into math_buffer so we can use it now that it's free!
    lda player_x
    sta math_buffer+0
    
    ; load player
    lda player_y
    sta math_buffer+1
    lda #16
    sta math_buffer+2
    lda #16
    sta math_buffer+3
    ; lets first load width and height of coin
    lda #8 ; width
    sta math_buffer+6
    lda #8 ; height
    sta math_buffer+7


@coinCollisionLoop: ; loop over each item and check collision
    lda list_pickup, x
    sta math_buffer+4 ; set x
    lda list_pickup+1, x
    sta math_buffer+5 ; set y
    jsr aabb_collision ; gets carry  bit if hit
    bcs @coinHit
    dex 
    dex 
    dex ; -3 for next 
    bpl @coinCollisionLoop ; branch if not negative, aka more to loop
    ; no hit :(
    clc 
    jmp @endCoinCollision
    @coinHit:
    ; load index into mathbuffer
    txa 
    sta math_buffer
    sec ; set the carry
    @endCoinCollision:
.endscope
.endmacro



; input: x_pos, y_pos, type as direct values
; uses a and x register
; output: None
.macro AddItemToPickupList x_pos, y_pos, type
.scope
    clc
    lda list_pickup
    adc #1
    cmp #3
    bcs @skipAddCoin
    jsr ConvertIndexToPosition
    ; can't add coin, max reached 
    ; add coin at position
    lda #x_pos
    sta list_pickup, x
    lda #y_pos
    sta list_pickup+1, x
    lda #type
    sta list_pickup+2, x
@skipAddCoin:
.endscope
.endmacro
