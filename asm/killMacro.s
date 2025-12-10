.macro Kill respawn_timer, coin_count, player_pickup, player_x, player_y, respawn_x, respawn_y
.scope

lda #RESPAWN_FRAMES
sta respawn_timer ; set respawn timer

lda coin_count
sec
sbc #COINS_LOST_ON_DEATH ; subtract 3 coins
bcs @no_underflow
lda #0 ; If player had less then 3 coins set them to 0 instead
@no_underflow:
sta coin_count

lda #0
sta player_pickup ; remove player pickup, if any 

lda respawn_x ; set position to respawn position
sta player_x
lda respawn_y
sta player_y

.endscope
.endmacro