
.importzp inputs

.importzp frame_counter
.importzp second_counter

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

.macro FetchInput
.scope
    lda #$01       ; strobe ON
    sta $4016
    sta inputs
    lsr a
    sta $4016
    
@loop:
    lda $4016
    lsr a
    rol inputs
    bcc @loop
.endscope
.endmacro
