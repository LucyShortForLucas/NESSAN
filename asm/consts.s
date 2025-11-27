;; Scene enum
SCENE_STARTSCREEN = $00
SCENE_GAME = $01
SCENE_ENDSCREEN = $02


WALL_COLLIDER_TYPES = 3; APU Registers
APU_Status = $4015 ; APU Status/Sound channel (R/W)
APU_Counter = $4017 ; Controls timing 
APU_DM_CONTROL = $4010 ; APU Delta Modulation Control (W)