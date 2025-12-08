;; exports and imports
.export background

.export CoinFrame1
.export CoinFrame2

.export BluePlayerRight1, BluePlayerRight2, BluePlayerLeft1, BluePlayerLeft2
.export BluePlayerDown1, BluePlayerDown2, BluePlayerDown3
.export BluePlayerUp1, BluePlayerUp2, BluePlayerUp3

.export RedPlayerRight1, RedPlayerRight2, RedPlayerLeft1, RedPlayerLeft2
.export RedPlayerDown1, RedPlayerDown2, RedPlayerDown3
.export RedPlayerUp1, RedPlayerUp2, RedPlayerUp3

.export palettes

.segment "RODATA" 
; BACKGROUND DATA 
background:
  ; Map made with nexxt
	.byte $01,$02,$07,$0b,$0b,$0b,$0b,$08,$01,$02,$01,$02,$01,$02,$01,$02
	.byte $01,$02,$01,$02,$01,$02,$01,$02,$07,$0b,$0b,$0b,$0b,$08,$01,$02
	.byte $03,$04,$09,$0c,$0c,$0c,$0c,$0a,$03,$04,$03,$04,$03,$04,$03,$04
	.byte $03,$04,$03,$04,$03,$04,$03,$04,$09,$0c,$0c,$0c,$0c,$0a,$03,$04
	.byte $02,$05,$05,$05,$1a,$1b,$05,$05,$05,$05,$05,$05,$1f,$05,$05,$05
	.byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$1a,$1b,$05,$05,$01
	.byte $04,$05,$05,$05,$1c,$1d,$1a,$1b,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $05,$05,$05,$05,$05,$05,$05,$05,$1e,$05,$05,$1c,$1d,$05,$05,$03
	.byte $02,$05,$1e,$05,$05,$05,$1c,$1d,$05,$05,$05,$05,$05,$1a,$1b,$05
	.byte $05,$16,$12,$12,$12,$12,$12,$12,$12,$12,$12,$17,$1a,$1b,$05,$01
	.byte $04,$05,$16,$12,$12,$12,$12,$12,$12,$12,$12,$12,$17,$1c,$1d,$05
	.byte $1f,$14,$06,$06,$06,$06,$06,$06,$06,$06,$06,$15,$1c,$1d,$05,$03
	.byte $02,$05,$15,$06,$06,$06,$06,$06,$06,$06,$06,$06,$14,$05,$1a,$1b
	.byte $05,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$05,$05,$05,$01
	.byte $04,$05,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00,$14,$05,$1c,$1d
	.byte $05,$18,$13,$13,$13,$13,$13,$13,$13,$13,$13,$19,$1a,$1b,$05,$03
	.byte $02,$05,$18,$13,$13,$13,$13,$13,$13,$13,$13,$13,$19,$05,$05,$05
	.byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$1c,$1d,$05,$01
	.byte $04,$05,$05,$16,$12,$12,$17,$05,$05,$1a,$1b,$05,$05,$05,$05,$05
	.byte $05,$05,$05,$01,$0d,$02,$05,$05,$05,$05,$05,$05,$05,$05,$05,$03
	.byte $02,$05,$05,$14,$06,$06,$15,$05,$05,$1c,$1d,$05,$05,$05,$05,$05
	.byte $05,$05,$05,$0f,$11,$10,$1f,$05,$05,$16,$12,$12,$17,$05,$05,$01
	.byte $04,$05,$05,$14,$00,$00,$15,$05,$01,$02,$01,$0d,$02,$1f,$05,$05
	.byte $05,$05,$05,$03,$0e,$04,$1a,$1b,$05,$14,$06,$06,$15,$05,$05,$03
	.byte $02,$05,$05,$14,$00,$00,$15,$05,$03,$04,$0f,$11,$10,$05,$05,$05
	.byte $05,$05,$1a,$1b,$01,$02,$1c,$1d,$05,$14,$00,$00,$15,$05,$05,$01
	.byte $04,$1a,$1b,$18,$13,$13,$19,$05,$1a,$1b,$03,$0e,$04,$01,$02,$05
	.byte $05,$05,$1c,$1d,$03,$04,$05,$05,$05,$14,$00,$00,$15,$05,$1e,$03
	.byte $02,$1c,$1d,$05,$05,$05,$05,$05,$1c,$1d,$14,$06,$06,$03,$04,$05
	.byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$18,$13,$13,$19,$1a,$1b,$01
	.byte $04,$05,$16,$12,$12,$17,$05,$05,$05,$05,$14,$00,$00,$15,$05,$05
	.byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$1c,$1d,$03
	.byte $02,$05,$14,$06,$06,$15,$05,$05,$05,$05,$18,$13,$13,$19,$05,$05
	.byte $05,$05,$01,$0d,$02,$05,$05,$05,$16,$12,$12,$17,$05,$05,$05,$01
	.byte $04,$05,$14,$00,$00,$15,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $05,$05,$0f,$11,$10,$05,$05,$05,$14,$06,$06,$15,$05,$05,$05,$03
	.byte $02,$05,$14,$00,$00,$15,$05,$05,$05,$01,$02,$05,$05,$05,$05,$05
	.byte $01,$02,$03,$0e,$04,$05,$05,$1f,$14,$00,$00,$15,$05,$05,$05,$01
	.byte $04,$05,$18,$13,$13,$19,$05,$05,$05,$03,$04,$05,$05,$05,$05,$05
	.byte $03,$04,$1a,$1b,$05,$05,$05,$05,$14,$00,$00,$15,$05,$05,$05,$03
	.byte $02,$05,$05,$05,$05,$05,$1e,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $05,$05,$1c,$1d,$05,$05,$05,$05,$18,$13,$13,$19,$05,$05,$05,$01
	.byte $04,$1a,$1b,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05
	.byte $05,$16,$12,$12,$12,$12,$12,$12,$12,$12,$12,$17,$05,$05,$05,$03
	.byte $02,$1c,$1d,$16,$12,$12,$12,$12,$12,$12,$12,$12,$12,$17,$05,$05
	.byte $05,$14,$06,$06,$06,$06,$06,$06,$06,$06,$06,$15,$1f,$05,$05,$01
	.byte $04,$05,$05,$14,$06,$06,$06,$06,$06,$06,$06,$06,$06,$15,$1a,$1b
	.byte $05,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$05,$05,$05,$03
	.byte $02,$05,$05,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$15,$1c,$1d
	.byte $05,$18,$13,$13,$13,$13,$13,$13,$13,$13,$13,$19,$1a,$1b,$05,$01
	.byte $04,$1e,$05,$18,$13,$13,$13,$13,$13,$13,$13,$13,$13,$19,$05,$05
	.byte $05,$05,$05,$1a,$1b,$05,$05,$05,$05,$05,$05,$05,$1c,$1d,$05,$03
	.byte $02,$05,$1a,$1b,$05,$05,$05,$05,$05,$05,$05,$05,$05,$1a,$1b,$05
	.byte $05,$05,$05,$1c,$1d,$1a,$1b,$05,$05,$05,$05,$05,$05,$05,$05,$01
	.byte $04,$05,$1c,$1d,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$1e
	.byte $05,$05,$05,$05,$05,$1c,$1d,$05,$05,$05,$05,$05,$05,$05,$05,$03
	.byte $01,$02,$07,$08,$01,$02,$01,$02,$01,$02,$01,$02,$07,$0b,$0b,$0b
	.byte $0b,$0b,$0b,$08,$01,$02,$01,$02,$01,$02,$01,$02,$07,$08,$01,$02
	.byte $03,$04,$09,$0a,$03,$04,$03,$04,$03,$04,$03,$04,$09,$0c,$0c,$0c
	.byte $0c,$0c,$0c,$0a,$03,$04,$03,$04,$03,$04,$03,$04,$09,$0a,$03,$04
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
; SPRITE DATA
; Coin Animation Frames
CoinFrame1:
    ; Y-off, Tile, Attr, X-off
    .byte $00, $20, $01, $00  ; Top Left
    .byte $00, $21, $01, $08  ; Top Right
    .byte $08, $22, $01, $00  ; Bottom Left
    .byte $08, $23, $01, $08  ; Bottom Right

