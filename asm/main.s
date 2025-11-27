



; import engine functions
.import famistudio_update
.import famistudio_init
.import famistudio_music_play

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

; flags
.import current_scene
.import frame_ready

; Scenes
.import start_screen_scene
.import demo_scene

; demo
.importzp clock_x
.importzp clock_y
.importzp clock_dirty

;; includes
.include "systemMacro.s"
.include "consts.s"
;;.importzp frame_ready

.import CoinFrame1
.importzp coin_x
.importzp coin_y
.import CoinFrame2
.importzp coin_x2
.importzp coin_y2

; Macros
.include "graphicsMacro.s"
.include "musicMacro.s"

;; Main code segment for the program
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

; Setup initial variables

lda #$60          ; X = 96 (Center-left position)
sta coin_x
lda #$60          ; Y = 96 (Center vertical position)
sta coin_y

lda #$20          ; X = 96 (Center-left position)
sta coin_x2
lda #$20          ; Y = 96 (Center vertical position)
sta coin_y2

lda #50
sta clock_x
sta clock_y

lda #%00000111 
sta clock_dirty

; Setup music
  InitializeSongs

  LDA #00 ; pick the first song 
  ChooseSongFromAccumulator


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

  ;; Scene Select
  lda current_scene
  bne @skipStartScene ; $00 is always start screen
  jsr start_screen_scene
  @skipStartScene:

  cmp #SCENE_GAME
  ;; bne @skipGameScene
  jsr demo_scene
  ;; @skipGameScene:

  ; Draw Sprites 
  ldy #$00

  DrawMetasprite coin_x, coin_y, CoinFrame1
  DrawMetasprite coin_x2, coin_y2, CoinFrame2
  DrawClock

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

  lda #$00
  
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

  jsr famistudio_update ; Updates the music 
  
  rti ; resume code 