; import engine function to handle the correct music
.import famistudio_music_play ; isnt needed in main anymore
.import famistudio_sfx_play

.include "musicMacro.s" ; sets macro    - i assume the music is already initialized on the start
.include "consts.s"
.include "graphicsMacro.s"

; Backgrounds from graphics.s
.import gameScreenMap
.import startScreenMap
.import endScreenMap

; Counter
.importzp second_counter
.import current_scene
.import list_pickup
.import spawn_new_pickup

; exports for intitialization
.export initialize_scene_start, initialize_scene_game, initialize_scene_end

initialize_scene_start:
   LDA #SONG_START ; load the value of Startscreen music (can make consts)
   ChooseSongFromAccumulator

   lda #SCENE_STARTSCREEN ; Load const var into accumulator
   sta current_scene ; update current_scene var

   DrawBackground startScreenMap ; Update background
rts


initialize_scene_game:
    LDA #01; load the value of game music (can make consts)
    ChooseSongFromAccumulatorSFX

    lda #SCENE_GAME ; Load const var into accumulator
    sta current_scene ; update current_scene var
    
    SetClock #02, #30  ; Start clock at 2:30

    DrawBackground gameScreenMap ; Update background
rts

initialize_scene_end:
    LDA #00 ; load the value of end music (can make consts)
    ChooseSongFromAccumulator

    lda #SCENE_ENDSCREEN
    sta current_scene

     DrawBackground endScreenMap ; Update background
rts