;; IMPORTS AND EXPORTS
.import background

.import palettes

.import CoinFrame1, CoinFrame2

.import BluePlayerRight1, BluePlayerRight2, BluePlayerLeft1, BluePlayerLeft2
.import BluePlayerDown1, BluePlayerDown2, BluePlayerDown3
.import BluePlayerUp1, BluePlayerUp2, BluePlayerUp3

.import RedPlayerRight1, RedPlayerRight2, RedPlayerLeft1, RedPlayerLeft2
.import RedPlayerDown1, RedPlayerDown2, RedPlayerDown3
.import RedPlayerUp1, RedPlayerUp2, RedPlayerUp3

.import AbilityDash, AbilityGun, AbilityPhase

.import Pointer, EmptyPointer
.import TimeUpText, PlayerWinText, WinText

.importzp clock_min, clock_sec, clock_frames
.importzp score1, score2
.importzp blue_player_dir, red_player_dir
.importzp inputs, frame_counter

.importzp ability_red_passtrough_timers, ability_blue_passtrough_timers

.import AbilityDashIconRed, AbilityGunIconRed, AbilityPhaseIconRed, AbilityBombIconRed
.import AbilityDashIconBlue, AbilityGunIconBlue, AbilityPhaseIconBlue, AbilityBombIconBlue
.import AbilityDashFrame1, AbilityGunFrame1, AbilityPhaseFrame1, AbilityDashFrame2, AbilityGunFrame2, AbilityPhaseFrame2, AbilityBombFrame1, AbilityBombFrame2

.import PASSTHROUGH_ANIMATION_MAX_DOUBLE

; ------------------------------------------------------------------------

; ==============================================================================
; PUBLIC USE DRAWING MACROS
; ==============================================================================

.macro DrawBackground background
.scope
; Disable rendering so we can write to VRAM safely
    lda #$00
    sta $2001      

WaitForVblank:
    bit $2002 ; set negative flag to -1
    bpl WaitForVblank ; see if negative flag is 0
wait_for_vblank:
    bit PPU_STATUS
    bpl wait_for_vblank

    lda PPU_STATUS    ; reset latch
    lda #$20
    sta PPU_ADDR    ; high byte of address: $20xx
    lda #$00
    sta PPU_ADDR    ; low byte: $2000

; else write to ppudata
    ldx #$00
load_first_quarter:
    lda background, x
    sta PPU_DATA
    inx
    bne load_first_quarter

load_second_quarter:
    lda background + 256, x
    sta PPU_DATA
    inx
    bne load_second_quarter

load_third_quarter:
    lda background + 512, x
    sta PPU_DATA
    inx
    bne load_third_quarter

load_fourth_quarter:
    lda background + 768, x
    sta PPU_DATA
    inx
    bne load_fourth_quarter

    ; Re-enable rendering
    lda #%00011110  ; enable BG + sprites, maybe left-clip off etc.
    sta $2001
.endscope
.endmacro

.macro DrawPickup
.scope
    lda list_pickup+2, x   ; Load the type

    cmp #PICKUP_DASH
    bne check_gun       ; If not 1, hop over
    jmp pickup_dash     ; If is 1, jump to the label 

check_gun:
    cmp #PICKUP_GUN
    bne check_phase     ; If not 2, hop over
    jmp pickup_gun      ; If is 2, jump

check_phase:
    cmp #PICKUP_PASSTHROUGH
    bne check_bomb    ; If not 3, hop over
    jmp pickup_phase    ; If is 3, jump

check_bomb:
    cmp #PICKUP_BOMB
    bne draw_default    ; If not 4, hop over
    jmp pickup_bomb    ; If is 4, jump

draw_default:
    DrawCoin
    rts

pickup_dash:
    DrawDash
    rts

pickup_gun:
    DrawGun
    rts

pickup_phase:
    DrawPhase
    rts

pickup_bomb:
    DrawBomb
    rts
.endscope
.endmacro

.macro DrawCoin
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, CoinFrame1, CoinFrame2, $20
.endscope
.endmacro

