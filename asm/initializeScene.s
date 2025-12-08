; import engine function to handle the correct music
.import famistudio_music_play ; isnt needed in main anymore
.import famistudio_sfx_play

.include "musicMacro.s" ; sets macro    - i assume the music is already initialized on the start
.include "consts.s"


; Counter
.importzp second_counter
.import current_scene
.import list_pickup
.import spawn_new_pickup

; exports for intitialization
.export initialize_scene_start
.export initialize_scene_game
.export initialize_scene_end

initialize_scene_start:
   LDA #SONG_START ; load the value of Startscreen music (can make consts)
   ChooseSongFromAccumulator
   lda #SCENE_STARTSCREEN
   sta current_scene
rts


initialize_scene_game:
    LDA #01; load the value of game music (can make consts)
    ChooseSongFromAccumulatorSFX

    ; Set Clock
;    SetClock #02, #30  ; Start clock at 2:30

rts

initialize_scene_end:
    LDA #00 ; load the value of end music (can make consts)
    ChooseSongFromAccumulator

    lda #SCENE_ENDSCREEN
    sta current_scene
rts