;; 
;; Use this file to define non-zero-page (ram) variables. 
;; Accessing these is slower than zero-page, but there's much more of it (~2kb)
;; In order to keep consistent track of our ram memory ALL ram variables should be defined in this file 
;;

.export clock_draw_buffer
.export player_backup
.export frame_ready

.export current_scene

.segment "BSS"

;; System variables
frame_ready: .res 1 ; set to a value != 0 when frame logic is ready to be processed
current_scene: .res 1

clock_draw_buffer: .res 16

; player variables for turning back
player_backup: .res 1