.macro DrawDash
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, AbilityDashFrame1, AbilityDashFrame2, $20
.endscope
.endmacro

.macro DrawGun
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, AbilityGunFrame1, AbilityGunFrame2, $20
.endscope
.endmacro

.macro DrawPhase
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, AbilityPhaseFrame1, AbilityPhaseFrame2, $20
.endscope
.endmacro

.macro DrawBomb
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, AbilityBombFrame1, AbilityBombFrame2, $20
.endscope
.endmacro

.macro DrawBluePlayer x_pos, y_pos
.scope
    ; Check if blue player has invis frames
    lda ability_blue_passtrough_timers
    beq draw_player       ; If 0, ignore skipping check and draw
    ; if not, check animation timer to see if we should draw or skip
    lda ability_blue_passtrough_timers+1
    cmp #PASSTHROUGH_ANIMATION_MAX_DIV2
    bpl draw_player       ; If above threshold, draw!
    jmp player_done      ; else skip drawing entirely
draw_player:
    ; Check Idle or Moving
    lda inputs
    and #%00001111
    bne check_collision   
    jmp handle_idle_state  

check_collision:
    ; Check Collision
    lda blue_player_dir
    cmp #4
    bcc do_movement       ; If < 4, Move
    jmp handle_idle_state  ; If >= 4, Idle

do_movement:
    lda blue_player_dir
    cmp #1
    bne check_left       
    jmp animate_up         
check_left:
    cmp #2
    bne check_right       
    jmp animate_left      
check_right:
    cmp #3
    bne animate_down   
    jmp animate_right     

animate_down:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, BluePlayerDown1, BluePlayerDown2, BluePlayerDown1, BluePlayerDown3, $08
    jmp player_done 
animate_up:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, BluePlayerUp1, BluePlayerUp2, BluePlayerUp1, BluePlayerUp3, $08
    jmp player_done
animate_left:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, BluePlayerLeft1, BluePlayerLeft2, $08
    jmp player_done
animate_right:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, BluePlayerRight1, BluePlayerRight2, $08
    jmp player_done

handle_idle_state:
    ; Mask out collision flag
    lda blue_player_dir
    and #%00000011

    cmp #1
    bne check_idle_left   
    jmp idle_up
check_idle_left:
    cmp #2
    bne check_idle_right  
    jmp idle_left
check_idle_right:
    cmp #3
    bne idle_down       
    jmp idle_right

idle_down:
    DrawMetasprite x_pos, y_pos, BluePlayerDown1
    jmp player_done
idle_up:
    DrawMetasprite x_pos, y_pos, BluePlayerUp1
    jmp player_done
idle_left:
    DrawMetasprite x_pos, y_pos, BluePlayerLeft1
    jmp player_done
idle_right:
    DrawMetasprite x_pos, y_pos, BluePlayerRight1

player_done:
.endscope
.endmacro

.macro DrawRedPlayer x_pos, y_pos
.scope
    ; Check if red player has invis frames
    lda ability_red_passtrough_timers
    beq draw_player       ; If 0, ignore skipping check and draw
    ; if not, check animation timer to see if we should draw or skip
    lda ability_red_passtrough_timers+1
    cmp #PASSTHROUGH_ANIMATION_MAX_DIV2
    bpl draw_player       ; If above threshold, draw!
    jmp player_done      ; else skip drawing entirely
draw_player:

    ; Check Idle or Moving
    lda inputs+1
    and #%00001111
    bne check_collision   
    jmp handle_idle_state 

check_collision:
    ; Check Collision
    lda red_player_dir
    cmp #4
    bcc do_movement       ; If < 4, Move
    jmp handle_idle_state  ; If >= 4, Idle

do_movement:
    lda red_player_dir
    cmp #1
    bne check_left       
    jmp animate_up        
check_left:
    cmp #2
    bne check_right       
    jmp animate_left      
check_right:
    cmp #3
    bne animate_down   
    jmp animate_right     

