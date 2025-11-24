
.importzp inputs
.import current_scene

.export start_screen_scene
.importzp rand

.include "consts.s"

start_screen_scene:
    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skip
    lda #SCENE_GAME ; Move to game after Start is pressed
    sta current_scene
    
    inc rand ; increment seed by 1 every frame, giving us a 'random' frame on game start
    bne @no_overflow
    inc rand+1
    @no_overflow:

    @skip:
    rts