CoinFrame2:
    ; Y-off, Tile, Attr, X-off
    .byte $00, $24, $01, $00  ; Top Left
    .byte $00, $25, $01, $08  ; Top Right
    .byte $08, $26, $01, $00  ; Bottom Left
    .byte $08, $27, $01, $08  ; Bottom Right

;  Blue Player Sprites
BluePlayerRight1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $60, $02, $00  ; Top Left
      .byte $00, $61, $02, $08  ; Top Right
      .byte $08, $62, $02, $00  ; Bottom Left
      .byte $08, $63, $02, $08  ; Bottom Right

BluePlayerRight2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $64, $02, $00  ; Top Left
      .byte $00, $65, $02, $08  ; Top Right
      .byte $08, $66, $02, $00  ; Bottom Left
      .byte $08, $67, $02, $08  ; Bottom Right

BluePlayerLeft1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $80, $02, $00  ; Top Left
      .byte $00, $81, $02, $08  ; Top Right
      .byte $08, $82, $02, $00  ; Bottom Left
      .byte $08, $83, $02, $08  ; Bottom Right

BluePlayerLeft2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $84, $02, $00  ; Top Left
      .byte $00, $85, $02, $08  ; Top Right
      .byte $08, $86, $02, $00  ; Bottom Left
      .byte $08, $87, $02, $08  ; Bottom Right

