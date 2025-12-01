;; 
;; Use this file to define non-zero-page (ram) variables. 
;; Accessing these is slower than zero-page, but there's much more of it (~2kb)
;; In order to keep consistent track of our ram memory ALL ram variables should be defined in this file 
;;

.export clock_draw_buffer
.export player_backup
.export frame_ready

.export current_scene

.export collision_aabb_2x2
.export collision_aabb_2x3
.export collision_aabb_3x3
.export collision_aabb_9x2

.segment "BSS"

;; System variables
frame_ready: .res 1 ; set to a value != 0 when frame logic is ready to be processed
current_scene: .res 1

clock_draw_buffer: .res 16

; player variables for turning back
player_backup: .res 1

; aabb collision buffers based on size. 2 bytes per box: topleft x, y
;
; Each buffer has 1 extra byte at the front that holds the number of actual colliders that currently exist in the buffer
collision_aabb_2x2: .res 13
collision_aabb_2x3: .res 9
collision_aabb_3x3: .res 7
collision_aabb_9x2: .res 9