animate_down:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, RedPlayerDown1, RedPlayerDown2, RedPlayerDown1, RedPlayerDown3, $08
    jmp player_done
animate_up:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, RedPlayerUp1, RedPlayerUp2, RedPlayerUp1, RedPlayerUp3, $08
    jmp player_done
animate_left:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, RedPlayerLeft1, RedPlayerLeft2, $08
    jmp player_done
animate_right:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, RedPlayerRight1, RedPlayerRight2, $08
    jmp player_done

handle_idle_state:
    ; Mask out collision flag
    lda red_player_dir
    and #%00000011

    cmp #1
    bne check_idle_left   
    jmp idle_up
check_idle_left:
    cmp #2
    bne check_idle_right  
    jmp idle_left
check_idle_right:
    cmp #3
    bne idle_down       
    jmp idle_right

idle_down:
    DrawMetasprite x_pos, y_pos, RedPlayerDown1
    jmp player_done
idle_up:
    DrawMetasprite x_pos, y_pos, RedPlayerUp1
    jmp player_done
idle_left:
    DrawMetasprite x_pos, y_pos, RedPlayerLeft1
    jmp player_done
idle_right:
    DrawMetasprite x_pos, y_pos, RedPlayerRight1

player_done:
.endscope
.endmacro

.macro DrawClock x_pos, y_pos
.scope
    ; Calculate Minutes
    CalcTensAndOnes clock_min
    pha                  ; Save Ones (A)
    txa                  ; Move Tens (X) to A
    
    ; Draw Minutes
    DrawDigit a, x_pos, y_pos, 0   ; Draw Tens
    pla                  ; Restore Ones
    DrawDigit a, x_pos, y_pos, 8   ; Draw Ones

    ; Draw Colon
    lda #$3A             ; Colon Tile
    sta $0201, y
    lda #$01             ; Palette
    sta $0202, y
    lda x_pos
    clc
    adc #16              ; Offset 16px
    sta $0203, y
    lda y_pos
    sta $0200, y
    iny                  ; Manually bump OAM for colon
    iny
    iny
    iny

    ; Calculate Seconds
    CalcTensAndOnes clock_sec
    pha                  ; Save Ones
    txa                  ; Move Tens to A

    ; Draw Seconds
    DrawDigit a, x_pos, y_pos, 24  ; Draw Tens
    pla                  ; Restore Ones
    DrawDigit a, x_pos, y_pos, 32  ; Draw Ones
.endscope
.endmacro

.macro DrawScore x_pos, y_pos, score_var
.scope
    ; Calculate Score
    CalcTensAndOnes score_var
    pha                  ; Save Ones
    txa                  ; Move Tens to A

    ; Draw Digits
    DrawDigit a, x_pos, y_pos, 0   ; Draw Tens
    pla                  ; Restore Ones
    DrawDigit a, x_pos, y_pos, 8   ; Draw Ones
.endscope
.endmacro

.macro DrawAbilityRed x_pos, y_pos, ability_lbl
.scope
    lda ability_lbl     ; Load the ability value (0=Empty, 1=Dash, 2=Gun, 3=Phase, 4=Bomb)
    bne draw            ; If NOT 0, draw
    jmp done            ; If 0, draw nothing and exit
draw:
    ; Check specific abilities
    cmp #1
    beq render_dash      ; If 1, go to Dash
    
    cmp #2
    beq render_gun       ; If 2, go to Gun

    cmp #3
    beq render_phase     ; If 3, go to Phase
    
    cmp #4
    beq render_bomb      ; If 4, go to Bomb
    
    jmp done            ; Safety catch (if value is >4)

render_dash:
    DrawSprite x_pos, y_pos, AbilityDashIconRed
    jmp done
render_gun:
    DrawSprite x_pos, y_pos, AbilityGunIconRed
    jmp done
render_phase:
    DrawSprite x_pos, y_pos, AbilityPhaseIconRed
    jmp done
render_bomb:
    DrawSprite x_pos, y_pos, AbilityBombIconRed
    jmp done

done:
.endscope
.endmacro

