; Macro for music
.import famistudio_sfx_play, famistudio_music_play
.import famistudio_init
.import famistudio_sfx_init

.macro InitializeSongs
; Setup music

    LDA #00 ; set music to PAL
    LDX #.lobyte(music_data_coinheist) ; load the low bytes 
    LDY #.hibyte(music_data_coinheist) ; load the high bytes
    jsr famistudio_init ; load the X/Y registers so that the engine can correctly place them for later use

    LDA #00 ; set sfx to PAL
    LDX #.lobyte(sounds) ; load the low bytes 
    LDY #.hibyte(sounds) ; load the high bytes
    jsr famistudio_sfx_init ; load the X/Y registers so that the engine can correctly place them for later use


    ; do the same with hi/lo for each song
.endmacro

.macro ChooseSong song
    ; choose the song with LDA 
    LDA #song
    jsr famistudio_music_play
.endmacro

.macro ChooseSFX sfx
    ; choose the song with LDA above this macro
    LDA #sfx
    LDX #0   ; force interrupt so a new one can play
    jsr famistudio_sfx_play
.endmacro