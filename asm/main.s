; import engine functions
.import famistudio_update
.import famistudio_init
;.import famistudio_music_play (is handled in "initializeScene.s")
 
.import music_data_coinheist ; import song

;;
;; This module holds the entry-point, main game loop, and NMI interrupt
;;

;; exports and imports

; Interrupt adresses
.export nmi
.export reset

; drawing
.import palettes
.import clock_draw_buffer
.import wall_collisions
.import move_player_input
.importzp math_buffer

; flags
.import current_scene
.import frame_ready

; Scenes
.import start_screen_scene
.import initialize_scene_start
.import demo_scene

.import collision_aabb_2x2
.import collision_aabb_2x3
.import collision_aabb_3x3
.import collision_aabb_9x2

; demo
.importzp clock_x
.importzp clock_y
.importzp clock_dirty
.importzp score_red_x
.importzp score_red_y
.importzp score_blue_x
.importzp score_blue_y

; mathbuffer (used by coinlist for now)
.importzp math_buffer

; coin list
.import list_pickup
.import aabb_collision
.import HandleCoinCollection
.import ConvertIndexToPosition

;; includes
.include "systemMacro.s"
.include "consts.s"
.include "inits.s"

.importzp blue_player_x, blue_player_y
.importzp red_player_x, red_player_y

;;.importzp frame_ready

.importzp coin_x
.importzp coin_y
.importzp count_down_x
.importzp count_down_y
.importzp coin_x2
.importzp coin_y2

; Macros
.include "graphicsMacro.s"
.include "musicMacro.s"



.include "playerMacro.s"

.segment "CODE"

; reset is the Entry-point of the entire project
reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
 ; stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx $2000	; disable NMI
  stx $2001 	; disable rendering
  stx $4010 	; disable DMC IRQs

;; first wait for vblank to make sure PPU is ready
vblankwait1:
  bit $2002
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
  bit $2002
  bpl vblankwait2

; load palettes
  lda $2002
  lda #$3f
  sta $2006
  lda #$00
  sta $2006
  ldx #$00
@loop:
  lda palettes, x
  sta $2007
  inx
  cpx #$20
  bne @loop

DrawBackground ; Draw background

; enable rendering
  lda #%10000000	; Enable NMI
  sta $2000
  lda #%00011110  ; Enable Background and Sprites
  sta $2001

InitVariables ; Setup initial variables

lda #$60          ; X = 96 (Center-left position)
sta coin_x
lda #$60          ; Y = 96 (Center vertical position)
sta coin_y

lda #$20          
sta blue_player_x
lda #$20         
sta blue_player_y

lda #$30          
sta red_player_x
lda #$20         
sta red_player_y


lda #$6D          
sta count_down_x
lda #$E3         
sta count_down_y

lda #50
sta clock_x
sta clock_y

lda #$D0
sta score_red_x
lda #$02
sta score_red_y

lda #$20
sta score_blue_x
lda #$02
sta score_blue_y

lda #%00000111 
sta clock_dirty

SetClock #02, #30  ; Start clock at 2:30

; Setup music
InitializeSongs

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
    bne @skipStartScene ; $00 is always start screen
      jsr start_screen_scene
    @skipStartScene:

  cmp #SCENE_GAME
  bne @skipGameScene
  jsr demo_scene
  
  @skipGameScene:

  jmp main ; Loop

; The NMI interrupt is called every frame during V-blank (if enabled)
nmi:
  pha ; push A
  txa 
  pha ; push X
  tya 
  pha ; push Y

  ldx #$00 	; Set SPR-RAM address to 0
  stx $2003 ;; first 8 bytes must be 0 for some reason
  stx $2004
  stx $2004
  stx $2004
  stx $2004
  stx $2004
  stx $2004
  stx $2004
  stx $2004
  
  ; OAM DMA 
  ; This copies all 256 bytes from CPU RAM $0200 to PPU OAM
  lda #$00
  sta $2003   ; Set OAM address to 0
  lda #$02    ; High byte of $0200
  sta $4014   ; Trigger DMA transfer (pauses CPU for 513 cycles)

  ; Scroll Split
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