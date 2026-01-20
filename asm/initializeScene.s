;; IMPORTS AND EXPORTS
.include "consts.s"
.include "graphicsMacro.s"
.include "musicMacro.s"

.export initialize_scene_start 
.export initialize_scene_game  
.export initialize_scene_end   

.import gameScreenMap
.import startScreenMap
.import endScreenMap

.import current_scene          
.importzp second_counter       

.import list_pickup
.import spawn_new_pickup

.importzp blue_player_x, blue_player_y
.importzp red_player_x, red_player_y

.importzp score_red, score_blue
.importzp ability_blue, ability_red

; ------------------------------------------------------------------------

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
    lda #00
    sta score_red ; reset scores
    sta score_blue
    sta ability_blue ; reset abilities
    sta ability_red

    lda #RED_PLAYER_SPAWN_X ; reset red position
    sta red_player_x
    lda #RED_PLAYER_SPAWN_Y
    sta red_player_y
    lda #BLUE_PLAYER_SPAWN_X ; reset blue position
    sta blue_player_x
    lda #BLUE_PLAYER_SPAWN_Y
    sta blue_player_y

    DrawBackground gameScreenMap ; Update background
    rts

initialize_scene_end:
    ; Stopping the music so the next can start clean
    jsr famistudio_music_stop

    lda #SCENE_ENDSCREEN
    sta current_scene

    SetClock #00, #03 ; How long the deathscreen will be displayed

     DrawBackground endScreenMap ; Update background
    rts