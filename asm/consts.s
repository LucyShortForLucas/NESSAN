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

PLAYER_W = 13
PLAYER_H = 13
ENEMY_W  = 8
ENEMY_H  = 8