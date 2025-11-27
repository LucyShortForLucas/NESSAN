.import background
.import CoinFrame1
.import CoinFrame2
.import palettes


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