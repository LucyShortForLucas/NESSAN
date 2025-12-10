
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

.importzp score_red_x, score_blue_x
.importzp score_red_y, score_blue_y
.importzp score_red, score_blue

.importzp ability_blue_icon_x, ability_blue_icon_y, ability_red_icon_x, ability_red_icon_y

.importzp blue_player_dir, red_player_dir
.import blue_player_backup, red_player_backup

.importzp ability_blue, ability_red

.importzp ability_blue_passtrough_timers, ability_red_passtrough_timers

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

.segment "CODE"

demo_scene:
    HandlePickupSpawn ; Reduce the pickup spawn timer and check if a new one must be spawned

    lda ability_red_passtrough_timers
    bne skipRedPickupHandling ; check if it's 0, if so, skip grabbing all items
    
    CheckForCoinCollision red_player_x, red_player_y
    bcc skipRedPickupHandling

    ; Check if it is a Coin or Ability
    ldx math_buffer         
    lda list_pickup+2, x    
    bne RedHitAbility      ; If Type is NOT 0, jump to Ability logic

    ; Coin
    jsr HandleCoinCollection
    UpdateScore score_red, 1
    jmp skipRedPickupHandling

RedHitAbility:
    ; Ability

    GrabAbility ability_red
    jsr HandleCoinCollection

skipRedPickupHandling:

    lda ability_blue_passtrough_timers
    bne skipBluePickupHandling ; check if it's 0, if so, skip grabbing all items

    CheckForCoinCollision blue_player_x, blue_player_y
    bcc skipBluePickupHandling

    ; Check if it is a Coin or Ability
    ldx math_buffer
    lda list_pickup+2, x
    bne BlueHitAbility     ; If Type is NOT 0, jump to Ability logic

    ; Coin
    jsr HandleCoinCollection
    UpdateScore score_blue, 1
    jmp skipBluePickupHandling

BlueHitAbility:
    ; Ability

    GrabAbility ability_blue
    jsr HandleCoinCollection

skipBluePickupHandling:

    UpdateClock

    ; move player based on input and check if it collides with one enemy
    PlayerMovementUpdate blue_player_x, blue_player_y, inputs, blue_player_backup, blue_player_dir, ability_blue, ability_blue_passtrough_timers
    PlayerMovementUpdate red_player_x, red_player_y, inputs+1, red_player_backup, red_player_dir, ability_red, ability_red_passtrough_timers

    
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

    DrawBluePlayer blue_player_x, blue_player_y
    DrawRedPlayer red_player_x, red_player_y

    DrawScore score_red_x, score_red_y, score_red
    DrawScore score_blue_x, score_blue_y, score_blue

    DrawAbility ability_blue_icon_x, ability_blue_icon_y, ability_blue
    DrawAbility ability_red_icon_x, ability_red_icon_y, ability_red
    rts 

; Subroutine to draw the pickups
DrawPickupJSR:
    DrawPickup
    rts