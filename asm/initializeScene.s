; import engine function to handle the correct music
.import famistudio_music_play ; isnt needed in main anymore

.include "musicMacro.s" ; sets macro    - i assume the music is already initialized on the start
.include "consts.s"
; Counter
.importzp second_counter

; exports for intitialization
.export initialize_scene_start
.export initialize_scene_game
.export initialize_scene_end

initialize_scene_start:
   LDA #SONG_START ; load the value of Startscreen music (can make consts)
   ChooseSongFromAccumulator
rts


initialize_scene_game:
    LDA #SONG_START ; load the value of game music (can make consts)
    ChooseSongFromAccumulator

    ; isnt tested yet
    LDA #00
    sta second_counter ; set low byte of counter to 0
    sta second_counter+1 ; set high byte of counter to 0
rts

initialize_scene_end:
    LDA #00 ; load the value of end music (can make consts)
    ChooseSongFromAccumulator
rts