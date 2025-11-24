;; exports and imports
.export background
.export palettes

.segment "RODATA" ; 
background:
  ; --- TOP BORDER (Rows 0-1) ---
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
  .byte $04             ; Left Border
  .repeat 3             ; 3 tiles of Path
    .byte $05
  .endrepeat
  .repeat 9             ; 9 tiles of Void
    .byte $06
  .endrepeat
  .repeat 6             ; 6 tiles of Path
    .byte $05
  .endrepeat
  .repeat 9             ; 9 tiles of Void
    .byte $06
  .endrepeat
  .repeat 3             ; 3 tiles of Path
    .byte $05
  .endrepeat
  .byte $03             ; Right Border

  ; Row 6
  .byte $02             ; Left Border
  .repeat 3             ; 3 tiles of Path
    .byte $05
  .endrepeat
  .repeat 9             ; 9 tiles of Void
    .byte $00
  .endrepeat
  .repeat 6             ; 6 tiles of Path
    .byte $05
  .endrepeat
  .repeat 9             ; 9 tiles of Void
    .byte $00
  .endrepeat
  .repeat 3             ; 3 tiles of Path
    .byte $05
  .endrepeat
  .byte $01             ; Right Border

  ; Row 7
  .byte $04
  .byte $05, $05, $05
  .byte $00, $00
  .repeat 20
    .byte $05
  .endrepeat
  .byte $00, $00
  .byte $05, $05, $05
  .byte $03

  ; Row 8
  .byte $02
  .byte $05, $05, $05
  .byte $00, $00
  .repeat 20
    .byte $05
  .endrepeat
  .byte $00, $00
  .byte $05, $05, $05
  .byte $01

  ; Row 9
  .byte $04
  .byte $05, $05, $05
  .byte $00, $00
  .repeat 20
    .byte $05
  .endrepeat
  .byte $00, $00
  .byte $05, $05, $05
  .byte $03

  ; 10-27 
  .repeat 9
    ; Line A
    .byte $02
    .repeat 30
      .byte $05
    .endrepeat
    .byte $01

    ; Line B
    .byte $04
    .repeat 30
      .byte $05
    .endrepeat
    .byte $03
  .endrepeat


  ; --- BOTTOM BORDER (Rows 28-29) ---
  .repeat 16
    .byte $01, $02
  .endrepeat
  .repeat 16
    .byte $03, $04
  .endrepeat


  ; --- ATTRIBUTE TABLE (64 bytes) ---
  .repeat 64
    .byte $00
  .endrepeat

palettes:
  ; Background Palette
  .byte $0f, $00, $10, $20
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

  ; Sprite Palette
  .byte $0f, $00, $10, $20
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00
  .byte $0f, $00, $00, $00

; Character memory
.segment "CHARS"
.incbin "assets.chr"

