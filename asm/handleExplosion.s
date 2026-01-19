;; IMPORTS AND EXPORTS
.include "consts.s"

.export handle_explosion       

.import explosion_buffer      
.importzp explosion_state     
.importzp bomb_ppu_addr       

.importzp bomb_x, bomb_y 

; ------------------------------------------------------------------------

.segment "CODE"

handle_explosion:        
.scope handle_explosion  
    ; Check current state
    lda explosion_state
    cmp #1              
    beq @state_draw     ; State 1 = Draw Flash
    
    cmp #2              
    bne @exit_func      ; Not 2, Then do nothing.
    jmp @state_restore  ; State 2 = Restore Background (Long jump needed)

@exit_func:
    rts

; Draw Flash, Calculates screen position, saves BG tiles to buffer, draws white square.
@state_draw:
    ; Calculate PPU address
    ; We determine where the bomb is on the screen grid.

    ; Calculate Y offset (Row)
    lda bomb_y          
    sta bomb_ppu_addr   ; Store temporarily

    ; High Byte: Base Address ($20) + (Y / 8)
    lda bomb_ppu_addr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr                 ; Shift down to get high bits
    clc
    adc #NAMETABLE_HI
    sta bomb_ppu_addr+1

    ; Low Byte: (Y % 8) * 32
    lda bomb_ppu_addr
    and #%11111000      ; Mask to align with rows
    asl
    asl                 ; Multiply to get row offset
    sta bomb_ppu_addr

    ; Calculate X offset (Column)
    lda bomb_x          
    lsr
    lsr
    lsr                 ; Divide by 8 to get tile column
    clc
    adc bomb_ppu_addr   ; Add to low byte
    sta bomb_ppu_addr
    
    bcc @draw_pixels    ; Handle carry if we crossed a page boundary
    inc bomb_ppu_addr+1

@draw_pixels:
    ; Save background, Read the 3x3 area of tiles and store them in RAM.
    ; Row 1 (Top)
    jsr @set_ppu_addr_row1
    lda PPU_DATA            ; Dummy read (hardware requirement)
    lda PPU_DATA            ; Read Tile 1
    sta explosion_buffer+0
    lda PPU_DATA            ; Read Tile 2
    sta explosion_buffer+1
    lda PPU_DATA            ; Read Tile 3
    sta explosion_buffer+2

    ; Row 2 (Middle)
    jsr @set_ppu_addr_row2
    lda PPU_DATA            ; Dummy read
    lda PPU_DATA
    sta explosion_buffer+3
    lda PPU_DATA
    sta explosion_buffer+4
    lda PPU_DATA
    sta explosion_buffer+5

    ; Row 3 (Bottom)
    jsr @set_ppu_addr_row3
    lda PPU_DATA            ; Dummy read
    lda PPU_DATA
    sta explosion_buffer+6
    lda PPU_DATA
    sta explosion_buffer+7
    lda PPU_DATA
    sta explosion_buffer+8

    ; Draw flash, overwrite the area with white tiles.
    ; Row 1
    jsr @set_ppu_addr_row1
    lda #LASER_TILE_ID
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    ; Row 2
    jsr @set_ppu_addr_row2
    lda #LASER_TILE_ID
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    ; Row 3
    jsr @set_ppu_addr_row3
    lda #LASER_TILE_ID
    sta PPU_DATA
    sta PPU_DATA
    sta PPU_DATA

    ; Done. Reset state to 0 (Wait for timer).
    lda #0
    sta explosion_state
    rts


; Restore Background, writes the saved tiles back to the screen using the saved address.
@state_restore:
    ; Row 1
    jsr @set_ppu_addr_row1
    lda explosion_buffer+0
    sta PPU_DATA
    lda explosion_buffer+1
    sta PPU_DATA
    lda explosion_buffer+2
    sta PPU_DATA

    ; Row 2
    jsr @set_ppu_addr_row2
    lda explosion_buffer+3
    sta PPU_DATA
    lda explosion_buffer+4
    sta PPU_DATA
    lda explosion_buffer+5
    sta PPU_DATA

    ; Row 3
    jsr @set_ppu_addr_row3
    lda explosion_buffer+6
    sta PPU_DATA
    lda explosion_buffer+7
    sta PPU_DATA
    lda explosion_buffer+8
    sta PPU_DATA

    ; Done. Reset state to 0 (Explosion finished).
    lda #0
    sta explosion_state
    rts

; Helpers, Sets the PPU address for each row of the 3x3 block.
@set_ppu_addr_row1:
    lda PPU_STATUS
    lda bomb_ppu_addr+1
    sta PPU_ADDR
    lda bomb_ppu_addr
    sta PPU_ADDR
    rts

@set_ppu_addr_row2:
    lda bomb_ppu_addr
    clc
    adc #32             ; Add 32 bytes (1 row down)
    tay
    lda bomb_ppu_addr+1
    adc #0
    tax
    lda PPU_STATUS
    stx PPU_ADDR
    sty PPU_ADDR
    rts

@set_ppu_addr_row3:
    lda bomb_ppu_addr
    clc
    adc #64             ; Add 64 bytes (2 rows down)
    tay
    lda bomb_ppu_addr+1
    adc #0
    tax
    lda PPU_STATUS
    stx PPU_ADDR
    sty PPU_ADDR
    rts

.endscope