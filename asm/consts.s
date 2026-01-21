; ------------------------------------------------------------------------
;; HARDWARE REGISTERS (PPU & APU)
PPU_CTRL        = $2000     ; PPU Control Register (W)
PPU_MASK        = $2001     ; PPU Mask Register (W)
PPU_STATUS      = $2002     ; PPU Status Register (R)
PPU_ADDR        = $2006     ; VRAM Address Register (W)
PPU_DATA        = $2007     ; VRAM Data Register (R/W)

APU_STATUS      = $4015     ; Sound Channel Enable/Status
APU_COUNTER     = $4017     ; Frame Counter Control
APU_DM_CONTROL  = $4010     ; DMC Control

;; PPU Configuration Flags
PPU_INC_1           = %10000000 ; Increment VRAM addr by 1 (Horizontal writing)
PPU_INC_32          = %10000100 ; Increment VRAM addr by 32 (Vertical writing)
PPU_MASK_ENABLE_ALL = %00011110 ; Enables Background and Sprites
NAMETABLE_HI        = $20       ; Base High Byte for Nametable 0 ($2000)

;; MEMORY MAP
OAM_BUFFER      = $0200     ; Shadow OAM location in RAM

;; SCENE & GAME STATE
SCENE_STARTSCREEN = $00
SCENE_GAME        = $01
SCENE_ENDSCREEN   = $02

ENDSTATE_TIMERUP  = 0
ENDSTATE_BLUEWINS = 1
ENDSTATE_REDWINS  = 2

POINTER_X_POS     = 80      
POINTER_Y_POS     = 136

;; PLAYER CONFIGURATION
; Spawn Coordinates
BLUE_PLAYER_SPAWN_X = $20
BLUE_PLAYER_SPAWN_Y = $20
RED_PLAYER_SPAWN_X  = $DD
RED_PLAYER_SPAWN_Y  = $CC

; Dimensions & Movement
PLAYER_W        = 9         ; Width in pixels
PLAYER_H        = 12        ; Height in pixels
DIR_DOWN        = 0
DIR_UP          = 1
DIR_LEFT        = 2
DIR_RIGHT       = 3

RESPAWN_FRAMES  = 100       ; Death cooldown duration
COINS_LOST_ON_DEATH = 3

;; MAP & COLLISION BOUNDS
WALL_COLLIDER_TYPES = 4

; Playable Area Limits (in Tiles)
SCREEN_LIMIT_R  = 31
SCREEN_LIMIT_L  = 1
SCREEN_LIMIT_B  = 28
SCREEN_LIMIT_T  = 2

;; ABILITIES & PICKUPS
MAX_PICKUPS     = 3
COIN_CAP        = 10        ; Coins needed to win

; Pickup Types (Enum)
PICKUP_NONE        = 0
PICKUP_DASH        = 1
PICKUP_GUN         = 2
PICKUP_PASSTHROUGH = 3
PICKUP_BOMB        = 4

; Dash Ability
DASH_DURATION      = 20      ; Frames

; Passthrough Ability
PASSTHROUGH_ANIMATION_MAX       = 18
PASSTHROUGH_ANIMATION_MAX_DIV2  = PASSTHROUGH_ANIMATION_MAX / 2
PASSTHROUGH_FRAME_COUNTER_MAX   = 250   ; Duration (~5 seconds at 50fps)
PASSTHROUGH_ANIMATION_SPEEDUP_THRESHOLD = 75

; Laser Ability
LASER_ANIMATION_DURATION = 5
LASER_OFFSET             = 2    ; Start distance from player center (tiles)
LASER_TILE_ID            = $FF  ; White tile index
LASER_STATE_DRAW         = 1

; Bomb Ability
BOMB_TIMER_FRAMES        = 150  ; Fuse time (3 seconds)
BOMB_BLAST_RADIUS        = 32   ; Pixels
BOMB_THROW_SPEED         = 3

BOMB_THROW_THRESHOLD     = BOMB_TIMER_FRAMES - 20
BOMB_BLINK_THRESHOLD1    = 100  ; Slow blink start
BOMB_BLINK_THRESHOLD2    = 50   ; Fast blink start

EXPLOSION_STATE_IDLE    = 0
EXPLOSION_STATE_DRAW    = 1
EXPLOSION_STATE_RESTORE = 2

EXPLOSION_SCREEN_WIDTH  = 32   
EXPLOSIONTWO_ROWS_OFFSET= 64 

;; ANIMATION SPEEDS (Bitmasks)
ANIM_SPEED_PICKUP = $20     ; Used for Coins, Dash, Gun, etc.
ANIM_SPEED_PLAYER = $08     ; Used for Player walking

;; AUDIO (SONGS & SFX)
; Songs
SONG_START      = $00
SONG_GAME       = $01
SONG_END        = $02

; Sound Effects
SFX_COIN          = $00
SFX_ABILITYPICKUP = $01
SFX_GUNFIRE       = $02
SFX_ABILITYUSAGE  = $03
SFX_WIN           = $04
SFX_LOSE          = $05
SFX_BOMB          = $06
SFX_DASH          = $07

;; RNG & SPAWN RATES
; Percentage Chances (Must sum to 100, remainder goes to Bomb)
PERCENTAGE_COINS       = 59
PERCENTAGE_DASH        = 12
PERCENTAGE_GUN         = 12
PERCENTAGE_PASSTHROUGH = 12
PERCENTAGE_BOMB        = 5

; Do not edit
NUMBER_RAND_COINS       = 256 * PERCENTAGE_COINS / 100
NUMBER_RAND_DASH        = 256 * PERCENTAGE_DASH / 100 + NUMBER_RAND_COINS
NUMBER_RAND_GUN         = 256 * PERCENTAGE_GUN / 100 + NUMBER_RAND_DASH
NUMBER_RAND_PASSTHROUGH = 256 * PERCENTAGE_PASSTHROUGH / 100 + NUMBER_RAND_GUN
; template for later   NUMBER_RAND_NAME = 256 * PERCENTAGE_NAME / 100 + NUMBER_RAND_PREVIOUSNAME
; ------------------------------------------------------------------------