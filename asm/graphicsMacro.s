
; Backgrounds
.import background

.import palettes

.import CoinFrame1, CoinFrame2

.import BluePlayerRight1, BluePlayerRight2, BluePlayerLeft1, BluePlayerLeft2
.import BluePlayerDown1, BluePlayerDown2, BluePlayerDown3
.import BluePlayerUp1, BluePlayerUp2, BluePlayerUp3

.import RedPlayerRight1, RedPlayerRight2, RedPlayerLeft1, RedPlayerLeft2
.import RedPlayerDown1, RedPlayerDown2, RedPlayerDown3
.import RedPlayerUp1, RedPlayerUp2, RedPlayerUp3

.importzp clock_min, clock_sec, clock_frames
.importzp score1, score2
.importzp blue_player_dir, red_player_dir
.importzp inputs, frame_counter

; ==============================================================================
; PUBLIC USE DRAWING MACROS
; ==============================================================================

.macro DrawBackground
.scope
    lda $2002            ; Reset PPU latch
    lda #$20
    sta $2006            ; Set address to $2000
    lda #$00
    sta $2006

    ldx #$00
LoadFirstQuarter:
    lda background, x
    sta $2007
    inx
    bne LoadFirstQuarter

LoadSecondQuarter:
    lda background + 256, x
    sta $2007
    inx
    bne LoadSecondQuarter

LoadThirdQuarter:
    lda background + 512, x
    sta $2007
    inx
    bne LoadThirdQuarter

LoadFourthQuarter:
    lda background + 768, x
    sta $2007
    inx
    bne LoadFourthQuarter
.endscope
.endmacro

.macro DrawCoin
.scope
    DrawAnimatedMetasprite2Frames math_buffer+0, math_buffer+1, CoinFrame1, CoinFrame2, $20
.endscope
.endmacro

.macro DrawBluePlayer x_pos, y_pos
.scope
    ; Check Idle or Moving
    lda inputs
    and #%00001111
    bne CheckCollision   
    jmp HandleIdleState  

CheckCollision:
    ; Check Collision
    lda blue_player_dir
    cmp #4
    bcc DoMovement       ; If < 4, Move
    jmp HandleIdleState  ; If >= 4, Idle

DoMovement:
    lda blue_player_dir
    cmp #1
    bne CheckLeft       
    jmp AnimateUp        
    
CheckLeft:
    cmp #2
    bne CheckRight       
    jmp AnimateLeft      

CheckRight:
    cmp #3
    bne DoDefaultDown   
    jmp AnimateRight     

DoDefaultDown:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, BluePlayerDown1, BluePlayerDown2, BluePlayerDown1, BluePlayerDown3, $08
    jmp PlayerDone

AnimateUp:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, BluePlayerUp1, BluePlayerUp2, BluePlayerUp1, BluePlayerUp3, $08
    jmp PlayerDone
AnimateLeft:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, BluePlayerLeft1, BluePlayerLeft2, $08
    jmp PlayerDone
AnimateRight:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, BluePlayerRight1, BluePlayerRight2, $08
    jmp PlayerDone

HandleIdleState:
    ; Mask out collision flag
    lda blue_player_dir
    and #%00000011

    cmp #1
    bne CheckIdleLeft   
    jmp IdleUp

CheckIdleLeft:
    cmp #2
    bne CheckIdleRight  
    jmp IdleLeft

CheckIdleRight:
    cmp #3
    bne DoIdleDown       
    jmp IdleRight

DoIdleDown:
    DrawMetasprite x_pos, y_pos, BluePlayerDown1
    jmp PlayerDone

IdleUp:
    DrawMetasprite x_pos, y_pos, BluePlayerUp1
    jmp PlayerDone
IdleLeft:
    DrawMetasprite x_pos, y_pos, BluePlayerLeft1
    jmp PlayerDone
IdleRight:
    DrawMetasprite x_pos, y_pos, BluePlayerRight1

PlayerDone:
.endscope
.endmacro

.macro DrawRedPlayer x_pos, y_pos
.scope
    ; Check Idle or Moving
    lda inputs+1
    and #%00001111
    bne CheckCollision   
    jmp HandleIdleState  

CheckCollision:
    ; Check Collision
    lda red_player_dir
    cmp #4
    bcc DoMovement       ; If < 4, Move
    jmp HandleIdleState  ; If >= 4, Idle

DoMovement:
    lda red_player_dir
    cmp #1
    bne CheckLeft       
    jmp AnimateUp        
    
