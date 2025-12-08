



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

; mathbuffer (used by coinlist for now)
.importzp math_buffer

; coin list
.import list_pickup
.import aabb_collision
.import HandleCoinCollection
.import ConvertIndexToPosition

; import player drawing
.import draw_enemy

; import enemy drawing
.import draw_player

; temp player variables
.importzp player_x, player_y, enemy_x, enemy_y

;; includes
.include "systemMacro.s"
.include "consts.s"

.include "musicMacro.s"

.include "coinListMacro.s"



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

; enable rendering
  lda #%10000000	; Enable NMI
  sta $2000
  lda #%00010000	; Enable Sprites
  sta $2001

; Setup initial variables

lda #50
sta clock_x
sta clock_y

lda #%00000111 
sta clock_dirty

; setup player
lda #50
sta player_x
lda #50
sta player_y

; setup enemy
lda #100
sta enemy_x
lda #80
sta enemy_y

lda #3
sta list_pickup

lda #50
sta list_pickup+1
lda #100
sta list_pickup+2
lda #1
sta list_pickup+3

lda #180
sta list_pickup+4
lda #10
sta list_pickup+5
lda #2
sta list_pickup+6

lda #200
sta list_pickup+7
lda #200
sta list_pickup+8
lda #3
sta list_pickup+9

; Setup music
  InitializeSongs

  LDA #00 ; pick the first song 
  ChooseSongFromAccumulator


; Main loop
main:
  lda frame_ready 
  beq main ; wait until NMI sets frame_ready
  lda #$00
  sta frame_ready

  UpdateTime ; macro
  FetchInput

  ;; Scene Select
  lda current_scene
  bne @skipStartScene ; $00 is always start screen
  jsr start_screen_scene
  @skipStartScene:

  cmp #SCENE_GAME
  bne @skipGameScene
  jsr demo_scene

  CheckForCoinCollision ; check if we hit a coin!
  bcc @skipGameScene ; branch if not...
  jsr HandleCoinCollection ; We're touching a coin! handle it!
  
  @skipGameScene:

  jmp main ; loop forever


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
@loop:	 	
  lda clock_draw_buffer, x
  sta $2004
  inx
  cpx #$10
  bne @loop


  ; draw player
  jsr draw_player
  ; draw enemy
  jsr draw_enemy
  
  DrawCoins

  ldx #$00
  stx $2004
  ldx #$00
  stx $2004
  ldx #$00
  stx $2004
  ldx #$00
  stx $2004
  
  inc frame_ready ; signal that frame is ready for main loop

  pla ; pull Y
  tay
  pla ; pull X
  tax
  pla ; pull A

  jsr famistudio_update ; Updates the music 
  
  rti ; resume code 