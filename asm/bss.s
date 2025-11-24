;; 
;; Use this file to define non-zero-page (ram) variables. 
;; Accessing these is slower than zero-page, but there's much more of it (~2kb)
;; In order to keep consistent track of our ram memory ALL ram variables should be defined in this file 
;;

.export clock_draw_buffer
.export player_backup

.segment "BSS"

clock_draw_buffer: .res 16

; player variables for turning back
player_backup: .res 1