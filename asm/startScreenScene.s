
.importzp inputs
.import current_scene

.export start_screen_scene

.include "consts.s"

start_screen_scene:
    lda inputs
    and #%00010000
    beq @skip
    lda #SCENE_GAME
    sta current_scene
    

    @skip:
    rts