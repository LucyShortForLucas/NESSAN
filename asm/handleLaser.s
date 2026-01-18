;; IMPORTS AND EXPORTS
.include "consts.s" 
.include "systemMacro.s" 

.export HandleLaser           

.import laser_buffer          
.importzp laser_state         
.importzp laser_length        
.importzp laser_dir_save      

.importzp laser_x_tile        
.importzp laser_y_tile        

.importzp draw_x, draw_y      
.importzp ppu_addr_temp       

; ------------------------------------------------------------------------

.segment "CODE"

.proc HandleLaser
    ; check if we need to draw or restore the laser
    lda laser_state
    bne @start_calc
    rts

@start_calc:
    ; copy player coordinates to temp variables for math
    lda laser_x_tile
    sta draw_x
    lda laser_y_tile
    sta draw_y

    ; check which direction the player shot
    lda laser_dir_save
    
    cmp #DIR_RIGHT
    beq @setup_right
    
    cmp #DIR_LEFT
    beq @setup_left
    
    cmp #DIR_DOWN
    beq @setup_down
    
    cmp #DIR_UP
    beq @setup_up
    
    rts 

@setup_right:
    ; start offset tiles to the right to avoid overlapping the player
    lda draw_x
    clc
    adc #LASER_OFFSET              
    sta draw_x

    ; calculate distance to the right edge of the screen
    lda #SCREEN_LIMIT_R
    sec
    sbc draw_x
    sta laser_length
    
    ; set ppu to draw horizontally
    lda #PPU_INC_1       
    sta PPU_CTRL
    jmp @validate_length

@setup_left:
    ; we start at the left wall and draw towards the player
    lda #SCREEN_LIMIT_L
    sta draw_x
    
    ; calculate distance from wall to player
    lda laser_x_tile
    sec
    sbc #SCREEN_LIMIT_L
    sta laser_length
    
    ; set ppu to draw horizontally
    lda #PPU_INC_1       
    sta PPU_CTRL
    jmp @validate_length

@setup_down:
    ; start offset tiles down to avoid the player sprite
    lda draw_y
    clc
    adc #LASER_OFFSET
    sta draw_y

    ; calculate distance to the bottom of the screen
    lda #SCREEN_LIMIT_B
    sec
    sbc draw_y
    sta laser_length
    
    ; set ppu to draw vertically
    lda #PPU_INC_32       
    sta PPU_CTRL
    jmp @validate_length

@setup_up:
    ; we start at the ceiling and draw down towards the player
    lda #SCREEN_LIMIT_T
    sta draw_y
    
    ; calculate distance from ceiling to player
    lda laser_y_tile
    sec
    sbc #SCREEN_LIMIT_T
    sta laser_length
    
    ; set ppu to draw vertically
    lda #PPU_INC_32       
    sta PPU_CTRL
    jmp @validate_length

@validate_length:
    ; make sure the length is a positive number
    lda laser_length
    beq @exit_func       
    bpl @calc_address    
@exit_func:
    rts

@calc_address:
    ; calculate the video memory address from x and y
    ; multiply y by 32 to get the row offset
    lda draw_y
    asl
    asl 
    asl 
    asl 
    asl                  
    sta ppu_addr_temp    
    lda draw_y
    lsr
    lsr 
    lsr                  
    sta ppu_addr_temp+1  

    ; add x to get the final address
    lda ppu_addr_temp
    clc
    adc draw_x
    sta ppu_addr_temp
    lda ppu_addr_temp+1
    adc #0
    sta ppu_addr_temp+1
    
    ; decide if we are saving or restoring
    lda laser_state
    cmp #LASER_STATE_DRAW
    beq @state_draw
    jmp @state_restore

@state_draw:
    ; first we save the background tiles
    ; set the ppu address
    lda PPU_STATUS            
    lda ppu_addr_temp+1
    clc
    adc #NAMETABLE_HI        ; Add Base Nametable Address ($20)
    sta PPU_ADDR
    lda ppu_addr_temp
    sta PPU_ADDR
    
    ; dummy read is required by hardware
    lda PPU_DATA 
    
    ldx laser_length     
    ldy #0
@snapshot_loop:
    ; read tiles from screen and store them in ram
    lda PPU_DATA            
    sta laser_buffer, y  
    iny
    dex
    bne @snapshot_loop
    
    ; now overwrite the screen with white tiles
    ; reset the ppu address
    lda PPU_STATUS
    lda ppu_addr_temp+1
    clc
    adc #NAMETABLE_HI
    sta PPU_ADDR
    lda ppu_addr_temp
    sta PPU_ADDR
    
    ldx laser_length
@draw_loop:
    lda #LASER_TILE_ID             
    sta PPU_DATA            
    dex
    bne @draw_loop
    
    ; reset state to 0 when done
    lda #0
    sta laser_state
    jmp @reset_ppu

@state_restore:
    ; restore the saved background tiles
    ; set the ppu address
    lda PPU_STATUS
    lda ppu_addr_temp+1
    clc
    adc #NAMETABLE_HI
    sta PPU_ADDR
    lda ppu_addr_temp
    sta PPU_ADDR
    
    ldx laser_length
    ldy #0
@restore_loop:
    ; write stored tiles back to the screen
    lda laser_buffer, y  
    sta PPU_DATA            
    iny
    dex
    bne @restore_loop
    
    ; reset state to 0 when done
    lda #0
    sta laser_state

@reset_ppu:
    ; reset ppu to normal horizontal mode
    lda #PPU_INC_1
    sta PPU_CTRL
    rts
.endproc