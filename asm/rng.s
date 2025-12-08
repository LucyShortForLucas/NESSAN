.segment "CODE"

.importzp rand
.importzp math_buffer

.import wall_collisions

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

	lda #16 ; Load pickup size
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

	jsr prng ; New rand number for type
	sec
	sbc 

	pla

	rts
