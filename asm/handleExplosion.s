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
.scope
    ; Check what the bomb needs to do
    lda explosion_state
    cmp #EXPLOSION_STATE_DRAW
    beq @state_draw      ; Go draw the flash
    
    cmp #EXPLOSION_STATE_RESTORE
    bne @exit_func       ; If not restore, we are idle/done
    jmp @state_restore   ; Go restore background

@exit_func:
    rts

; Runs when bomb explodes
@state_draw:
    
    ; Calculate Address

    ; High Byte: Divide Y by 64 (Pages)
    lda bomb_y
    sta bomb_ppu_addr
    
    lda bomb_ppu_addr
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr
    clc
    adc #NAMETABLE_HI
    sta bomb_ppu_addr+1

    ; Low Byte: Snap Y to row, Multiply by 32
    lda bomb_ppu_addr
    and #%11111000
    asl
    asl
    sta bomb_ppu_addr

    ; Add X offset (Pixels -> Tiles)
    lda bomb_x
    lsr
    lsr
    lsr
    clc
    adc bomb_ppu_addr
    sta bomb_ppu_addr

    ; Handle page crossing
    bcc @draw_pixels
    inc bomb_ppu_addr+1

@draw_pixels:
    ; Save Background Tiles
    
    ; Row 1 (Top)
    jsr @set_ppu_addr_row1
    lda PPU_DATA        ; Dummy read
    lda PPU_DATA
    sta explosion_buffer+0
    lda PPU_DATA
    sta explosion_buffer+1
    lda PPU_DATA
    sta explosion_buffer+2

    ; Row 2 (Middle)
    jsr @set_ppu_addr_row2
    lda PPU_DATA        ; Dummy read
    lda PPU_DATA
    sta explosion_buffer+3
    lda PPU_DATA
    sta explosion_buffer+4
    lda PPU_DATA
    sta explosion_buffer+5

    ; Row 3 (Bottom)
    jsr @set_ppu_addr_row3
    lda PPU_DATA        ; Dummy read
    lda PPU_DATA
    sta explosion_buffer+6
    lda PPU_DATA
    sta explosion_buffer+7
    lda PPU_DATA
    sta explosion_buffer+8

    ; Draw White Flash

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

    ; Done, wait for timer
    lda #EXPLOSION_STATE_IDLE
    sta explosion_state
    rts


; Puts the original tiles back on screen
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

    ; Done.
    lda #EXPLOSION_STATE_IDLE
    sta explosion_state
    rts


; Helpers 

; Top row
@set_ppu_addr_row1:
    lda PPU_STATUS
    lda bomb_ppu_addr+1
    sta PPU_ADDR
    lda bomb_ppu_addr
    sta PPU_ADDR
    rts

; Middle row
@set_ppu_addr_row2:
    lda bomb_ppu_addr
    clc
    adc #EXPLOSION_SCREEN_WIDTH   
    tay
    lda bomb_ppu_addr+1
    adc #0
    tax
    lda PPU_STATUS
    stx PPU_ADDR
    sty PPU_ADDR
    rts

; Bottom row
@set_ppu_addr_row3:
    lda bomb_ppu_addr
    clc
    adc #EXPLOSIONTWO_ROWS_OFFSET 
    tay
    lda bomb_ppu_addr+1
    adc #0
    tax
    lda PPU_STATUS
    stx PPU_ADDR
    sty PPU_ADDR
    rts

.endscope