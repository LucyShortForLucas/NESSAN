;; exports and imports
.export background
.export CoinFrame1
.export CoinFrame2
.export PlayerFrame1
.export PlayerFrame2
.export palettes

.segment "RODATA" ; 
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
  .repeat 17            
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
  .repeat 2            
    .byte $05
  .endrepeat
  .repeat 9          
    .byte $06
  .endrepeat
  .repeat 6             
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
  .repeat 2            
    .byte $05
  .endrepeat
  .repeat 9           
    .byte $00
  .endrepeat
  .repeat 19             
    .byte $05
  .endrepeat
  .byte $01

  ; Row 8
  .byte $02
  .repeat 30
     .byte $05
  .endrepeat
  .byte $01

  ; Row 9
  .byte $04
  .repeat 18
     .byte $05
  .endrepeat
  .byte $01, $0D, $02
  .repeat 9
     .byte $05
  .endrepeat
  .byte $03

  ; Row 10
  .byte $02
  .repeat 3
     .byte $05
  .endrepeat
  .byte $06, $06
  .repeat 13
     .byte $05
  .endrepeat
  .byte $0F, $11 ,$10
  .repeat 9
     .byte $05
  .endrepeat
  .byte $01

  ; Row 11
  .byte $04 ; Left Border
  .repeat 3
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $00, $00 ; Void Tiles
  .byte $05, $05 ; Path Tiles
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
  .repeat 3
     .byte $05 ; Path Tiles
  .endrepeat
  .byte $00, $00 ; Void Tiles
  .byte $05, $05 ; Path Tiles
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
  .repeat 9
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
  .repeat 10
     .byte $05
  .endrepeat
  .byte $06, $06, $03, $04
  .repeat 16
     .byte $05
  .endrepeat
  .byte $01

  ; Row 15
  .byte $04
  .repeat 10
     .byte $05
  .endrepeat
  .byte $00, $00
  .repeat 18
     .byte $05
  .endrepeat
  .byte $03

  ; Row 16
  .byte $02
  .repeat 2
     .byte $05
  .endrepeat
  .byte $06, $06
  .repeat 13
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

PlayerFrame1:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $18, $02, $00  ; Top Left
      .byte $00, $19, $02, $08  ; Top Right
      .byte $08, $1A, $02, $00  ; Bottom Left
      .byte $08, $1B, $02, $08  ; Bottom Right

PlayerFrame2:
      ; Y-off, Tile, Attr, X-off
      .byte $00, $1C, $02, $00  ; Top Left
      .byte $00, $1D, $02, $08  ; Top Right
      .byte $08, $1E, $02, $00  ; Bottom Left
      .byte $08, $1F, $02, $08  ; Bottom Right

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

