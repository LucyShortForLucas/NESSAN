;; 
;; Use this file to define zero-page variables. 
;; REMEMBER: We only have 256 bytes of zero-page memory, so use this space wisely and only when needed.
;; In order to keep consistent track of zero-page memory ALL zero-page variables should be defined in this file 
;;

.exportzp frame_counter
.exportzp second_counter
.exportzp clock_dirty
.exportzp clock_x
.exportzp clock_y
.exportzp math_buffer
.exportzp rand
.exportzp inputs
.exportzp ptr

;testing
.exportzp player_x
.exportzp player_y
.exportzp enemy_x
.exportzp enemy_y

.exportzp coin_x
.exportzp coin_y
.exportzp count_down_x
.exportzp count_down_y
.exportzp coin_x2
.exportzp coin_y2

.exportzp clock_min       
.exportzp clock_sec      
.exportzp clock_frames    

.exportzp player_dir

.segment "ZEROPAGE" ; zero-page memory, fast access: Use sparingly!

;; System variables
math_buffer: .res 8
frame_counter: .res 1
inputs: .res 1
rand: .res 2
ptr: .res 2 ; a temporary 2 byte space to store pointers

;; Demo variables
second_counter: .res 2

clock_x: .res 1
clock_y: .res 1
clock_dirty: .res 1 ; a flag set to determine which parts of the buffer must be updated. Bit 0: value, bit 1: x, bit 2:y

; positions
player_x: .res 1
player_y: .res 1
coin_x: .res 1
coin_y: .res 1
count_down_x: .res 1
count_down_y: .res 1
coin_x2: .res 1
coin_y2: .res 1

clock_min: .res 1
clock_sec: .res 1
clock_frames: .res 1 ; remove  these later when doing proper map buffer
enemy_x:  .res 1
enemy_y:  .res 1

player_dir: .res 1