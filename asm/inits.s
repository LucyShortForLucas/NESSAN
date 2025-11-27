;; 
;; Simple macro for initial ram variable values
;; 

.segment "CODE"

.macro InitVariables

; setup clock
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


; setup main level collisions

; 9x2
lda #18 
sta collision_aabb_9x2 ; x
lda #5
sta collision_aabb_9x2 + 1 ; y

lda #3
sta collision_aabb_9x2 + 2; x
lda #6
sta collision_aabb_9x2 + 3 ; y

lda #4
sta collision_aabb_9x2 + 4 ; x
lda #23
sta collision_aabb_9x2 + 5 ; y

lda #3
sta collision_aabb_9x2 + 6; x
lda #6
sta collision_aabb_9x2 + 7 ; y

;2x2 
lda #8
sta collision_aabb_2x2 ; x
lda #11
sta collision_aabb_2x2 + 1 ; y

lda #13
sta collision_aabb_2x2 + 2; x
lda #13
sta collision_aabb_2x2 + 3 ; y

lda #20
sta collision_aabb_2x2 + 4; x
lda #12
sta collision_aabb_2x2 + 5 ; y

lda #11
sta collision_aabb_2x2 + 6; x
lda #14
sta collision_aabb_2x2 + 7 ; y

lda #9
sta collision_aabb_2x2 + 8; x
lda #18
sta collision_aabb_2x2 + 9 ; y

lda #16
sta collision_aabb_2x2 + 10; x
lda #18
sta collision_aabb_2x2 + 11; y


; 3x3
lda #10
sta collision_aabb_3x3 ; x
lda #11
sta collision_aabb_3x3 + 1 ; y

lda #19
sta collision_aabb_3x3 + 2; x
lda #9
sta collision_aabb_3x3 + 3 ; y

lda #18
sta collision_aabb_3x3 + 4; x
lda #16
sta collision_aabb_3x3 + 5 ; y

; 2x3
lda #4
sta collision_aabb_2x3 ; x
lda #10
sta collision_aabb_2x3 + 1 ; y

lda #26
sta collision_aabb_2x3 + 2; x
lda #10
sta collision_aabb_2x3 + 3 ; y

lda #2
sta collision_aabb_2x3 + 4 ; x
lda #10
sta collision_aabb_2x3 + 5 ; y

lda #25
sta collision_aabb_2x3 + 6; x
lda #17
sta collision_aabb_2x3 + 7 ; y

.endmacro