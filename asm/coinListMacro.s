; uses list_pickup  0th element for how many are active, max 3 coins: 1th for x, 2st for y, 3nd for type, then next coin...

.macro CheckForCoinCollision player_x, player_y
.scope
    clc 
    lda list_pickup ; load amount into pickup
    beq @end_coin_collision ; if 0 then we're done! nothing to check!

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


@coin_collision_loop: ; loop over each item and check collision
    lda list_pickup, x
    ; move x over by 4 to the right to account for offcenter
    adc #4
    sta math_buffer+4 ; set x
    lda list_pickup+1, x
    ; move y over by 4 to the bottom to account for offcenter
    adc #4
    sta math_buffer+5 ; set y
    jsr aabb_collision ; gets carry  bit if hit
    bcs @coin_hit
    dex 
    dex 
    dex ; -3 for next 
    bpl @coin_collision_loop ; branch if not negative, aka more to loop
    ; no hit :(
    clc 
    jmp @end_coin_collision
    @coin_hit:
    ; load index into mathbuffer
    txa 
    sta math_buffer ; push index to math buffer for removal
    sec ; set the carry
    @end_coin_collision:
.endscope
.endmacro

.macro GrabAbility ability_lbl, ability_passtrough_timers
.scope
    ldx math_buffer ; get index from math buffer for processing
    
    lda ability_passtrough_timers
    bne @skip_grab_ability_pickup_handling ; check if it's not 0, if so, skip grabbing all items

    lda list_pickup+2, x  ; Load type from the list
    sta ability_lbl ; Store it in the player's ability variable
@skip_grab_ability_pickup_handling:
.endscope
.endmacro
