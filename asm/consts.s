;; Scene enum
SCENE_STARTSCREEN = $00
SCENE_GAME = $01
SCENE_ENDSCREEN = $02


WALL_COLLIDER_TYPES = 4; APU Registers
APU_Status = $4015 ; APU Status/Sound channel (R/W)
APU_Counter = $4017 ; Controls timing 
APU_DM_CONTROL = $4010 ; APU Delta Modulation Control (W)

PLAYER_TILE = 8
ENEMY_TILE  = 9

; Songs enum
SONG_START = $00
SONG_GAME = $01
SONG_END = $02

PLAYER_W = 9
PLAYER_H = 12
ENEMY_W  = 8
ENEMY_H  = 8

MAX_PICKUPS = 3

; Pickup Enum
PICKUP_NONE = 0
PICKUP_DASH = 1
PICKUP_GUN = 2
PICKUP_PASSTHROUGH = 3
PICKUP_BOMB = 4

; Static start screen pointer
Pointer_X_pos = 80
Pointer_Y_pos = 136

MiddleEndScreen_X_pos = 96
MiddleEndScreen_Y_pos = 112

; Enum endState
endState_TimerUp = $00
endState_Player1 = $01
endState_Player2 = $02