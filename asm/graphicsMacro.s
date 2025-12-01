.import background
.import palettes
.import CoinFrame1
.import CoinFrame2

.import PlayerRight1
.import PlayerRight2
.import PlayerLeft1
.import PlayerLeft2
.import PlayerDown1
.import PlayerDown2
.import PlayerUp1
.import PlayerUp2

.importzp clock_min       
.importzp clock_sec       
.importzp clock_frames    
.importzp player_dir

; -- Drawing Macros --

.macro DrawBackground
.scope
; load full background into $2000 nametable
  lda $2002             ; Reset PPU latch
  lda #$20
  sta $2006             ; Set PPU address to $2000
  lda #$00
  sta $2006

  ldx #$00
@load_chunk_1:
  lda background, x     ; Load from 0-255
  sta $2007
  inx
  bne @load_chunk_1

@load_chunk_2:
  lda background + 256, x ; Load from 256-511
  sta $2007
  inx
  bne @load_chunk_2

@load_chunk_3:
  lda background + 512, x ; Load from 512-767
  sta $2007
  inx
  bne @load_chunk_3

@load_chunk_4:
  lda background + 768, x ; Load from 768-1023
  sta $2007
  inx
  bne @load_chunk_4

.endscope
.endmacro

.macro DrawMetasprite x_pos, y_pos, data_lbl
.scope
ldx #$00            ; Reset Data Index (X reads from ROM)
                    ; Note: We assume Y is already set for OAM index

@loop:                  ; Use @ so this label is local to this macro instance
    ; Byte 1: Y Position
    lda data_lbl, x     ; Load Y Offset from your data
    clc
    adc y_pos           ; Add the Coin's actual World Y
    sta $0200, y        ; Store in Shadow OAM
    inx                 ; Move to next data byte
    iny                 ; Move to next OAM slot

    ; Byte 2: Tile ID
    lda data_lbl, x     ; Load Tile ID ($20, etc.)
    sta $0200, y
    inx
    iny

    ; Byte 3: Attributes
    lda data_lbl, x     ; Load Palette/Flip info
    sta $0200, y
    inx
    iny

    ; Byte 4: X Position 
    lda data_lbl, x     ; Load X Offset from your data
    clc
    adc x_pos           ; Add the Coin's actual World X
    sta $0200, y
    inx
    iny

    ; Check Loop
    cpx #$10            ; Check if we wrote 16 bytes (4 tiles x 4 bytes)
    bne @loop           ; If not, do it again
.endscope
.endmacro

.macro DrawAnimatedMetasprite2Frames x_pos, y_pos, frame1, frame2, speed
.scope
    ; Check the frame counter
    lda frame_counter       
    and #speed              
    bne DoFrame2       

DoFrame1:
    DrawMetasprite x_pos, y_pos, frame1
    jmp Done       

DoFrame2:
    DrawMetasprite x_pos, y_pos, frame2

Done:
.endscope
.endmacro

.macro DrawPlayer x_pos, y_pos
.scope
    ; Check if Player is Moving
    lda inputs
    and #%00001111      
    bne CheckDirs       ; If not zero (moving), short jump to CheckDirs
    jmp IsIdle          ; If zero (idle), long jump to IsIdle

    ; Moving State
CheckDirs:
    lda player_dir
    cmp #1
    bne NotUp           ; If not Up, skip to next check
    jmp AnimUp          ; long jump to Animation
NotUp:
    cmp #2
    bne NotLeft
    jmp AnimLeft
NotLeft:
    cmp #3
    bne NotRight
    jmp AnimRight
NotRight:
    jmp AnimDown        ; Default to Down 

    ; animation stuff
AnimDown:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, PlayerDown1, PlayerDown2, $08
    jmp Done
AnimUp:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, PlayerUp1, PlayerUp2, $08
    jmp Done
AnimLeft:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, PlayerLeft1, PlayerLeft2, $08
    jmp Done
AnimRight:
    DrawAnimatedMetasprite2Frames x_pos, y_pos, PlayerRight1, PlayerRight2, $08
    jmp Done

    ; Idle State
IsIdle:
    lda player_dir
    cmp #1
    bne IdleNotUp
    jmp IdleUp
IdleNotUp:
    cmp #2
    bne IdleNotLeft
    jmp IdleLeft
IdleNotLeft:
    cmp #3
    bne IdleNotRight
    jmp IdleRight
IdleNotRight:
    jmp IdleDown

    ; idle stuff
IdleDown:
    DrawMetasprite x_pos, y_pos, PlayerDown1
    jmp Done
IdleUp:
    DrawMetasprite x_pos, y_pos, PlayerUp1
    jmp Done
IdleLeft:
    DrawMetasprite x_pos, y_pos, PlayerLeft1
    jmp Done
IdleRight:
    DrawMetasprite x_pos, y_pos, PlayerRight1

Done:
.endscope
.endmacro


