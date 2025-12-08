
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

.importzp blue_player_dir, red_player_dir
.import blue_player_backup, red_player_backup

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

.macro UpdateClockBufferValue
.scope
    lda clock_dirty
    and #%00000001
    bne @update ; Check bit 0 (value needs update)
    jmp @skip ; long jump (skip too far away for short jump)

@update:
    ; Thousands digit
    ldx #$E8 ; divisor lo-byte
    stx math_buffer
    ldx #$03 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ldx second_counter ; dividend lo-cell lo-byte
    stx math_buffer+4
    ldx second_counter+1  ; dividend lo-cell hi-byte
    stx math_buffer+5

    jsr division_16 ; divison by 1000

    ldx #$0A ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ;; lo-cell of dividend already holds quotient

    jsr division_16 ; modulo 10, result now holds the thousands-digit (Remainder 0-9 in math_buffer+2/3)
    lda math_buffer+2 ; lo-byte of remainder (0-9)
    clc
    adc #$30 ; Add offset 

     ; hundreds digit
    ldx #$64 ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ldx second_counter ; dividend lo-cell lo-byte
    stx math_buffer+4
    ldx second_counter+1  ; dividend lo-cell hi-byte
    stx math_buffer+5

    jsr division_16 ; divison by 100

    ldx #$0A ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ;; lo-cell of dividend already holds quotient

    jsr division_16 ; modulo 10, result now holds the hundreds-digit
    lda math_buffer+2 ; lo-byte of remainder (0-9)
    clc
    adc #$30 ; Add offset 
    sta clock_draw_buffer+5


     ; tens digit
    ldx #$0A ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ldx second_counter ; dividend lo-cell lo-byte
    stx math_buffer+4
    ldx second_counter+1  ; dividend lo-cell hi-byte
    stx math_buffer+5

    jsr division_16 ; divison by 10

    ldx #$0A ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ;; lo-cell of dividend already holds quotient

    jsr division_16 ; modulo 10, result now holds the tens-digit
    lda math_buffer+2 ; lo-byte of remainder (0-9)
    clc
    adc #$30 ; Add offset 
    sta clock_draw_buffer+9


    ; ones digit
    ldx #$0A ; divisor lo-byte
    stx math_buffer
    ldx #$00 ; diviosor hi-byte
    stx math_buffer+1
    ldx #$00  ; dividend hi-cell lo-byte
    stx math_buffer+2
    ldx #$00 ; dividend hi-cell hi-byte
    stx math_buffer+3
    ldx second_counter ; dividend lo-cell lo-byte
    stx math_buffer+4
    ldx second_counter+1  ; dividend lo-cell hi-byte
    stx math_buffer+5

    jsr division_16 ; modulo 10, result now holds the ones-digit
    lda math_buffer+2 ; lo-byte of remainder (0-9)
    clc
    adc #$30 ; Add offset 
    sta clock_draw_buffer+13


    lda clock_dirty ; unset bit 1 (value has been updated)
    and #%11111110
    sta clock_dirty
@skip:
.endscope
.endmacro

.macro UpdateClockBufferX
.scope
    lda clock_dirty
    and #%00000010
    beq @skip ; Check bit 1 (x needs update)

    clc
    lda clock_x
    sta clock_draw_buffer + 3
    adc #10 ; kerning
    sta clock_draw_buffer + 7
    adc #10 ; kerning
    sta clock_draw_buffer + 11
    adc #10 ; kerning
    sta clock_draw_buffer + 15
    adc #10 ; kerning

    lda clock_dirty ; unset bit 1 (x has been updated)
    and #%11111101
    sta clock_dirty
@skip:
.endscope
.endmacro

.macro UpdateClockBufferY
.scope
    lda clock_dirty
    and #%00000100
    beq @skip ; check bit 2 (y needs update)

    ldx clock_y
    stx clock_draw_buffer
    stx clock_draw_buffer + 4
    stx clock_draw_buffer + 8
    stx clock_draw_buffer + 12

    lda clock_dirty ; unset bit 2 (y has been updated)
    and #%11111011
    sta clock_dirty
@skip:
.endscope
.endmacro

