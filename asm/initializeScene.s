.include "musicMacro.s"
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
   ChooseSong SONG_START

   lda #SCENE_STARTSCREEN ; Load const var into accumulator
   sta current_scene ; update current_scene var

   DrawBackground startScreenMap ; Update background
rts


initialize_scene_game:
    ChooseSong SONG_START
    
    lda #SCENE_GAME ; Load const var into accumulator
    sta current_scene ; update current_scene var
    
    SetClock #02, #30  ; Start clock at 2:30

    DrawBackground gameScreenMap ; Update background
rts

initialize_scene_end:
    ChooseSong SONG_START

    lda #SCENE_ENDSCREEN
    sta current_scene

     DrawBackground endScreenMap ; Update background
rts