.macro DrawAbilityBlue x_pos, y_pos, ability_lbl
.scope
    lda ability_lbl     ; Load the ability value (0=Empty, 1=Dash, 2=Gun, 3=Phase, 4=Bomb)
    bne draw            ; If NOT 0, draw
    jmp done            ; If 0, draw nothing and exit
draw:
    ; Check specific abilities
    cmp #1
    beq render_dash      ; If 1, go to Dash
    
    cmp #2
    beq render_gun       ; If 2, go to Gun

    cmp #3
    beq render_phase     ; If 3, go to Phase
    
    cmp #4
    beq render_bomb     ; If 4, go to Bomb
    
    jmp done            ; Safety catch (if value is >4)

render_dash:
    DrawSprite x_pos, y_pos, AbilityDashIconBlue
    jmp done
render_gun:
    DrawSprite x_pos, y_pos, AbilityGunIconBlue
    jmp done
render_phase:
    DrawSprite x_pos, y_pos, AbilityPhaseIconBlue
    jmp done
render_bomb:
    DrawSprite x_pos, y_pos, AbilityBombIconBlue
    jmp done

done:
.endscope
.endmacro

; ==============================================================================
; HELPER DRAWING MACROS (CAN BE PUBLIC USE)
; ==============================================================================

.macro CalcTensAndOnes variable
.scope
    lda variable
    ldx #0
subtract_ten_loop:
    cmp #10
    bcc calculation_done  ; If < 10, we have the ones digit
    sbc #10
    inx                  ; Increment tens counter
    jmp subtract_ten_loop
calculation_done:
.endscope
.endmacro

.macro DrawDigit val_acc, x_ref, y_ref, x_offset
.scope
    clc
    adc #$30             ; Convert number to ASCII tile
    sta $0201, y         ; Store Tile ID
    lda #$01
    sta $0202, y         ; Palette
    lda x_ref
    clc
    adc #x_offset        ; Shift X position
    sta $0203, y
    lda y_ref
    sta $0200, y         ; Store Y
    iny                  ; Advance OAM index (4 bytes)
    iny
    iny
    iny
.endscope
.endmacro

.macro DrawSprite x_pos, y_pos, data_lbl
.scope
    ; Y Position
    lda data_lbl      ; Load byte 0 (Relative Y) from data
    clc
    adc y_pos         ; Add World Y position
    sta $0200, y      ; Store in OAM buffer
    iny               ; Move OAM index

    ; Tile ID
    lda data_lbl+1    ; Load byte 1 (Tile ID)
    sta $0200, y
    iny

    ; Attributes
    lda data_lbl+2    ; Load byte 2 (Attributes/Palette)
    sta $0200, y
    iny

    ; X Position
    lda data_lbl+3    ; Load byte 3 (Relative X)
    clc
    adc x_pos         ; Add World X position
    sta $0200, y
    iny
.endscope
.endmacro

.macro DrawMetasprite x_pos, y_pos, data_lbl
.scope
    ldx #$00             ; Reset data index
TileLoop:
    ; Y Position
    lda data_lbl, x
    clc
    adc y_pos            ; Add World Y
    sta $0200, y
    inx
    iny

    ; Tile ID
    lda data_lbl, x
    sta $0200, y
    inx
    iny

    ; Attributes
    lda data_lbl, x
    sta $0200, y
    inx
    iny

    ; X Position
    lda data_lbl, x
    clc
    adc x_pos            ; Add World X
    sta $0200, y
    inx
    iny

    cpx #$10             ; Done 4 tiles
    bne TileLoop
.endscope
.endmacro

.macro DrawAnimatedMetasprite2Frames x_pos, y_pos, frame1, frame2, speed
.scope
    lda frame_counter ; check the global frame counter to decide which frame to show
    and #speed ; use a bitmask to control the animation speed
    bne draw_frame_two ; if the result is not zero, jump to the second frame

draw_frame_one:
    ; draw the first frame of the animation
    DrawMetasprite x_pos, y_pos, frame1
    jmp animation_done

