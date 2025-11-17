;; 
;; Use this file to define non-zero-page (ram) variables. 
;; Accessing these is slower than zero-page, but there's much more of it (~2kb)
;; In order to keep consistent track of our ram memory ALL ram variables should be defined in this file 
;;

.export clock_draw_buffer
.export frame_ready

.segment "BSS"

frame_ready: .res 1 ; set to a value != 0 when frame logic is ready to be processed

clock_draw_buffer: .res 16