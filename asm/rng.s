;; IMPORTS AND EXPORTS
.include "consts.s"

.export prng                 
.export spawn_new_pickup     

.importzp rand               
.importzp math_buffer        

.import wall_collisions
.import convert_index_to_position
.importzp bomb_x              

.import list_pickup           

; ------------------------------------------------------------------------

.segment "CODE"

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
	jsr convert_index_to_position ; Get pickup index in x register

	lda rand
    sta list_pickup, x
    lda rand+1
    sta list_pickup+1, x
    ; 65% Coin, 10% each Ability, except for bomb has 5%
	jsr prng
    lda rand             ; Load the random number (0-255)

    cmp #NUMBER_RAND_COINS             ; 65% of 256 is approx 167
    bcc @SetCoin         ; If less than 180, it is a Coin


    cmp #NUMBER_RAND_DASH             ; Next 10% (180 + 26)
    bcc @SetDash         ; If between 180 and 205, it is Dash

    cmp #NUMBER_RAND_GUN             ; Next 10% (206 + 25)
    bcc @SetGun          ; If between 206 and 230, it is Gun
	
    cmp #NUMBER_RAND_PASSTHROUGH   ; next 10% (167 + 13)
    bcc @SetPhase         ; If between 167 and 180, it is a bomb

    ; If we are here, it is > 230 (The last %)
    lda #PICKUP_BOMB               ; Set bomb
    jmp @return

@SetCoin:
    lda #PICKUP_NONE
    jmp @return

@SetPhase:
	lda #PICKUP_PASSTHROUGH ; set bomb pickup
	jmp @return

@SetDash:
    lda #PICKUP_DASH
    jmp @return

@SetGun:
    lda #PICKUP_GUN

@return:
    sta list_pickup+2, x
    rts
