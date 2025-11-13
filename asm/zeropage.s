;; 
;; Use this file to define zero-page variables. 
;; REMEMBER: We only have 256 bytes of zero-page memory, so use this space wisely and only when needed.
;; In order to keep consistent track of zero-page memory ALL zero-page variables should be defined in this file 
;;

.exportzp frame_counter
.exportzp frame_ready
.exportzp second_counter
.exportzp clock_dirty
.exportzp clock_x
.exportzp clock_y
.exportzp math_buffer

.segment "ZEROPAGE" ; zero-page memory, fast access: Use sparingly!

frame_ready: .res 1 ; set to a value != 0 when frame logic is ready to be processed

math_buffer: .res 8

frame_counter: .res 1
second_counter: .res 2

clock_x: .res 1
clock_y: .res 1
clock_dirty: .res 1 ; a flag set to determine which parts of the buffer must be updated. Bit 0: value, bit 1: x, bit 2:y