draw_frame_two:
    ; draw the second frame of the animation
    DrawMetasprite x_pos, y_pos, frame2

animation_done:
.endscope
.endmacro

.macro DrawAnimatedMetasprite4Frames x_pos, y_pos, f1, f2, f3, f4, speed
.scope
    lda frame_counter
    and #(speed * 2)     ; Check upper bit for frames 3-4
    beq do_frames_one_and_two       
    jmp check_frames_three_and_four 

do_frames_one_and_two:
    lda frame_counter
    and #speed
    bne draw_frame_two
    
    DrawMetasprite x_pos, y_pos, f1
    jmp animation_done

draw_frame_two:
    DrawMetasprite x_pos, y_pos, f2
    jmp animation_done

check_frames_three_and_four:
    lda frame_counter
    and #speed
    bne draw_frame_four

    DrawMetasprite x_pos, y_pos, f3
    jmp animation_done

draw_frame_four:
    DrawMetasprite x_pos, y_pos, f4

animation_done:
.endscope
.endmacro

; ==============================================================================
; OTHER MACROS (LOGIC & UPDATES)
; ==============================================================================

; Usage: SetClock #02, #30 (2m 30s)
.macro SetClock minutes, seconds
.scope
    lda minutes
    sta clock_min
    lda seconds
    sta clock_sec
    lda #50              ; Reset PAL frames
    sta clock_frames
.endscope
.endmacro

.macro UpdateClock
.scope
    ; Check if 00:00
    lda clock_min
    ora clock_sec
    bne check_frames      
    jmp clock_finished    

check_frames:
    dec clock_frames
    beq reset_frames      
    jmp clock_finished    

reset_frames:
    ; Second passed
    lda #50              ; Reset frames (PAL)
    sta clock_frames

    dec clock_sec
    lda clock_sec
    cmp #$FF             ; Check underflow
    beq reset_seconds     
    jmp clock_finished    

reset_seconds:
    ; Minute passed
    lda #59              ; Reset seconds
    sta clock_sec
    dec clock_min
    
    lda clock_min
    cmp #$FF
    beq force_stop        
    jmp clock_finished    

force_stop:
    ; Hard Stop (Force 00:00 on underflow)
    lda #0
    sta clock_min
    sta clock_sec

clock_finished:
.endscope
.endmacro

; Usage: UpdateScore score1, 1
.macro UpdateScore score_var, increment
.scope
    lda score_var
    clc 
    adc #increment
    sta score_var
    
    ; Cap at variable in consts
    cmp #COIN_CAP
    bcc score_update_done
    lda #COIN_CAP
    sta score_var

score_update_done:
.endscope
.endmacro

; Yanto title codes

.macro DrawSelectorPointer x_pos, y_pos ; make it flash
.scope
;  DrawSelectorPointer #80, #136    
DrawSprite x_pos, y_pos, Pointer
.endscope
.endmacro

.macro DrawBlueWins
.scope
    DrawMetasprite #120, #80, BluePlayerDown1
    DrawText #112, #112, WinText, $10
.endscope
.endmacro

.macro DrawRedWins
.scope
    DrawMetasprite #120, #80, RedPlayerDown1
    DrawText #112, #112, WinText, $10
.endscope
.endmacro

.macro DrawTimeUp 
.scope
    DrawText #96, #112, TimeUpText, $1C
.endscope
.endmacro

.macro DrawText x_pos, y_pos, data_lbl, count 
.scope
    ldx #$00             ; Reset data index
text_loop:
    ; Y Position
    lda data_lbl, x
    clc
    adc y_pos            ; Add World Y
    sta $0200, y
    inx
    iny

    ; Tile ID
    lda data_lbl, x
    sta $0200, y
    inx
    iny

    ; Attributes
    lda data_lbl, x
    sta $0200, y
    inx
    iny

    ; X Position
    lda data_lbl, x
    clc
    adc x_pos            ; Add World X
    sta $0200, y
    inx
    iny

    cpx #count             ; check if max amount of letters is reached
    bne text_loop
.endscope
.endmacro