CheckLeft:
    cmp #2
    bne CheckRight       
    jmp AnimateLeft      

CheckRight:
    cmp #3
    bne DoDefaultDown   
    jmp AnimateRight     

DoDefaultDown:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, RedPlayerDown1, RedPlayerDown2, RedPlayerDown1, RedPlayerDown3, $08
    jmp PlayerDone

AnimateUp:
    DrawAnimatedMetasprite4Frames x_pos, y_pos, RedPlayerUp1, RedPlayerUp2, RedPlayerUp1, RedPlayerUp3, $08
    jmp PlayerDone
AnimateLeft:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, RedPlayerLeft1, RedPlayerLeft2, $08
    jmp PlayerDone
AnimateRight:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, RedPlayerRight1, RedPlayerRight2, $08
    jmp PlayerDone

HandleIdleState:
    ; Mask out collision flag
    lda red_player_dir
    and #%00000011

    cmp #1
    bne CheckIdleLeft   
    jmp IdleUp

CheckIdleLeft:
    cmp #2
    bne CheckIdleRight  
    jmp IdleLeft

CheckIdleRight:
    cmp #3
    bne DoIdleDown       
    jmp IdleRight

DoIdleDown:
    DrawMetasprite x_pos, y_pos, RedPlayerDown1
    jmp PlayerDone

IdleUp:
    DrawMetasprite x_pos, y_pos, RedPlayerUp1
    jmp PlayerDone
IdleLeft:
    DrawMetasprite x_pos, y_pos, RedPlayerLeft1
    jmp PlayerDone
IdleRight:
    DrawMetasprite x_pos, y_pos, RedPlayerRight1

PlayerDone:
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

; ==============================================================================
; HELPER DRAWING MACROS (CAN BE PUBLIC USE)
; ==============================================================================

.macro CalcTensAndOnes variable
.scope
    lda variable
    ldx #0
SubtractTenLoop:
    cmp #10
    bcc CalculationDone  ; If < 10, we have the ones digit
    sbc #10
    inx                  ; Increment tens counter
    jmp SubtractTenLoop
CalculationDone:
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
    lda frame_counter
    and #speed
    bne DrawFrameTwo

DrawFrameOne:
    DrawMetasprite x_pos, y_pos, frame1
    jmp AnimationDone

DrawFrameTwo:
    DrawMetasprite x_pos, y_pos, frame2

AnimationDone:
.endscope
.endmacro

.macro DrawAnimatedMetasprite4Frames x_pos, y_pos, f1, f2, f3, f4, speed
.scope
    lda frame_counter
    and #(speed * 2)     ; Check upper bit for frames 3-4
    beq DoFramesOneAndTwo       
    jmp CheckFramesThreeAndFour 

DoFramesOneAndTwo:
    lda frame_counter
    and #speed
    bne DrawFrameTwo
    
    DrawMetasprite x_pos, y_pos, f1
    jmp AnimationDone

DrawFrameTwo:
    DrawMetasprite x_pos, y_pos, f2
    jmp AnimationDone

CheckFramesThreeAndFour:
    lda frame_counter
    and #speed
    bne DrawFrameFour

    DrawMetasprite x_pos, y_pos, f3
    jmp AnimationDone

DrawFrameFour:
    DrawMetasprite x_pos, y_pos, f4

AnimationDone:
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
    bne CheckFrames      
    jmp ClockFinished    

CheckFrames:
    dec clock_frames
    beq ResetFrames      
    jmp ClockFinished    

ResetFrames:
    ; Second passed
    lda #50              ; Reset frames (PAL)
    sta clock_frames

    dec clock_sec
    lda clock_sec
    cmp #$FF             ; Check underflow
    beq ResetSeconds     
    jmp ClockFinished    

ResetSeconds:
    ; Minute passed
    lda #59              ; Reset seconds
    sta clock_sec
    dec clock_min
    
    lda clock_min
    cmp #$FF
    beq ForceStop        
    jmp ClockFinished    

ForceStop:
    ; Hard Stop (Force 00:00 on underflow)
    lda #0
    sta clock_min
    sta clock_sec

ClockFinished:
.endscope
.endmacro

; Usage: UpdateScore score1, 1
.macro UpdateScore score_var, increment
.scope
    lda score_var
    clc 
    adc #increment
    sta score_var
    
    ; Cap at 99
    cmp #100
    bcc ScoreUpdateDone
    lda #99
    sta score_var

ScoreUpdateDone:
.endscope
.endmacro