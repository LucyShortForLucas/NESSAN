;; IMPORTS AND EXPORTS
.include "consts.s"
.include "graphicsMacro.s"

.export start_screen_scene    

.import current_scene         
.import initialize_scene_game 

.importzp inputs              
.importzp rand                
.import prng                  

; ------------------------------------------------------------------------

start_screen_scene:
    ldy #$00
    DrawSelectorPointer #POINTER_X_POS, #POINTER_Y_POS
    
    inc rand ; increment seed by 1 every frame, giving us a 'random' frame on game start
    bne @no_overflow
        inc rand+1
    @no_overflow:
    jsr prng ; Call the prng every frame for a more 'random' seed

    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skip ; skips scene change if nothing is pressed
    jsr initialize_scene_game ; initialize scene
@skip:

    rts

