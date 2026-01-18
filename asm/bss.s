;; 
;; Use this file to define non-zero-page (ram) variables. 
;; Accessing these is slower than zero-page, but there's much more of it (~2kb)
;; In order to keep consistent track of our ram memory ALL ram variables should be defined in this file 
;;

; ------------------------------------------------------------------------
.export frame_ready
.export current_scene
.export end_state

.export blue_player_backup
.export red_player_backup
.export collision_aabb_2x2
.export collision_aabb_2x3
.export collision_aabb_3x3
.export collision_aabb_9x2

.export list_pickup
.export pickup_timer

.export clock_draw_buffer
.export laser_buffer
.export explosion_buffer

; ------------------------------------------------------------------------

.segment "BSS"

;; SYSTEM & CORE
frame_ready: .res 1 ; set to a value != 0 when frame logic is ready to be processed
current_scene: .res 1
end_state: .res 1 ; to check what type of ending you have

;; PLAYER PHYSICS
; player variables for turning back
blue_player_backup: .res 2
red_player_backup: .res 2

;; COLLISION SYSTEM
; aabb collision buffers based on size. 2 bytes per box: topleft x, y
; Each buffer has 1 extra byte at the front that holds the number of actual colliders that currently exist in the buffer
collision_aabb_2x2: .res 13 ; Max 6 boxes 
collision_aabb_2x3: .res 9  ; Max 4 boxes
collision_aabb_3x3: .res 7  ; Max 3 boxes
collision_aabb_9x2: .res 9  ; Max 4 boxes

;; GAMEPLAY OBJECTS (PICKUPS)   
list_pickup: .res 10 ; 0th element for how many are active, max 3 coins: 1th for x, 2st for y, 3nd for type, then next coin...
pickup_timer: .res 1 

;; GRAPHICS BUFFERS
clock_draw_buffer: .res 16  ; Buffer for rendering the timer digits.
laser_buffer:      .res 32  ; Stores background tiles, used to restore the map after the laser vanishes.
explosion_buffer:  .res 32  ; Stores background tiles, used to restore the map after the explosion flash.
; ------------------------------------------------------------------------