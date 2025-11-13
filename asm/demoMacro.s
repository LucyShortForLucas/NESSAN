; imports and exports

.importzp frame_counter
.importzp second_counter


.import clock_draw_buffer
.importzp clock_dirty
.importzp clock_x
.importzp clock_y
.importzp math_buffer

.import division_16

.macro UpdateTime 
    inc frame_counter

    lda #50 
    cmp frame_counter 
    bne @skip_seconds ; check if 50 frames have passed (1 second in PAL)

    inc second_counter
    lda clock_dirty ; Set clock value to be updated
    ora #1
    sta clock_dirty
    bne @no_overflow ; check for overflow
    inc second_counter+1
@no_overflow:

    ldx #$00
    stx frame_counter ; reset frame_counter

@skip_seconds:
.endmacro

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