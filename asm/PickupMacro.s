
.include "killMacro.s"

.macro ShootGun x_coord, y_coord, direction
.scope

    Kill blue_respawn_timer, score_blue, ability_blue, blue_player_x, blue_player_y, #24, #24

.endscope
.endmacro