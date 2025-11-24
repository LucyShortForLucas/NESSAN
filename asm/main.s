;;
;; This module holds the entry-point, main game loop, and NMI interrupt
;;


;; exports and imports
.export nmi
.export reset

.import background
.import palettes
.import clock_draw_buffer

.importzp frame_ready

.include "demoMacro.s"
.include "inputMacro.s"

; Main code segment for the program
.segment "CODE"

; reset is the Entry-point of the entire project
reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
  stx $4017	; disable APU frame IRQ
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
  lda #$00
  sta $0000, x
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

; enable rendering
  lda #%10000000	; Enable NMI
  sta $2000
  lda #%00011110  ; Enable Background and Sprites
  sta $2001


; Setup initial variables

lda #50
sta clock_x
sta clock_y

lda #%00000111 
sta clock_dirty

; Main loop
main:
  lda frame_ready 
  beq main ; wait until NMI sets frame_ready
  lda #$00
  sta frame_ready

  UpdateTime ; macro

  FetchInput
  MoveClock
  ClockValueButtons

  UpdateClockBufferX
  UpdateClockBufferY
  UpdateClockBufferValue

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

  lda #$00
  sta $2005  ; Set Scroll X to 0
  sta $2005  ; Set Scroll Y to 0
  
@loop:	
  lda clock_draw_buffer, x
  sta $2004
  inx
  cpx #$10
  bne @loop



  inc frame_ready ; signal that frame is ready for main loop

  pla ; pull Y
  tay
  pla ; pull X
  tax
  pla ; pull A
  rti ; resume code
