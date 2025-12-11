
.importzp inputs
.import current_scene
.import end_state
.import initialize_scene_start

.include "consts.s"
.include "graphicsMacro.s"
.include "musicMacro.s"

.export end_screen_scene

end_screen_scene:
    ldy #$00
    
    ; check which type of win happend
    lda end_state ; Load the endstate from RAM to compare and choose the correct display
    cmp #ENDSTATE_TIMERUP
    beq time_up
    cmp #ENDSTATE_BLUEWINS ; Player 1 victory
    beq blue_won
    jmp skip_until_red ; if nothing was in the endState just skip towards input
    
    time_up:
      DrawTimeUp 
      jmp skip_until_red

    blue_won:
      DrawBlueWins
      jmp skip_until_red

    skip_until_red: ; due to the jmp being too big for one go this is a inbetween
        cmp #ENDSTATE_REDWINS 
        beq red_won
        jmp skip

    red_won:
     DrawRedWins

skip:
    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skipScene ; skips scene change if nothing is pressed
    jsr initialize_scene_start ; initialize scene

  ; THE GAME GOES TO STARTSCREEN BUT DUE TO IT BEING THE SAME START BUTTON IT INSTANTLY GOES TO GAME

@skipScene:

    rts