.macro MoveClock
.scope

    lda inputs
    and #%00001000 ; up
    beq skip_up
    lda clock_y
    sec
    sbc #1
    sta clock_y
    lda clock_dirty
    ora #%00000100
    sta clock_dirty
skip_up:

    lda inputs
    and #%00000100 ; down
    beq skip_down
    lda clock_y
    clc
    adc #1
    sta clock_y
    lda clock_dirty
    ora #%00000100
    sta clock_dirty
skip_down:

    lda inputs
    and #%00000010 ; left
    beq skip_left
    lda clock_x
    sec
    sbc #1
    sta clock_x
    lda clock_dirty
    ora #%00000010
    sta clock_dirty
skip_left:

    lda inputs
    and #%0000001 ; right
    beq skip_right
    lda clock_x
    clc
    adc #1
    sta clock_x
    lda clock_dirty
    ora #%00000010
    sta clock_dirty
skip_right:

.endscope
.endmacro

.macro ClockValueButtons
.scope

    lda inputs
    and #%10000000 ; A
    beq skip_a
    inc second_counter
    bne @no_overflow ; check for overflow
    inc second_counter+1
@no_overflow:
    lda clock_dirty
    ora #%00000001
    sta clock_dirty
skip_a:

    lda inputs
    and #%01000000 ; B
    beq skip_b
    
    clc ; add 1 byte value to 2 byte value
    lda second_counter
    adc #10
    sta second_counter
    lda second_counter+1 ; add cary, if any
    adc #0
    sta second_counter+1

    lda clock_dirty
    ora #%00000001
    sta clock_dirty
skip_b:

    lda inputs
    and #%00100000 ; Select
    beq skip_select
    lda #0
    sta second_counter
    sta second_counter+1
    lda clock_dirty
    ora #%00000001
    sta clock_dirty
skip_select:

.endscope
.endmacro

.segment "CODE"

demo_scene:
    MoveClock
    ClockValueButtons

    HandlePickupSpawn ; Reduce the pickup spawn timer and check if a new one must be spawned

    CheckForCoinCollision red_player_x, red_player_y ; check if we hit a coin!
    bcc skipRedCoinHandling ; branch if not...
    jsr HandleCoinCollection ; We're touching a coin! handle it!
    UpdateScore score_red, 1
skipRedCoinHandling:
    CheckForCoinCollision blue_player_x, blue_player_y ; check if we hit a coin!

    bcc skipBlueCoinHandling ; branch if not...
    jsr HandleCoinCollection ; We're touching a coin! handle it!
    UpdateScore score_blue, 1
skipBlueCoinHandling:


    UpdateClockBufferX
    UpdateClockBufferY
    UpdateClockBufferValue

    UpdateClock

    ; move player based on input and check if it collides with one enemy
    ; jsr move_player_input
    PlayerMovementUpdate blue_player_x, blue_player_y, inputs, blue_player_backup, blue_player_dir
    PlayerMovementUpdate red_player_x, red_player_y, inputs+1, red_player_backup, red_player_dir
    ; Draw Sprites
    ; Loop over all
    
    ldy #$00 ; do NOT forget to load y with 0 before drawing sprites!


    lda list_pickup ; load amount into pickup
    bne @startCoinDraw ; if 0 then we're done! nothing to check!
    jmp @endCoinDraw ; skip drawing coins
@startCoinDraw:
    jsr ConvertIndexToPosition
@loopDrawLoop: ; loop over each item
    lda list_pickup, x ; x
    sta math_buffer+0
    lda list_pickup+1, x ; y
    sta math_buffer+1
    stx math_buffer+2
    jsr DrawCoinJSR
    ldx math_buffer+2
    dex 
    dex 
    dex ; -3 for next item
    bmi @endCoinDraw ; branch IF negative, aka no more to loop over
    jmp @loopDrawLoop
@endCoinDraw:   

    DrawClock count_down_x, count_down_y
    DrawBluePlayer blue_player_x, blue_player_y
    DrawRedPlayer red_player_x, red_player_y
    DrawScore score_red_x, score_red_y, score_red
    DrawScore score_blue_x, score_blue_y, score_blue
    rts 


    
; subroutine to draw coin due to the size of macros
DrawCoinJSR:
    DrawCoin
    rts 