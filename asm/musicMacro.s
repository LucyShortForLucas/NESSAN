; Macro for music

.macro InitializeSongs
; Setup music

    LDA #00 ; set music to PAL
    LDX #.lobyte(music_data_coinheist) ; load the low bytes 
    LDY #.hibyte(music_data_coinheist) ; load the high bytes
    jsr famistudio_init ; load the X/Y registers so that the engine can correctly place them for later use

    LDA #01 ; set sfx to PAL
    LDX #.lobyte(sounds) ; load the low bytes 
    LDY #.hibyte(sounds) ; load the high bytes
    jsr famistudio_sfx_init ; load the X/Y registers so that the engine can correctly place them for later use


    ; do the same with hi/lo for each song
.endmacro

; Updating happens in the NMI at the bottom "jsr famistudio_update"

.macro ChooseSongFromAccumulator 
    ; choose the song with LDA above this macro
    LDA #00
    jsr famistudio_music_play
.endmacro

.macro ChooseSongFromAccumulatorSFX 
    ; choose the song with LDA above this macro
    LDA #00
    jsr famistudio_sfx_play
.endmacro
