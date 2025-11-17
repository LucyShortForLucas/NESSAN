.segment "CODE"

.importzp rand

.export prng

;;
;; A subroutine that, when called, fills [rand+0, rand+1] with pseudorandom bytes
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