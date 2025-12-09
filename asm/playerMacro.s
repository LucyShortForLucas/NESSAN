
.import wall_collisions
.import initialize_scene_end

.include "PickupMacro.s"

.macro PlayerMovementUpdate player_x, player_y, inputs, player_backup, player_dir, player_pickup
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
    lda #1              ; Set Dir UP
    sta player_dir
@check_down:

    ; 3. Check Input DOWN
    lda inputs
    and #%00000100      ; Bit 2 (Down)
    beq @check_col_y
    inc player_y        ; Move Down
    lda #0              ; Set Dir DOWN
    sta player_dir

@check_col_y:
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
    lda #2              ; Set Dir LEFT
    sta player_dir
@check_right:

    ; 3. Check Input RIGHT
    lda inputs
    and #%00000001      ; Bit 0 (Right)
    beq @check_col_x
    inc player_x        ; Move Right
    lda #3              ; Set Dir RIGHT
    sta player_dir

@check_col_x:
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
    lda inputs
    and #%10000000      ; A button
    beq end_ability

    lda player_pickup 
    beq end_ability ; skip on 0 (no pickup)

    lda player_pickup ; fetch the pickup enum

    cmp #PICKUP_GUN ; check for gun
    bne skip_gun
    ShootGun player_x, player_y, player_dir
skip_gun:

    cmp #PICKUP_DASH ; check for dash
    bne skip_dash
    ;;; TODO: Add dash macro
skip_dash:

    cmp #PICKUP_PASSTHROUGH ; check for passthrough
    bne skip_Passthrough
    ;;; TODO: Add Passthrough macro
skip_Passthrough:

end_ability:

.endscope
.endmacro