.macro DrawCoin x_pos, y_pos ; Easy macro to draw the coin with animation
.scope
    DrawAnimatedMetasprite2Frames x_pos, y_pos, CoinFrame1, CoinFrame2, $20
.endscope
.endmacro


.macro DrawClock
.scope
  ; Y is assumed to hold the next available OAM index when this macro is called.
  ; X is used as the source index for the clock_draw_buffer.
  
  ldx #$00          ; Initialize X as the source index (0-15)
@loop: 
  lda clock_draw_buffer, x ; Load sprite byte from source (Y, Tile, Attr, X)
  sta $0200, y      ; Store sprite byte in Shadow OAM at offset Y
  inx               ; Advance source index (X++)
  iny               ; Advance destination index (Y++)
  cpx #$10          ; Check if we copied 16 bytes (4 sprites * 4 bytes/sprite)
  bne @loop
  ; Y is now incremented by 16 and points to the next available OAM slot.
.endscope
.endmacro

.macro DrawClock2 x_pos, y_pos
.scope
    ; Draw Minutes
    lda clock_min
    ldx #0
CalcMinTens:
    cmp #10
    bcc DrawMinTens     ; If A < 10, we have our digits
    sbc #10
    inx                 ; X counts how many "tens"
    jmp CalcMinTens
    
DrawMinTens:
    pha                 ; Push Ones (A) to stack to save for later

    ; Draw Tens (X)
    txa                 ; Move X to A to draw
    clc
    adc #$30            ; Add Base Tile Offset ($30)
    sta $0201, y        ; Tile ID
    lda #$01            ; Palette
    sta $0202, y
    lda x_pos
    sta $0203, y        ; X Pos
    lda y_pos
    sta $0200, y        ; Y Pos
    
    iny                 ; Move OAM index to next sprite (4 bytes)
    iny
    iny
    iny

DrawMinOnes:
    pla                 ; Pull Ones (A) back from stack
    clc
    adc #$30            ; Add Base Tile Offset ($30)
    sta $0201, y
    lda #$01
    sta $0202, y
    lda x_pos
    clc
    adc #8              ; Shift Right 8 pixels
    sta $0203, y
    lda y_pos
    sta $0200, y

    iny
    iny
    iny
    iny

    ; Draw Colon
    lda #$3A            ; Colon Tile ID
    sta $0201, y
    lda #$01
    sta $0202, y
    lda x_pos
    clc
    adc #16             ; Shift Right 16 pixels
    sta $0203, y
    lda y_pos
    sta $0200, y

    iny
    iny
    iny
    iny

    ; Draw Seconds
    lda clock_sec
    ldx #0
CalcSecTens:
    cmp #10
    bcc DrawSecTens
    sbc #10
    inx
    jmp CalcSecTens

DrawSecTens:
    pha                 ; Push Ones to stack

    ; Draw Tens (X)
    txa
    clc
    adc #$30            ; Add Base Tile Offset ($30)
    sta $0201, y
    lda #$01
    sta $0202, y
    lda x_pos
    clc
    adc #24             ; Shift Right 24 pixels
    sta $0203, y
    lda y_pos
    sta $0200, y

    iny
    iny
    iny
    iny

DrawSecOnes:
    pla                 ; Pull Ones from stack
    clc
    adc #$30            ; Add Base Tile Offset ($30)
    sta $0201, y
    lda #$01
    sta $0202, y
    lda x_pos
    clc
    adc #32             ; Shift Right 32 pixels
    sta $0203, y
    lda y_pos
    sta $0200, y

    iny
    iny
    iny
    iny

.endscope
.endmacro

; ---------------------------------------------------
; -- Other essential macros for the drawing macros --
; ---------------------------------------------------

; Usage: SetClock #02, #30  (2 minutes, 30 seconds)
.macro SetClock minutes, seconds
.scope
    lda minutes
    sta clock_min
    lda seconds
    sta clock_sec
    lda #50             ; PAL
    sta clock_frames
.endscope
.endmacro

.macro UpdateClock
.scope
    ; Check if Clock is already 00:00 (Stop at zero)
    lda clock_min
    ora clock_sec       ; OR checks if both are zero
    beq Done            ; If 0, do nothing

    ; Decrement Frames
    dec clock_frames
    bne Done            ; If frames != 0, we are safe to exit

    ; One Second Passed: Reset Frames (PAL)
    lda #50
    sta clock_frames

    ; Decrement Seconds
    dec clock_sec
    lda clock_sec
    cmp #$FF            ; Did we go below 0? (0 -> -1)
    bne Done            ; If no underflow, we are done

    ; One Minute Passed: Reset Seconds to 59
    lda #59
    sta clock_sec

    ; Decrement Minutes
    dec clock_min
    lda clock_min
    cmp #$FF            ; Did we go below 0?
    bne Done

    ; Hard Stop (If we went -1:-1, force 00:00)
    lda #0
    sta clock_min
    sta clock_sec

Done:
.endscope
.endmacro


