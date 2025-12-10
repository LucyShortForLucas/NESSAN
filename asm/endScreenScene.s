
.importzp inputs
.import current_scene
.import endState
.import initialize_scene_start

.include "consts.s"
.include "graphicsMacro.s"
.include "musicMacro.s"

.export end_screen_scene

end_screen_scene:
    ldy #$00
    
    ; check which type of win happend
    lda endState ; Load the endstate from RAM to compare and choose the correct display
    bne TimeUp
    cmp #endState_Player1 ; Player 1 victory
    bne Player_1_Won

; if uncommented leaves behind error code "asm\endScreenScene.s:23: Error: Range error (966 not in [-128..127])"
    ;cmp #endState_Player2 ; Player 2 victory
    ;bne Player_2_Won    

    jmp skip ; if nothing was in the endState just skip towards input
    
    TimeUp:
      ChooseSFX SFX_COIN
      
      DrawTimeUp 
      jmp skip

    Player_1_Won:
      ChooseSFX SFX_COIN

      DrawPlayerWin
      DrawRedPlayer #120, #80
      jmp skip

    Player_2_Won:
      ChooseSFX SFX_COIN

      DrawPlayerWin
      DrawBluePlayer #120, #80

skip:
    lda inputs ; Check for Start Press 
    and #%00010000
    beq @skipScene ; skips scene change if nothing is pressed
    jsr initialize_scene_start ; initialize scene
@skipScene:

    rts

