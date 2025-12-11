
; imports and exports

.importzp frame_counter
.importzp second_counter

.import move_player_input

.import spawn_new_pickup
.import pickup_timer

.import clock_draw_buffer
.import pickup_timer
.importzp clock_dirty
.importzp clock_x
.importzp clock_y
.importzp math_buffer
.importzp inputs
.importzp coin_x2
.importzp coin_y2
.importzp coin_x
.importzp coin_y
.importzp blue_player_x, blue_player_y
.importzp red_player_x, red_player_y
.importzp count_down_x
.importzp count_down_y
.importzp blue_respawn_timer
.importzp red_respawn_timer
.importzp last_blue_player_dir
.importzp last_red_player_dir

.importzp score_red_x, score_blue_x
.importzp score_red_y, score_blue_y
.importzp score_red, score_blue

.importzp ability_blue_icon_x, ability_blue_icon_y, ability_red_icon_x, ability_red_icon_y

.importzp blue_player_dir, red_player_dir
.import blue_player_backup, red_player_backup

.importzp ability_blue, ability_red

.importzp ability_blue_passtrough_timers, ability_red_passtrough_timers
.importzp dash_timer_red, dash_timer_blue

.importzp laser_timer, laser_state, laser_dir_save, laser_x_tile, laser_y_tile, laser_buffer, ppu_addr_temp

.import list_pickup
.import ConvertIndexToPosition

.import division_16
.import prng
.import HandleCoinCollection
.import aabb_collision

.import end_state, initialize_scene_end

.export demo_scene


.importzp bomb_timer, bomb_x, bomb_y, bomb_draw_frame_counter, bomb_veloctiy_x, bomb_velocity_y

.include "playerMacro.s"
.include "graphicsMacro.s"
.include "consts.s"
.include "coinListMacro.s"
.include "spawnPickupMacro.s"
.include "musicMacro.s"

.segment "CODE"

demo_scene:
    HandlePickupSpawn ; Reduce the pickup spawn timer and check if a new one must be spawned

    ; check if the laser timer is active
    lda laser_timer
    beq @skip_timer
    
    ; decrease the timer by one
    dec laser_timer
    bne @skip_timer
    
    ; if timer hits zero tell the nmi to erase the laser
    lda #2              
    sta laser_state

@skip_timer:

;; Red Player Update
    lda red_respawn_timer
    bne skip_red_update ; If timer is nonzero, reduce it by one and skip update
    jmp do_red_update ; If timer is zero, skip decrement and update

skip_red_update:
    dec red_respawn_timer
    jmp red_update_end

do_red_update:

    
    CheckForCoinCollision red_player_x, red_player_y
    bcc skipRedPickupHandling

    ; Check if it is a Coin or Ability
    ldx math_buffer         
    lda list_pickup+2, x    
    bne RedHitAbility      ; If Type is NOT 0, jump to Ability logic

    ; Coin
    jsr HandleCoinCollection
    UpdateScore score_red, 1
    ChooseSFX SFX_COIN ; Play Coin Pickup SFX
    jsr check_coin_cap_red
    jmp skipRedPickupHandling

RedHitAbility:
    ; Ability
    GrabAbility ability_red, ability_red_passtrough_timers
    ChooseSFX SFX_ABILITYPICKUP ; Play Ability Pickup SFX
    jsr HandleCoinCollection

skipRedPickupHandling:

    PlayerMovementUpdate red_player_x, red_player_y, inputs+1, red_player_backup, red_player_dir, last_red_player_dir, ability_red, ability_red_passtrough_timers, red_respawn_timer, score_red, #RED_PLAYER_SPAWN_X, #RED_PLAYER_SPAWN_Y, dash_timer_red
red_update_end:


;; Blue Player Update
    lda blue_respawn_timer
    bne skip_blue_update ; If timer is nonzero, reduce it by one and skip update
    jmp do_blue_update ; If timer is zero, skip decrement and update

skip_blue_update:
    dec blue_respawn_timer
    jmp blue_update_end

do_blue_update:


    CheckForCoinCollision blue_player_x, blue_player_y
    bcc skipBluePickupHandling

    ; Check if it is a Coin or Ability
    ldx math_buffer
    lda list_pickup+2, x
    bne BlueHitAbility     ; If Type is NOT 0, jump to Ability logic

    ; Coin
    jsr HandleCoinCollection
    UpdateScore score_blue, 1
    ChooseSFX SFX_COIN ; Play Coin Pickup SFX
    jsr check_coin_cap_blue
    jmp skipBluePickupHandling

