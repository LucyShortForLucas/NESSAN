;;
;; This module holds the entry-point, main game loop, and NMI interrupt
;;

;; IMPORTS AND EXPORTS
.export nmi
.export reset

.include "consts.s"
.include "systemMacro.s"
.include "musicMacro.s"
.include "playerMacro.s"
.include "inits.s"

.import famistudio_update
.import music_data_coinheist
.import sounds

.import current_scene
.import frame_ready
.importzp math_buffer       ; General purpose math scratchpad

.import start_screen_scene, initialize_scene_start
.import main_scene
.import end_screen_scene

.import palettes
.import gameScreenMap
.import clock_draw_buffer

.import handle_laser, laser_buffer
.import handle_explosion, explosion_buffer

.import wall_collisions
.import aabb_collision
.import move_player_input

.import collision_aabb_2x2
.import collision_aabb_2x3
.import collision_aabb_3x3
.import collision_aabb_9x2

.import list_pickup
.import handle_coin_collection

.importzp blue_player_x, blue_player_y
.importzp red_player_x, red_player_y

.importzp coin_x, coin_y
.importzp coin_x2, coin_y2
.importzp count_down_x, count_down_y

.importzp clock_x, clock_y
.importzp score_red_x, score_red_y
.importzp score_blue_x, score_blue_y
.importzp ability_red_icon_x, ability_red_icon_y
.importzp ability_blue_icon_x, ability_blue_icon_y

; ------------------------------------------------------------------------

.segment "CODE"

reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
 ; stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx PPU_CTRL	; disable NMI
  stx PPU_MASK 	; disable rendering
  stx $4010 	; disable DMC IRQs

;; first wait for vblank to make sure PPU is ready
vblankwait1:
  bit PPU_STATUS
  bpl vblankwait1

clear_memory:
  lda #$00 ; make accumulator empty
  sta $0000, x ; make each memory empty with accumulator
  sta $0100, x
  sta $0200, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  inx
  bne clear_memory

;; second wait for vblank, PPU is ready after this
vblankwait2:
  bit PPU_STATUS
  bpl vblankwait2

; load palettes
  lda PPU_STATUS
  lda #$3f
  sta PPU_ADDR
  lda #$00
  sta PPU_ADDR
  ldx #$00
@loop:
  lda palettes, x
  sta PPU_DATA
  inx
  cpx #$20
  bne @loop


; enable rendering
  lda #%10000000	; Enable NMI
  sta PPU_CTRL
  lda #PPU_MASK_ENABLE_ALL  ; Enable Background and Sprites
  sta PPU_MASK

InitVariables ; Setup initial variables
InitializeSongs ; Setup music

; Setup Start screen
jsr initialize_scene_start

; Main loop
main:
  lda frame_ready 
  beq main        ; Wait for NMI
    lda #$00
    sta frame_ready

    ; Clear Shadow OAM 
    ; We move all sprites off-screen (Y = $FF) by default
    ldx #$00
    lda #$FF
  @clear_oam:
      sta $0200, x ; set Y coordinate to FF (offscreen)
      inx 
      inx 
      inx 
      inx          ; Skip to next sprite (4 bytes per sprite)
  bne @clear_oam

    ; Update Game Logic
    UpdateTime 
    FetchInput

  jsr famistudio_update ; Updates the music 
    ;; Scene Select
    lda current_scene
    bne @skip_start_scene ; $00 is always start screen
      jsr start_screen_scene
    @skip_start_scene:

  cmp #SCENE_GAME
  bne @skip_game_scene
  jsr main_scene
  @skip_game_scene:

   cmp #SCENE_ENDSCREEN
  bne @skip_end_scene
  jsr end_screen_scene
  @skip_end_scene:

  jmp main ; Loop

; The NMI interrupt is called every frame during V-blank (if enabled)
nmi:
    pha ; push A
    txa 
    pha ; push X
    tya 
    pha ; push Y

    ; OAM Prepare
    ldx #$00  ; Set SPR-RAM address to 0
    stx $2003 

    ; OAM DMA
    lda #$00
    sta $2003   ; Set OAM address to 0
    lda #$02    ; High byte of $0200
    sta $4014   ; Trigger DMA transfer

    jsr handle_laser ; Calling the laser handler  
    jsr handle_explosion ; Calling the explosion handler

    ; Scroll
    lda #$00
    sta $2005   ; Set Scroll X
    sta $2005   ; Set Scroll Y

    inc frame_ready ; signal that frame is ready for main loop

    pla ; pull Y
    tay
    pla ; pull X
    tax
    pla ; pull A

    rti ; resume code
  

