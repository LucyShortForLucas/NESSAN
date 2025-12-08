
.macro HandlePickupSpawn
.scope

    inc pickup_timer
    inc pickup_timer
    bne @skip_pickup_spawn

@fill_pickups:
    lda list_pickup
    cmp #MAX_PICKUPS ; Skip if max pickups exist already
    beq @skip_pickup_spawn

    lda list_pickup ; Spawn new pickup
    clc
    adc #1
    sta list_pickup
    jsr spawn_new_pickup
    jmp @fill_pickups

    @skip_pickup_spawn:

.endscope
.endmacro