BlueHitAbility:
    ; Ability
    GrabAbility ability_blue, ability_blue_passtrough_timers
    ChooseSFX SFX_ABILITYPICKUP ; Play Ability Usage SFX
    jsr HandleCoinCollection

skipBluePickupHandling:
  PlayerMovementUpdate blue_player_x, blue_player_y, inputs, blue_player_backup, blue_player_dir, last_blue_player_dir, ability_blue, ability_blue_passtrough_timers, blue_respawn_timer, score_blue, #BLUE_PLAYER_SPAWN_X, #BLUE_PLAYER_SPAWN_Y, dash_timer_blue
blue_update_end:

    BombUpdate

    UpdateClock
    jsr check_clock

    ; Draw Sprites
    ldy #$00 ; do NOT forget to load y with 0 before drawing sprites!

    ; Loop over all
    lda list_pickup ; load amount into pickup
    bne @startPickupDraw ; if 0 then we're done! nothing to check!
    jmp @endPickupDraw ; skip drawing coins
@startPickupDraw:
    jsr ConvertIndexToPosition
@loopDrawLoop: ; loop over each item

    lda list_pickup, x ; x
    sta math_buffer+0
    lda list_pickup+1, x ; y
    sta math_buffer+1
    stx math_buffer+2
    jsr DrawPickupJSR
    ldx math_buffer+2
    dex 
    dex 
    dex ; -3 for next item
    bmi @endPickupDraw ; branch IF negative, aka no more to loop over
    jmp @loopDrawLoop
@endPickupDraw:   

    DrawClock count_down_x, count_down_y ; 

    lda blue_respawn_timer
    cmp #35
    bcc check_frame_blue ; Only draw if less than 35 frames left till respawn\
    jmp skip_blue_draw ; jump over draw (too big for branch) 
check_frame_blue:
    and #%00000011
    beq draw_blue ; If less than 35, flicker
    jmp skip_blue_draw ; jump over draw (too big for branch)

draw_blue:
    DrawBluePlayer blue_player_x, blue_player_y
skip_blue_draw:


  lda red_respawn_timer
    cmp #35
    bcc check_frame_red ; Only draw if less than 35 frames left till respawn\
    jmp skip_red_draw ; jump over draw (too big for branch) 
check_frame_red:
    and #%00000011
    beq draw_red ; If less than 35, flicker
    jmp skip_red_draw ; jump over draw (too big for branch)

draw_red:
    DrawRedPlayer red_player_x, red_player_y
skip_red_draw:

    lda bomb_x
    cmp #0
    ; if bomb x is 0, bomb is not active so skip draw
    beq skip_bomb_draw

    ; if bomb is active, draw it
    lda bomb_draw_frame_counter
    ; compare to half of 40, 20, if less than 20 draw sprite else draw nothing
    cmp #20
    bpl skip_bomb_draw
    DrawMetasprite bomb_x, bomb_y, AbilityBombFrame2

skip_bomb_draw:

    DrawScore score_red_x, score_red_y, score_red
    DrawScore score_blue_x, score_blue_y, score_blue

    DrawAbilityBlue ability_blue_icon_x, ability_blue_icon_y, ability_blue
    DrawAbilityRed ability_red_icon_x, ability_red_icon_y, ability_red
    rts 

; Subroutine to draw the pickups
DrawPickupJSR:
    DrawPickup
    rts

; Clock cap check subroutine
check_clock:
    ; Check if 00:00
    lda clock_min
    ora clock_sec
    bne @skip ; if the clock isnt zero SKIP
        lda #ENDSTATE_TIMERUP
        sta end_state

        jsr initialize_scene_end ; doesnt know what to do
    @skip:
    rts
; coin cap check subroutine
check_coin_cap_blue:
 ; Check one player has reached the max coins and wins
    lda score_blue
    cmp #COIN_CAP
    bne @skipBlue ; if the cap isnt reached SKIP
        lda #ENDSTATE_BLUEWINS
        sta end_state

        jsr initialize_scene_end ; doesnt know what to do
    @skipBlue:
    rts

check_coin_cap_red:
    lda score_red
    cmp #COIN_CAP
    bne @skipRed ; if the cap isnt reached SKIP
        lda #ENDSTATE_REDWINS
        sta end_state

        jsr initialize_scene_end ; doesnt know what to do
    @skipRed:
    rts