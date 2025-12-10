
.import wall_collisions
.import initialize_scene_end

.include "PickupMacro.s"

.macro PlayerMovementUpdate player_x, player_y, inputs, player_backup, player_dir, player_pickup, passthroughVariable, respawn_timer, coin_count, respawn_x, respawn_y, dash_timer
.scope 

    ; Y-Axis 

    ; 1. Backup Y (in case we hit a wall)
    lda player_y
    sta player_backup

    ; 2. Check Input UP
    lda inputs
    and #%00001000      ; Bit 3 (Up) - Fixed the 9-bit typo
    beq @check_down
    dec player_y        ; Move Up

    ; Direction Up
    lda #1              ; Set Dir UP
    sta player_dir

    ; Dash Up
    lda dash_timer      ; Is timer running?
    beq @skip_dash_up   ; If 0, skip
    dec player_y        ; Dash
    dec player_y
    dec player_y
@skip_dash_up:



@check_down:

    ; 3. Check Input DOWN
    lda inputs
    and #%00000100      ; Bit 2 (Down)
    beq @check_col_y
    inc player_y        ; Move Down
    
    ; Direction Down
    lda #0              ; Set Dir DOWN
    sta player_dir

    ; Dash Down
    lda dash_timer
    beq @skip_dash_down
    inc player_y
    inc player_y
    inc player_y
@skip_dash_down:



@check_col_y:
    ; If passthrough is active, aka not 0, skip wall collisions
    lda passthroughVariable
    bne @end_y

    ; 4. Prepare Collision Buffer
    lda player_x
    sta math_buffer+0   ; a_X
    lda player_y
    sta math_buffer+1   ; a_Y (New Position)
    lda #PLAYER_W
    sta math_buffer+2   ; a_width
    lda #PLAYER_H
    sta math_buffer+3   ; a_height

    ; 5. Check Wall Collision
    jsr wall_collisions
    bcc @end_y          ; If Carry Clear (No Hit), skip revert

    ; 6. HIT! Revert Y
    lda player_backup
    sta player_y


    ; Update Sprite if it wall
    lda player_dir
    clc 
    adc #4
    sta player_dir
@end_y:

    ; X-Axis 

    ; 1. Backup X
    lda player_x
    sta player_backup

    ; 2. Check Input LEFT
    lda inputs
    and #%00000010      ; Bit 1 (Left)
    beq @check_right
    dec player_x        ; Move Left

    ; Direction Left
    lda #2              ; Set Dir LEFT
    sta player_dir

    ; Dash Left
    lda dash_timer
    beq @skip_dash_left
    dec player_x
    dec player_x
    dec player_x
@skip_dash_left:

@check_right:

    ; 3. Check Input RIGHT
    lda inputs
    and #%00000001      ; Bit 0 (Right)
    beq @check_col_x
    inc player_x        ; Move Right

    ; Direction Right
    lda #3              ; Set Dir RIGHT
    sta player_dir

    ; Dash Right
    lda dash_timer
    beq @skip_dash_right
    inc player_x
    inc player_x
    inc player_x
@skip_dash_right:



@check_col_x:

    ; If passthrough is active, aka not 0, skip wall collisions
    lda passthroughVariable
    bne @end_x

    ; 4. Prepare Collision Buffer
    lda player_x        ; New X
    sta math_buffer+0   
    lda player_y
    sta math_buffer+1   
    lda #PLAYER_W
    sta math_buffer+2
    lda #PLAYER_H
    sta math_buffer+3

    ; 5. Check Wall Collision
    jsr wall_collisions
    bcc @end_x          ; If Carry Clear (No Hit), skip revert

    ; 6. HIT! Revert X
    lda player_backup
    sta player_x

    ; Update Sprite if it wall
    lda player_dir
    clc
    adc #4
    sta player_dir

@end_x:

    ; Do ability (if available)

    ; Check Button Press
    lda inputs
    and #%10000000       ; A button
    beq end_ability      ; If not pressed, we are done

    ; Check if we have a pickup
    lda player_pickup 
    beq end_ability      ; If 0 (None), we are done

    ; Check for the Gun
    cmp #PICKUP_GUN
    bne check_dash        ; If not Gun, try next
    ShootGun player_x, player_y, player_dir
    jmp end_ability      ; If match found we jump to end.

check_dash:
    ; Check for the Dash
    cmp #PICKUP_DASH
    bne check_passthrough ; If not Dash, try next
    DashInitialize dash_timer
    jmp end_ability      ; If match found we jump to end.

check_passthrough:
    ; Check for passthrough
    cmp #PICKUP_PASSTHROUGH
    bne end_ability      ; If not Passthrough, we are done
    PhaseWallInitialize passthroughVariable
    jmp end_ability      ; If match found we jump to end.   

end_ability:
    ; Ability Updates
    DashUpdate dash_timer, player_pickup
    PhaseWallUpdate player_pickup, passthroughVariable, respawn_timer, coin_count, player_pickup, player_x, player_y, respawn_x, respawn_y
.endscope
.endmacro