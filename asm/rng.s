.segment "CODE"

.importzp rand
.importzp math_buffer
.importzp bomb_x

.import wall_collisions
.import ConvertIndexToPosition
.import list_pickup

.export prng
.export spawn_new_pickup

.include "consts.s"

;;
;; A subroutine that, when called, fills [rand+0, rand+1] with pseudorandom bytes. 
;; DO NOT write to these bytes, you'll fuck up the rng
;;

prng:
	ldy #8     ; iteration count
	lda rand+0
@loop:
	asl        ; shift the register
	rol rand+1
	bcc @skip
	eor #$39   ; apply XOR feedback whenever a 1 bit is shifted out
@skip:
	dey
	bne @loop
	sta rand+0
	cmp #0     ; reload flags
	rts


;;
;; A subroutine that a spawns in a new random pickup
;; Accumulator should hold the index of pickup to overwrite
;; This uses the math buffer
;;
spawn_new_pickup: 
	pha ; Push index onto stack

	lda #12 ; Load pickup size
	sta math_buffer+2
	sta math_buffer+3

@try_place_loop:
	jsr prng ; Grab new random number

	lda rand ; Use lo-byte as X value
	cmp #8 ; check left border
    bcc @try_place_loop 
    cmp #226
    bcs @try_place_loop

	lda rand+1 ; Use hi-byte as Y value
	cmp #16 ; check up bound
    bcc @try_place_loop
    cmp #200
    bcs @try_place_loop

	lda rand ; check wall collisions
	sta math_buffer
	lda rand+1
	sta math_buffer+1
	jsr wall_collisions
	bcs @try_place_loop

	pla
	jsr ConvertIndexToPosition ; Get pickup index in x register

	lda rand
    sta list_pickup, x
    lda rand+1
    sta list_pickup+1, x
    ; 65% Coin, 10% each Ability, except for bomb has 5%
	jsr prng
    lda rand             ; Load the random number (0-255)

    cmp #167             ; 65% of 256 is approx 167
    bcc @SetCoin         ; If less than 180, it is a Coin

    cmp #180             ; next 5% (167 + 13)
    bcc @SetBomb         ; If between 167 and 180, it is a bomb

    cmp #206             ; Next 10% (180 + 26)
    bcc @SetDash         ; If between 180 and 205, it is Dash

    cmp #231             ; Next 10% (206 + 25)
    bcc @SetGun          ; If between 206 and 230, it is Gun

    ; If we are here, it is > 230 (The last 10%)
    lda #3               ; Set Phase
    sta list_pickup+2, x
    rts

@SetCoin:
    lda #PICKUP_NONE
    jmp @return

@SetBomb:
	; if 0 then bomb is not active and we can use it
	;lda bomb_x
	;bne @SetDash ; if bomb is active, skip to next pickup type
	;lda #1 ; to indicate bomb is active
	;sta bomb_x
	lda #PICKUP_BOMB ; set bomb pickup
	jmp @return

@SetDash:
    lda #PICKUP_DASH
    jmp @return

@SetGun:
    lda #PICKUP_GUN

@return:
    sta list_pickup+2, x
    rts
