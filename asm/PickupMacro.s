;; IMPORTS AND EXPORTS
.include "killMacro.s"

; ------------------------------------------------------------------------

.macro ShootGun x_coord, y_coord, direction
.scope

    lda direction

    ;; fill in bullet hitbox
    cmp #DIR_DOWN
    bne @skip_down

    lda x_coord
    sta math_buffer ; x

    lda y_coord
    clc
    adc #$10 ; move 16 pixels down to avoid shooter
    sta math_buffer+1 ; y

    lda #$10
    sta math_buffer+2 ; width

    lda #$EF ; the entire screen height
    sec 
    sbc y_coord ; Make sure collider fits on screen
    sta math_buffer+3 ; height

@skip_down:

    cmp #DIR_UP
    bne @skip_up

    lda x_coord
    sta math_buffer ; x

    lda #0
    sta math_buffer+1 ; y

    lda #$10
    sta math_buffer+2 ; width

    lda y_coord ; the entire screen height
    sec
    sbc #5 ; move up 5 pixels to avoid shooter
    sta math_buffer+3 ; height

@skip_up:

    cmp #DIR_LEFT
    bne @skip_left

    lda #0
    sta math_buffer ; x

    lda y_coord
    sta math_buffer+1 ; y

    lda x_coord
    sec
    sbc #2 ; move left 2 pixels to avoid shooter
    sta math_buffer+2 ; width

    lda #$10 ; One tile height
    sta math_buffer+3 ; height

@skip_left:

    cmp #DIR_RIGHT
    bne @skip_right

    lda x_coord
    clc
    adc #$10 ; move 16 pixels right to avoid shooter
    sta math_buffer ; x

    lda y_coord
    sta math_buffer+1 ; y

    lda #$EF ; entire screen width
    sec
    sbc x_coord ; make sure collider fits on screen
    sta math_buffer+2 ; width

    lda #$10 ; One tile height
    sta math_buffer+3 ; height

@skip_right:

    ;; check bullet hitbox against player

    ; common player vars
    lda #PLAYER_W
    sta math_buffer+6
    lda #PLAYER_W
    sta math_buffer+7

    ; blue player
    lda blue_player_x
    sta math_buffer+4
    lda blue_player_y
    sta math_buffer+5

    jsr aabb_collision
    bcc blue_no_hit
    Kill blue_respawn_timer, score_blue, ability_blue, blue_player_x, blue_player_y, #BLUE_PLAYER_SPAWN_X, #BLUE_PLAYER_SPAWN_Y
blue_no_hit:

    lda red_player_x
    sta math_buffer+4
    lda red_player_y
    sta math_buffer+5

    jsr aabb_collision
    bcc red_no_hit
    Kill red_respawn_timer, score_red, ability_red, red_player_x, red_player_y, #RED_PLAYER_SPAWN_X, #RED_PLAYER_SPAWN_Y
red_no_hit:

.endscope
.endmacro

.macro ShootGunAnimation laser_timer, laser_state, last_player_dir, laser_dir_save, player_x, laser_x_tile, player_y, laser_y_tile
.scope
    ; set the duration for how long the laser stays on screen
    lda #LASER_ANIMATION_DURATION
    sta laser_timer
    
    ; set state to 1 which tells the nmi to draw the white line
    lda #1
    sta laser_state

    ; save the direction the player is facing
    lda last_player_dir
    sta laser_dir_save

    ; convert pixel coordinates to tile coordinates by dividing by 8
    ; process x coordinate
    lda player_x
    lsr
    lsr
    lsr
    sta laser_x_tile
    
    ; process y coordinate
    lda player_y
    lsr
    lsr
    lsr
    sta laser_y_tile
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

.macro PhaseWallUpdate player_abilitySlot, passtroughTimer, respawn_timer, coin_count, player_x, player_y, respawn_x, respawn_y
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
    Kill respawn_timer, coin_count, player_abilitySlot, player_x, player_y, respawn_x, respawn_y
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


.macro DashInitialize dashTimer
.scope
    lda dashTimer
    bne @skip_init ; If already running, don't restart
    
    lda #DASH_DURATION        ; Set duration
    sta dashTimer
@skip_init:
.endscope
.endmacro

.macro DashUpdate dashTimer, playerAbilitySlot
.scope
    lda dashTimer
    beq @skip_timer_logic ; If 0, do nothing

    dec dashTimer         ; tick down timer
    bne @skip_timer_logic ; If not 0 yet, continue

    ; Timer hit 0 then remove ability
    lda #PICKUP_NONE
    sta playerAbilitySlot

@skip_timer_logic:
.endscope
.endmacro



