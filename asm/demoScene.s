
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

.import list_pickup
.import ConvertIndexToPosition

.import division_16
.import prng
.import HandleCoinCollection
.import aabb_collision

.export demo_scene


.include "playerMacro.s"
.include "graphicsMacro.s"
.include "consts.s"
.include "coinListMacro.s"
.include "spawnPickupMacro.s"
.include "musicMacro.s"

.segment "CODE"

demo_scene:
    HandlePickupSpawn ; Reduce the pickup spawn timer and check if a new one must be spawned

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
    jmp skipRedPickupHandling

RedHitAbility:
    ; Ability
    ChooseSFX SFX_COIN ; Play Ability Pickup SFX
    GrabAbility ability_red, ability_red_passtrough_timers
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
    jmp skipBluePickupHandling

BlueHitAbility:
    ; Ability
    ChooseSFX SFX_COIN ; Play Ability Pickup SFX
    GrabAbility ability_blue, ability_blue_passtrough_timers
    jsr HandleCoinCollection

skipBluePickupHandling:
  PlayerMovementUpdate blue_player_x, blue_player_y, inputs, blue_player_backup, blue_player_dir, last_blue_player_dir, ability_blue, ability_blue_passtrough_timers, blue_respawn_timer, score_blue, #BLUE_PLAYER_SPAWN_X, #BLUE_PLAYER_SPAWN_Y, dash_timer_blue

blue_update_end:


    UpdateClock
    
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

    DrawClock count_down_x, count_down_y

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


    DrawScore score_red_x, score_red_y, score_red
    DrawScore score_blue_x, score_blue_y, score_blue

    DrawAbilityBlue ability_blue_icon_x, ability_blue_icon_y, ability_blue
    DrawAbilityRed ability_red_icon_x, ability_red_icon_y, ability_red
    rts 

; Subroutine to draw the pickups
DrawPickupJSR:
    DrawPickup
    rts