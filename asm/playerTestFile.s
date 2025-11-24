.export draw_player
.export draw_enemy
.export move_player_input

.import aabb_collision
.importzp math_buffer

.import player_backup
.importzp player_x, player_y, enemy_x, enemy_y

.importzp inputs

.segment "CODE"

PLAYER_TILE = 8
ENEMY_TILE  = 9


; dimensions
PLAYER_W = 8
PLAYER_H = 8
ENEMY_W  = 8
ENEMY_H  = 8

; draw_player_enemy
; draws player and enemy sprites at their respective positions
draw_player:
  ; player
  lda player_y
  sta $2004
  lda #PLAYER_TILE
  sta $2004
  lda # 0
  sta $2004
  lda player_x
  sta $2004

  rts

draw_enemy:
  ; enemy
  lda enemy_y
  sta $2004
  lda #ENEMY_TILE
  sta $2004
  lda # 0
  sta $2004
  lda enemy_x
  sta $2004

  rts


move_player_input:    

  ; load all stuff into math_buffer for collision check
  lda player_x
  sta math_buffer+0 ; a_X

  lda #PLAYER_W
  sta math_buffer+2 ; a_width
  lda #PLAYER_H
  sta math_buffer+3 ; a_height
  lda enemy_x
  sta math_buffer+4 ; b_X
  lda enemy_y
  sta math_buffer+5 ; b_Y
  lda #ENEMY_W
  sta math_buffer+6 ; b_width
  lda #ENEMY_H
  sta math_buffer+7 ; b_height

  ; load into backup before changing Y
  lda player_y
  sta player_backup

  ; move player based on input
  lda inputs
  and #%00001000 ; up
  beq @skip_up
  dec player_y
@skip_up:
  lda inputs
  and #%00000100 ; down
  beq @skip_down
  inc player_y
@skip_down:
  ; load Y into math_buffer as we just changed it
  lda player_y
  sta math_buffer+1 ; a_Y
  
  ; check collison
  jsr aabb_collision
  bcc @no_hit_y


; collision detected, reset player position y
  lda player_backup
  sta player_y
; also reset the math buffer as we use it again for X
  lda player_backup
  sta math_buffer+1 ; a_Y

@no_hit_y:
  ; load into backup before changing X
  lda player_x
  sta player_backup

  ; move player based on input
  lda inputs
  and #%00000010 ; left
  beq @skip_left
  dec player_x
@skip_left:
  lda inputs
  and #%00000001 ; right
  beq @skip_right
  inc player_x
@skip_right:

  lda player_x
  sta math_buffer+0 ; a_X
; check collison
  jsr aabb_collision
  bcc @no_hit_x
; collision detected, reset player position x
  lda player_backup
  sta player_x
@no_hit_x:
  rts