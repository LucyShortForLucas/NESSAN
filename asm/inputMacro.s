
.importzp inputs

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