BluePlayerDown1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $74, $02, $00  ; Top Left
      .byte $00, $75, $02, $08  ; Top Right
      .byte $08, $76, $02, $00  ; Bottom Left
      .byte $08, $77, $02, $08  ; Bottom Right

BluePlayerDown2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $78, $02, $00  ; Top Left
      .byte $00, $79, $02, $08  ; Top Right
      .byte $08, $7A, $02, $00  ; Bottom Left
      .byte $08, $7B, $02, $08  ; Bottom Right

BluePlayerDown3:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $7C, $02, $00  ; Top Left
      .byte $00, $7D, $02, $08  ; Top Right
      .byte $08, $7E, $02, $00  ; Bottom Left
      .byte $08, $7F, $02, $08  ; Bottom Right

BluePlayerUp1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $68, $02, $00  ; Top Left
      .byte $00, $69, $02, $08  ; Top Right
      .byte $08, $6A, $02, $00  ; Bottom Left
      .byte $08, $6B, $02, $08  ; Bottom Right

BluePlayerUp2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $6C, $02, $00  ; Top Left
      .byte $00, $6D, $02, $08  ; Top Right
      .byte $08, $6E, $02, $00  ; Bottom Left
      .byte $08, $6F, $02, $08  ; Bottom Right

BluePlayerUp3:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $70, $02, $00  ; Top Left
      .byte $00, $71, $02, $08  ; Top Right
      .byte $08, $72, $02, $00  ; Bottom Left
      .byte $08, $73, $02, $08  ; Bottom Right

;  Red Player Sprites
RedPlayerRight1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $60, $03, $00  ; Top Left
      .byte $00, $61, $03, $08  ; Top Right
      .byte $08, $62, $03, $00  ; Bottom Left
      .byte $08, $63, $03, $08  ; Bottom Right

RedPlayerRight2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $64, $03, $00  ; Top Left
      .byte $00, $65, $03, $08  ; Top Right
      .byte $08, $66, $03, $00  ; Bottom Left
      .byte $08, $67, $03, $08  ; Bottom Right

RedPlayerLeft1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $80, $03, $00  ; Top Left
      .byte $00, $81, $03, $08  ; Top Right
      .byte $08, $82, $03, $00  ; Bottom Left
      .byte $08, $83, $03, $08  ; Bottom Right

RedPlayerLeft2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $84, $03, $00  ; Top Left
      .byte $00, $85, $03, $08  ; Top Right
      .byte $08, $86, $03, $00  ; Bottom Left
      .byte $08, $87, $03, $08  ; Bottom Right

RedPlayerDown1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $74, $03, $00  ; Top Left
      .byte $00, $75, $03, $08  ; Top Right
      .byte $08, $76, $03, $00  ; Bottom Left
      .byte $08, $77, $03, $08  ; Bottom Right

RedPlayerDown2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $78, $03, $00  ; Top Left
      .byte $00, $79, $03, $08  ; Top Right
      .byte $08, $7A, $03, $00  ; Bottom Left
      .byte $08, $7B, $03, $08  ; Bottom Right

RedPlayerDown3:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $7C, $03, $00  ; Top Left
      .byte $00, $7D, $03, $08  ; Top Right
      .byte $08, $7E, $03, $00  ; Bottom Left
      .byte $08, $7F, $03, $08  ; Bottom Right

RedPlayerUp1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $68, $03, $00  ; Top Left
      .byte $00, $69, $03, $08  ; Top Right
      .byte $08, $6A, $03, $00  ; Bottom Left
      .byte $08, $6B, $03, $08  ; Bottom Right

RedPlayerUp2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $6C, $03, $00  ; Top Left
      .byte $00, $6D, $03, $08  ; Top Right
      .byte $08, $6E, $03, $00  ; Bottom Left
      .byte $08, $6F, $03, $08  ; Bottom Right

RedPlayerUp3:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $70, $03, $00  ; Top Left
      .byte $00, $71, $03, $08  ; Top Right
      .byte $08, $72, $03, $00  ; Bottom Left
      .byte $08, $73, $03, $08  ; Bottom Right

palettes:
  ; Background Palette
  .byte $0f, $00, $10, $30
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  ; Sprite Palette
  .byte $0f, $00, $10, $30
  .byte $0f, $28, $38, $30
  .byte $0f, $11, $21, $30
  .byte $0f, $16, $26, $30

; Character memory
.segment "CHARS"
.incbin "assets.chr"