.macro ThrowBomb player_abilitySlot, player_x, player_y, player_dir
.scope
    ;remove bomb from ability slot
    lda #PICKUP_NONE
    sta player_abilitySlot
    ; throw bomb code!

    ; set bomb to our position
    lda player_x
    sta bomb_x
    lda player_y
    sta bomb_y
    ; set bomb timer to correct time & draw frame counter to 0
    lda #BOMB_TIMER_FRAMES
    sta bomb_timer
    lda #0
    sta bomb_draw_frame_counter
    
    ; throw bomb in direction player is facing
    lda player_dir

    cmp #DIR_UP
    beq @throw_up

    cmp #DIR_DOWN
    beq @throw_down

    cmp #DIR_LEFT
    beq @throw_left

    cmp #DIR_RIGHT
    beq @throw_right

    jmp @end_throw ; safety catch, should not happen
@throw_up:
    lda #0
    sta bomb_veloctiy_x
    lda #(256-BOMB_THROW_SPEED) ; instead of using complex add/sub later, we just add what would be negative but divide the speed by 2 to make sure it's the same speed
    sta bomb_velocity_y
    jmp @end_throw
@throw_down:
    lda #0
    sta bomb_veloctiy_x
    lda #BOMB_THROW_SPEED
    sta bomb_velocity_y
    jmp @end_throw
@throw_left:
    lda #(256-BOMB_THROW_SPEED) ; instead of using complex add/sub later, we just add what would be negative but divide the speed by 2 to make sure it's the same speed
    sta bomb_veloctiy_x
    lda #0
    sta bomb_velocity_y
    jmp @end_throw
@throw_right:
    lda #BOMB_THROW_SPEED
    sta bomb_veloctiy_x
    lda #0
    sta bomb_velocity_y
@end_throw:
.endscope
.endmacro

.macro BombUpdate 
.scope

    lda bomb_timer
    bne bomb_logic ; If not 0, do code,
    jmp skip_bomb_logic ; else skip
bomb_logic:
;; bomb logic code ;;
blink1_inc_else:
    ; if below threshold, move the bomb!
    ; move bomb based on velocity, if negative is set then subtract
    lda bomb_timer
    cmp BOMB_THROW_THRESHOLD
    bpl skip_moving_bomb

    lda bomb_x
    clc 
    adc bomb_veloctiy_x
    sta bomb_x

    lda bomb_y
    clc 
    adc bomb_velocity_y
    sta bomb_y

skip_moving_bomb:
    ; tick up draw frame counter
    inc bomb_draw_frame_counter
    ; if above threshold 1, inc
    lda bomb_timer
    cmp #BOMB_BLINK_THRESHOLD1
    bpl skip_blink1_inc
    inc bomb_draw_frame_counter
skip_blink1_inc:


    ; if above threshold 2, inc
    lda bomb_timer
    cmp #BOMB_BLINK_THRESHOLD2
    bpl skip_blink2_inc
    inc bomb_draw_frame_counter
    inc bomb_draw_frame_counter
    inc bomb_draw_frame_counter
    inc bomb_draw_frame_counter
skip_blink2_inc:

    ; if above 20 frames, reset to 0
    lda bomb_draw_frame_counter
    cmp #40
    bmi skip_blink_reset
    lda #0
    sta bomb_draw_frame_counter
skip_blink_reset:

    dec bomb_timer         ; tick down timer
    bne skip_bomb_logic ; If not 0 yet, continue
    ; Timer hit 0 then explode bomb
    ; Kill players in radius
    ; first we move the x to half the radius left and y to half the radius up
    lda bomb_x
    sec 
    sbc #((BOMB_BLAST_RADIUS / 2)-8) ; -8 for sprite offset
    sta math_buffer+0 ; x
    lda bomb_y
    sec 
    sbc #((BOMB_BLAST_RADIUS / 2)-8) ; -8 for sprite offset
    sta math_buffer+1 ; y
    lda #BOMB_BLAST_RADIUS
    sta math_buffer+2 ; width
    lda #BOMB_BLAST_RADIUS
    sta math_buffer+3 ; height
    ; load player width
    lda #PLAYER_W
    sta math_buffer+6
    lda #PLAYER_H
    sta math_buffer+7
    ; check blue player
    lda blue_player_x
    sta math_buffer+4
    lda blue_player_y
    sta math_buffer+5


    jsr aabb_collision
    bcc blue_no_hit_bomb
    Kill blue_respawn_timer, score_blue, ability_blue, blue_player_x, blue_player_y, #BLUE_PLAYER_SPAWN_X, #BLUE_PLAYER_SPAWN_Y
blue_no_hit_bomb:
    ; check red player
    lda red_player_x
    sta math_buffer+4
    lda red_player_y
    sta math_buffer+5

    jsr aabb_collision
    bcc red_no_hit_bomb
    Kill red_respawn_timer, score_red, ability_red, red_player_x, red_player_y, #RED_PLAYER_SPAWN_X, #RED_PLAYER_SPAWN_Y
red_no_hit_bomb:

    lda #0
    sta bomb_x
    sta bomb_y

skip_bomb_logic:
.endscope
.endmacro