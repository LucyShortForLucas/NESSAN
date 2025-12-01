
.importzp inputs
.import current_scene

.export start_screen_scene
.importzp rand

.include "consts.s"

; test
.import initialize_scene_game

start_screen_scene:
    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skip ; skips to end if nothing is pressed
        lda #SCENE_GAME ; Move to game after Start is pressed
        sta current_scene

        jsr initialize_scene_game ; initialize scene
        
        inc rand ; increment seed by 1 every frame, giving us a 'random' frame on game start

        bne @no_overflow
            inc rand+1
        @no_overflow:

    @skip:
    rts

