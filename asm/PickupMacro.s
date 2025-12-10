
.include "killMacro.s"

.macro ShootGun x_coord, y_coord, direction
.scope

Kill blue_respawn_timer, score_blue, ability_blue, blue_player_x, blue_player_y, #24, #24

.endscope
.endmacro

.macro PhaseWallInitialize passtroughTimer
.scope
    ; Initialize the passtrough timer to the maximum value so that in the update it later
    lda passtroughTimer
    ; if not 0 skip this to not run it twice
    bne @skip_init
    ; Init the timer to max
    lda #PASSTHROUGH_FRAME_COUNTER_MAX
    sta passtroughTimer
@skip_init:
.endscope
.endmacro

.macro PhaseWallUpdate player_abilitySlot, passtroughTimer, respawn_timer, coin_count, player_pickup, player_x, player_y, respawn_x, respawn_y
.scope
    lda passtroughTimer
    ; If 0 skip everything
    beq skip_PhaseWallUpdate

    ; Decrement the main timer
    dec passtroughTimer

    ; if after decrement it's 0, remove the ability from the slot
    bne skip_remove_ability
    lda #PICKUP_NONE
    sta player_abilitySlot
    lda #0
    sta passtroughTimer+1 ; reset animation timer
    ; check if we're in a wall, if so, kill the player
    ; prepare collision player
    lda player_x
    sta math_buffer+0
    lda player_y
    sta math_buffer+1
    lda #PLAYER_W
    sta math_buffer+2
    lda #PLAYER_H
    sta math_buffer+3
    ; check collisions
    jsr wall_collisions
    ; if in wall, kill player
    bcc skip_PhaseWallUpdate
    ; kill player
    Kill respawn_timer, coin_count, player_pickup, player_x, player_y, respawn_x, respawn_y
    jmp skip_PhaseWallUpdate

skip_remove_ability:
    ; Main code of the timers 
    
    ; increment the animation timer
    inc passtroughTimer+1
    lda passtroughTimer
    ; if timer is in the last 4x frames, double inc speed
    cmp #PASSTHROUGH_ANIMATION_SPEEDUP_THRESHOLD
    bcs @skip_double_inc
    bpl @skip_double_inc
    inc passtroughTimer+1
    inc passtroughTimer+1
@skip_double_inc:
    lda passtroughTimer+1
    ; If animation timer overflows, reset it
    cmp #PASSTHROUGH_ANIMATION_MAX
    bmi skip_PhaseWallUpdate
    lda #0
    sta passtroughTimer+1


skip_PhaseWallUpdate:
.endscope
.endmacro