
; imports and exports

.importzp frame_counter
.importzp second_counter

.import move_player_input
.import draw_enemy
.import draw_player

.import clock_draw_buffer
.importzp clock_dirty
.importzp clock_x
.importzp clock_y
.importzp math_buffer
.importzp inputs

.import division_16
.import prng

.export demo_scene

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

    jsr division_16 ; modulo 10, result now holds the thousands-digit
    ldx math_buffer+2 ; lo-byte of remainder
    stx clock_draw_buffer+1


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

    jsr division_16 ; modulo 10, result now holds the thousands-digit
    ldx math_buffer+2 ; lo-byte of remainder
    stx clock_draw_buffer+5


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

    jsr division_16 ; modulo 10, result now holds the thousands-digit
    ldx math_buffer+2 ; lo-byte of remainder
    stx clock_draw_buffer+9


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

    jsr division_16 ; modulo 10, result now holds the thousands-digit
    ldx math_buffer+2 ; lo-byte of remainder
    stx clock_draw_buffer+13


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

    UpdateClockBufferX
    UpdateClockBufferY
    UpdateClockBufferValue

    ; move player based on input and check if it collides with one enemy
    jsr move_player_input

    rts