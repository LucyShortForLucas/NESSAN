;; 
;; Simple macro for initial ram variable values
;; 

;; IMPORTS AND EXPORTS
.include "coinListMacro.s"

.importzp ability_red_passtrough_timers
.importzp ability_blue_passtrough_timers

; ------------------------------------------------------------------------

.segment "CODE"

.macro InitVariables

; setup clock
lda #50
sta clock_x
sta clock_y

lda #0
sta ability_blue_passtrough_timers ; Set to 0 (inactive)
sta ability_red_passtrough_timers  ; Set to 0 (inactive)

; positions
lda #$60          ; X = 96 (Center-left position)
sta coin_x
lda #$60          ; Y = 96 (Center vertical position)
sta coin_y

lda #BLUE_PLAYER_SPAWN_X          
sta blue_player_x
lda #BLUE_PLAYER_SPAWN_Y         
sta blue_player_y

lda #RED_PLAYER_SPAWN_X
sta red_player_x
lda #RED_PLAYER_SPAWN_Y    
sta red_player_y

lda #$6D          
sta count_down_x
lda #$E3         
sta count_down_y

lda #$D0
sta score_red_x
lda #$02
sta score_red_y

lda #$20
sta score_blue_x
lda #$02
sta score_blue_y

lda #$14
sta ability_blue_icon_x
lda #$E3
sta ability_blue_icon_y
lda #$E4
sta ability_red_icon_x
lda #$E3
sta ability_red_icon_y

; setup main level collisions
; These are in "tile coordinates", where each coordinate represents the top-left corner of an 8x8 tile.
; the entire screen has a size of 32x30 tiles

; 9x2
lda #4
sta collision_aabb_9x2 ; count
lda #18 
sta collision_aabb_9x2 + 1; x
lda #5
sta collision_aabb_9x2 + 2 ; y

lda #3
sta collision_aabb_9x2 + 3; x
lda #6
sta collision_aabb_9x2 + 4 ; y

lda #4
sta collision_aabb_9x2 + 5 ; x
lda #23
sta collision_aabb_9x2 + 6 ; y

lda #18
sta collision_aabb_9x2 + 7; x
lda #22
sta collision_aabb_9x2 + 8 ; y

;2x2 
lda #6
sta collision_aabb_2x2 ; count
lda #8
sta collision_aabb_2x2 +1; x
lda #11
sta collision_aabb_2x2 + 2 ; y

lda #13
sta collision_aabb_2x2 + 3; x
lda #13
sta collision_aabb_2x2 + 4 ; y

lda #20
sta collision_aabb_2x2 + 5; x
lda #12
sta collision_aabb_2x2 + 6 ; y

lda #11
sta collision_aabb_2x2 + 7; x
lda #14
sta collision_aabb_2x2 + 8 ; y

lda #9
sta collision_aabb_2x2 + 9; x
lda #18
sta collision_aabb_2x2 + 10 ; y

lda #16
sta collision_aabb_2x2 + 11; x
lda #18
sta collision_aabb_2x2 + 12; y


; 3x3
lda #3
sta collision_aabb_3x3 ; count
lda #10
sta collision_aabb_3x3 + 1; x
lda #11
sta collision_aabb_3x3 + 2 ; y

lda #19
sta collision_aabb_3x3 + 3; x
lda #9
sta collision_aabb_3x3 + 4 ; y

lda #18
sta collision_aabb_3x3 + 5; x
lda #16
sta collision_aabb_3x3 + 6 ; y

; 2x3
lda #4
sta collision_aabb_2x3 ; count
lda #4
sta collision_aabb_2x3 + 1; x
lda #10
sta collision_aabb_2x3 + 2 ; y

lda #26
sta collision_aabb_2x3 + 3; x
lda #11
sta collision_aabb_2x3 + 4 ; y

lda #3
sta collision_aabb_2x3 + 5 ; x
lda #16
sta collision_aabb_2x3 + 6 ; y

lda #25
sta collision_aabb_2x3 + 7; x
lda #17
sta collision_aabb_2x3 + 8 ; y

.endmacro