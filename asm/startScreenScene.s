
.importzp inputs
.import current_scene
.import prng

.export start_screen_scene
.importzp rand

.include "consts.s"
.include "graphicsMacro.s"
; test
.import initialize_scene_end

start_screen_scene:
    ldy #$00
    DrawSelectorPointer #Pointer_X_pos, #Pointer_Y_pos
    
    inc rand ; increment seed by 1 every frame, giving us a 'random' frame on game start
    bne @no_overflow
        inc rand+1
    @no_overflow:
    jsr prng ; Call the prng every frame for a more 'random' seed

    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skip ; skips scene change if nothing is pressed
    jsr initialize_scene_end ; initialize scene
@skip:

    rts

