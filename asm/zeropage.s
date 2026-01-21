;; 
;; Use this file to define zero-page variables. 
;; REMEMBER: We only have 256 bytes of zero-page memory, so use this space wisely and only when needed.
;; In order to keep consistent track of zero-page memory ALL zero-page variables should be defined in this file 
;;

.exportzp math_buffer, rand, ptr
.exportzp inputs, frame_counter

.exportzp second_counter
.exportzp clock_x, clock_y
.exportzp clock_min, clock_sec, clock_frames

.exportzp blue_player_x, blue_player_y, blue_player_dir, last_blue_player_dir
.exportzp red_player_x, red_player_y, red_player_dir, last_red_player_dir
.exportzp blue_respawn_timer, red_respawn_timer

.exportzp coin_x, coin_y
.exportzp count_down_x, count_down_y

.exportzp score_red, score_blue
.exportzp score_red_x, score_red_y
.exportzp score_blue_x, score_blue_y
.exportzp ability_red_icon_x, ability_red_icon_y
.exportzp ability_blue_icon_x, ability_blue_icon_y

.exportzp ability_red, ability_blue
.exportzp ability_red_passtrough_timers, ability_blue_passtrough_timers
.exportzp dash_timer_red, dash_timer_blue

.exportzp bomb_timer, bomb_x, bomb_y
.exportzp bomb_draw_frame_counter
.exportzp bomb_veloctiy_x, bomb_velocity_y
.exportzp explosion_state, explosion_timer, bomb_ppu_addr

.exportzp laser_timer, laser_state, laser_length, laser_dir_save
.exportzp laser_x_tile, laser_y_tile
.exportzp ppu_addr_temp, draw_x, draw_y

; ------------------------------------------------------------------------

.segment "ZEROPAGE" ; zero-page memory, fast access: Use sparingly!

;; SYSTEM KERNEL
math_buffer:    .res 8      
ptr:            .res 2      ; a temporary 2 byte space to store pointers
rand:           .res 2      
inputs:         .res 2      
frame_counter:  .res 1      

;; CLOCK
second_counter: .res 2
clock_x:        .res 1
clock_y:        .res 1
clock_min:      .res 1
clock_sec:      .res 1
clock_frames:   .res 1      

;; PLAYERS (PHYSICS & STATE)
; Positions (Pixels)
blue_player_x:      .res 1
blue_player_y:      .res 1
red_player_x:       .res 1
red_player_y:       .res 1

; Directions (Enum: 0=Down, 1=Up, 2=Left, 3=Right)
blue_player_dir:        .res 1
last_blue_player_dir:   .res 1
red_player_dir:         .res 1
last_red_player_dir:    .res 1

; Status
blue_player_pickup: .res 1      ; Item currently held by Blue.
red_player_pickup:  .res 1      ; Item currently held by Red.
blue_respawn_timer: .res 1      
red_respawn_timer:  .res 1

;; ABILITIES & POWERUPS
; Ability State
ability_red:        .res 1
ability_blue:       .res 1

; Timers
dash_timer_red:     .res 1
dash_timer_blue:    .res 1
ability_red_passtrough_timers:  .res 2 ; Byte 1=Main Timer, Byte 2=Anim Frame
ability_blue_passtrough_timers: .res 2

; UI Icon Positions
ability_red_icon_x: .res 1
ability_red_icon_y: .res 1
ability_blue_icon_x:.res 1
ability_blue_icon_y:.res 1

;; WEAPON LOGIC: BOMB
bomb_timer:         .res 1
bomb_x:             .res 1
bomb_y:             .res 1
bomb_veloctiy_x:    .res 1
bomb_velocity_y:    .res 1
bomb_draw_frame_counter: .res 1

; Bomb Visuals (Explosion)
explosion_state:    .res 1      ; 0=Off, 1=Flash, 2=Restore
explosion_timer:    .res 1      ; Duration of the white flash
bomb_ppu_addr:      .res 2      ; Temp pointer for drawing the explosion

;; WEAPON LOGIC: LASER
laser_timer:        .res 1
laser_state:        .res 1      ; 0=Off, 1=Draw, 2=Restore
laser_length:       .res 1      ; Length of beam in tiles
laser_dir_save:     .res 1      ; Direction shot (fixed once fired)
laser_x_tile:       .res 1      ; Origin Tile X
laser_y_tile:       .res 1      ; Origin Tile Y

; Laser Visuals (Helpers)
ppu_addr_temp:      .res 2      ; Temp pointer for drawing the laser
draw_x:             .res 1      ; Scratch var for calculating beam path
draw_y:             .res 1      ; Scratch var for calculating beam path

;; OBJECTS & UI
coin_x:         .res 1
coin_y:         .res 1
count_down_x:   .res 1
count_down_y:   .res 1

score_red:      .res 1
score_red_x:    .res 1
score_red_y:    .res 1

score_blue:     .res 1
score_blue_x:   .res 1
score_blue_y:   .res 1
; ------------------------------------------------------------------------