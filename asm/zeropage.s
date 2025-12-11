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
.exportzp blue_player_x
.exportzp blue_player_y
.exportzp red_player_x
.exportzp red_player_y

.exportzp coin_x
.exportzp coin_y
.exportzp count_down_x
.exportzp count_down_y

.exportzp score_red_x
.exportzp score_red_y
.exportzp score_blue_x
.exportzp score_blue_y

.exportzp clock_min       
.exportzp clock_sec      
.exportzp clock_frames    

.exportzp blue_player_dir
.exportzp red_player_dir

.exportzp score_red
.exportzp score_blue

.exportzp ability_red
.exportzp ability_blue
.exportzp blue_respawn_timer
.exportzp red_respawn_timer

.exportzp ability_red_icon_x, ability_red_icon_y, ability_blue_icon_x, ability_blue_icon_y

.exportzp ability_red_passtrough_timers
.exportzp ability_blue_passtrough_timers

.exportzp dash_timer_blue
.exportzp dash_timer_red

.exportzp last_blue_player_dir
.exportzp last_red_player_dir

.exportzp bomb_timer, bomb_x, bomb_y, bomb_draw_frame_counter, bomb_veloctiy_x, bomb_velocity_y

.exportzp laser_timer, laser_state, laser_dir_save, laser_x_tile, laser_y_tile, laser_length, laser_buffer, ppu_addr_temp, draw_x, draw_y

.segment "ZEROPAGE" ; zero-page memory, fast access: Use sparingly!

;; System variables
math_buffer: .res 8
frame_counter: .res 1
inputs: .res 2
rand: .res 2
ptr: .res 2 ; a temporary 2 byte space to store pointers

;; Demo variables
second_counter: .res 2

clock_x: .res 1
clock_y: .res 1
clock_dirty: .res 1 ; a flag set to determine which parts of the buffer must be updated. Bit 0: value, bit 1: x, bit 2:y

; positions
blue_player_x: .res 1
blue_player_y: .res 1
blue_player_pickup: .res 1
red_player_x: .res 1
red_player_y: .res 1    
red_player_pickup: .res 1    

coin_x: .res 1
coin_y: .res 1
count_down_x: .res 1
count_down_y: .res 1

clock_min: .res 1
clock_sec: .res 1
clock_frames: .res 1 ; remove  these later when doing proper map buffer

blue_player_dir: .res 1
last_blue_player_dir: .res 1
red_player_dir: .res 1
last_red_player_dir: .res 1

score_red: .res 1
score_red_x: .res 1
score_red_y: .res 1

score_blue: .res 1
score_blue_x: .res 1
score_blue_y: .res 1

ability_red: .res 1
ability_blue: .res 1

ability_red_icon_x: .res 1
ability_red_icon_y: .res 1
ability_blue_icon_x: .res 1
ability_blue_icon_y: .res 1

; Ability timers for passthrough, can be moved to BSS if needed, called minimum 2x per frame
; Byte 1 is main timer, byte 2 is animation timer
ability_red_passtrough_timers: .res 2
ability_blue_passtrough_timers: .res 2
blue_respawn_timer: .res 1
red_respawn_timer: .res 1

dash_timer_red: .res 1
dash_timer_blue: .res 1

; Laser animation
laser_timer:    .res 1     ; Countdown timer
laser_state:    .res 1     ; 0 = Off, 1 = Draw White, 2 = Draw Restore
laser_x_tile:   .res 1     ; Saved X (in tiles, not pixels)
laser_y_tile:   .res 1     ; Saved Y (in tiles, not pixels)
laser_dir_save: .res 1     ; Saved Direction
laser_length:   .res 1     ; Store calculated length here

laser_buffer:   .res 32    ; Temporary storage for the tiles behind the laser
ppu_addr_temp:  .res 2     ; 2-byte helper for PPU address
draw_x:         .res 1     ; Temp variable for calculating start position
draw_y:         .res 1     ; Temp variable for calculating start position

; bomb variables
bomb_timer: .res 1
bomb_x: .res 1
bomb_y: .res 1
bomb_draw_frame_counter: .res 1
bomb_veloctiy_x: .res 1
bomb_velocity_y: .res 1