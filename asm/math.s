
.importzp math_buffer

.export division_16

.segment "CODE"

;;
;; A division alghorithm that divides a 32-bit dividen with a 16-bit divisor
;; 
;; The divisor is the block math_buffer+0 to math_buffer+1, the dividend hi-cell is math_buffer+2 to math_buffer+3, and its lo-cell in math_buffer+4 to math_buffer + 5
;;
;; taken from http://6502.org/source/integers/ummodfix/ummodfix.htm
;;


division_16:
        SEC             ; Detect overflow or /0 condition.
        LDA     math_buffer+2     ; Divisor must be more than high cell of dividend.  To
        SBC     math_buffer       ; find out, subtract divisor from high cell of dividend;
        LDA     math_buffer+3     ; if math_buffer+7 flag is still set at the end, the divisor was
        SBC     math_buffer+1     ; not big enough to avoid overflow. This also takes care
        BCS     @oflo   ; of any /0 condition.  Branch if overflow or /0 error.
                        ; We will loop 16 times; but since we shift the dividend
        LDX     #11H    ; over at the same time as shifting the answer in, the
                        ; operation must start AND finish with a shift of the
                        ; low cell of the dividend (which ends up holding the
                        ; quotient), so we start with 17 (11H) in X.
 @loop:  
        ROL     math_buffer+4     ; Move low cell of dividend left one bit, also shifting
        ROL     math_buffer+5     ; answer in. The 1st rotation brings in a 0, which later
                        ; gets pushed off the other end in the last rotation.
        DEX
        BEQ     @end    ; Branch to the end if finished.

        ROL     math_buffer+2     ; Shift high cell of dividend left one bit, also
        ROL     math_buffer+3     ; shifting next bit in from high bit of low cell.
        LDA     #0
        STA     math_buffer+7   ; Zero old bits of math_buffer+7 so subtraction works right.
        ROL     math_buffer+7   ; Store old high bit of dividend in math_buffer+7.  (For STZ
                        ; one line up, NMOS 6502 will need LDA #0, STA math_buffer+7.)
        SEC             ; See if divisor will fit into high 17 bits of dividend
        LDA     math_buffer+2     ; by subtracting and then looking at math_buffer+7 flag.
        SBC     math_buffer       ; First do low byte.
        STA     math_buffer+6     ; Save difference low byte until we know if we need it.
        LDA     math_buffer+3     ;
        SBC     math_buffer+1     ; Then do high byte.
        TAY             ; Save difference high byte until we know if we need it.
        LDA     math_buffer+7   ; Bit 0 of math_buffer+7 serves as 17th bit.
        SBC     #0      ; Complete the subtraction by doing the 17th bit before
        BCC     @loop    ; determining if the divisor fit into the high 17 bits
                        ; of the dividend.  If so, the math_buffer+7 flag remains set.
        LDA     math_buffer+6     ; If divisor fit into dividend high 17 bits, update
        STA     math_buffer+2     ; dividend high cell to what it would be after
        STY     math_buffer+3     ; subtraction.
        BCS     @loop    ; Always branch.  NMOS 6502 could use BCS here.

 @oflo: 
        LDA     #$FF    ; If overflow occurred, put FF
        STA     math_buffer+2     ; in remainder low byte
        STA     math_buffer+3     ; and high byte,
        STA     math_buffer+4     ; and in quotient low byte
        STA     math_buffer+5     ; and high byte.
 @end:	
        RTS