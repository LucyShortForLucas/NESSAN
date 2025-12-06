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
  ; Top Border (Rows 0-1) 
  .byte $01, $02
  .byte $07, $0B, $0B, $0B, $0B, $08
  .repeat 8
    .byte $01, $02
  .endrepeat
  .byte $07, $0B, $0B, $0B, $0B, $08
  .byte $01, $02

  .byte $03, $04
  .byte $09, $0C, $0C, $0C, $0C, $0A
  .repeat 8
    .byte $03, $04
  .endrepeat
  .byte $09, $0C, $0C, $0C, $0C, $0A
  .byte $03, $04

  ; Row 2 
  .byte $02
  .repeat 30
    .byte $05
  .endrepeat
  .byte $01

  ; Row 3 
  .byte $04
  .repeat 30
    .byte $05
  .endrepeat
  .byte $03

  ; Row 4 
  .byte $02
  .repeat 30
    .byte $05
  .endrepeat
  .byte $01

  ; Row 5
  .byte $04     
  .byte $05, $16    
  .repeat 9           
    .byte $12
  .endrepeat
  .byte $17
  .repeat 5           
    .byte $05
  .endrepeat
  .repeat 9           
    .byte $06
  .endrepeat
  .repeat 4            
    .byte $05
  .endrepeat
  .byte $03             

  ; Row 6
  .byte $02            
  .byte $05, $14
  .repeat 9          
    .byte $06
  .endrepeat
  .byte $15
  .repeat 5             
    .byte $05
  .endrepeat
  .repeat 9             
    .byte $00
  .endrepeat
  .repeat 4             
    .byte $05
  .endrepeat
  .byte $01             

  ; Row 7
  .byte $04
  .byte $05, $14
  .repeat 9           
    .byte $00
  .endrepeat
  .byte $15
  .repeat 18             
    .byte $05
  .endrepeat
  .byte $01

  ; Row 8
  .byte $02
  .byte $05, $18
  .repeat 9
     .byte $13
  .endrepeat
  .byte $19
  .repeat 18
     .byte $05
  .endrepeat
  .byte $01

  ; Row 9
  .byte $04
  .byte $05, 05, $16, $12, $12, $17
  .repeat 12
     .byte $05
  .endrepeat
  .byte $01, $0D, $02
  .repeat 9
     .byte $05
  .endrepeat
  .byte $03

  ; Row 10
  .byte $02
  .byte $05, $05, $14, $06, $06, $15
  .repeat 12
     .byte $05
  .endrepeat
  .byte $0F, $11 ,$10
  .repeat 9
     .byte $05
  .endrepeat
  .byte $01

  ; Row 11
  .byte $04 ; Left Border
  .byte $05, $05, $14, $00, $00, $15, $05
  .byte $01, $02 ; Top Part Box
  .byte $01, $0D, $02 ; Top Part Box
  .repeat 6
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $03, $0E, $04 ; Bottom Part Box
  .repeat 4
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $06, $06 ; Two Void Tiles
  .repeat 3
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $03 ; Right Border

  ; Row 12
  .byte $02 ; Left Border
  .byte $05, $05, $14, $00, $00, $15, $05
  .byte $03, $04 ; Bottom Part Box
  .byte $0F, $11, $10 ; Middle Part Box 
  .repeat 7
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $01, $02 ; Top Part Box
  .repeat 4
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $00, $00 ; Void Tiles
  .repeat 3
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $01 ; Right Border

  ; Row 13
  .byte $04
  .byte $05, 05, $18, $13, $13, $19
  .repeat 3
     .byte $05
  .endrepeat
  .byte $03, $0E, $04, $01, $02
  .repeat 5
     .byte $05
  .endrepeat
  .byte $03, $04
  .repeat 4
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 3
     .byte $05
  .endrepeat
  .byte $03

  ; Row 14
  .byte $02
  .repeat 9
     .byte $05
  .endrepeat
  .byte $14
  .byte $06, $06, $03, $04
  .repeat 16
     .byte $05
  .endrepeat
  .byte $01

  ; Row 15
  .byte $04
  .repeat 9
     .byte $05
  .endrepeat
  .byte $14, $00, $00, $15
  .repeat 17
     .byte $05
  .endrepeat
  .byte $03

  ; Row 16
  .byte $02
  .repeat 2
     .byte $05
  .endrepeat
  .byte $06, $06
  .repeat 5
     .byte $05
  .endrepeat
  .byte $18, $13, $13 ,$19
  .repeat 4
     .byte $05
  .endrepeat
  .byte $01, $0D, $02
  .repeat 10
     .byte $05
  .endrepeat
  .byte $01

  ; Row 17
  .byte $04
  .repeat 2
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 13
     .byte $05
  .endrepeat
  .byte $0F, $11, $10
  .repeat 4
     .byte $05
  .endrepeat
  .byte $06, $06
  .repeat 4
     .byte $05
  .endrepeat
  .byte $03

  ; Row 18
  .byte $02
  .repeat 2
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 4
     .byte $05
  .endrepeat
  .byte $01, $02
  .repeat 5
     .byte $05
  .endrepeat
  .byte $01, $02
  .byte $03, $0E, $04
  .repeat 4
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 4
     .byte $05
  .endrepeat
  .byte $01

  ; Row 19
  .byte $04
  .repeat 8
     .byte $05
  .endrepeat
  .byte $03, $04
  .repeat 5
     .byte $05
  .endrepeat
  .byte $03, $04
  .repeat 7
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 4
     .byte $05
  .endrepeat
  .byte $03

  ; Row 20
  .byte $02
  .repeat 30
    .byte $05
  .endrepeat
  .byte $01

  ; Row 21 
  .byte $04
  .repeat 30
    .byte $05
  .endrepeat
  .byte $03

  ; Row 22
  .byte $02
  .repeat 17
    .byte $05
  .endrepeat
  .repeat 9
    .byte $06
  .endrepeat
  .repeat 4
    .byte $05
  .endrepeat
  .byte $01

  ; Row 23
  .byte $04
  .repeat 3
    .byte $05
  .endrepeat
  .repeat 9
    .byte $06
  .endrepeat
  .repeat 5
    .byte $05
  .endrepeat
  .repeat 9
    .byte $00
  .endrepeat
  .repeat 4
    .byte $05
  .endrepeat
  .byte $03

  ; Row 24 
  .byte $02
  .repeat 3
    .byte $05
  .endrepeat
  .repeat 9
    .byte $00
  .endrepeat
  .repeat 18
    .byte $05
  .endrepeat
  .byte $01

  ; Row 25 
  .byte $04
  .repeat 30
    .byte $05
  .endrepeat
  .byte $03

  ; Row 26 
  .byte $02
  .repeat 30
    .byte $05
  .endrepeat
  .byte $01
    
  ; Row 27
  .byte $04
  .repeat 30
    .byte $05
  .endrepeat
  .byte $03


  ; Bottom Border (Rows 28-29)
  .repeat 6
    .byte $01, $02
  .endrepeat
  .byte $07, $0B, $0B, $0B, $0B, $0B, $0B, $08
  .repeat 6
   .byte $01, $02
  .endrepeat

  .repeat 6
    .byte $03, $04
  .endrepeat
    .byte $09, $0C, $0C, $0C, $0C, $0C, $0C, $0A
   .repeat 6
    .byte $03, $04
  .endrepeat

  ; ATTRIBUTE TABLE (64 bytes) 
  .repeat 64
    .byte $00
  .endrepeat

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

