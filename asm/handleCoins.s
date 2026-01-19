;; IMPORTS AND EXPORTS
.export handle_coin_collection

.import list_pickup             

.import convert_index_to_position  
.import prng                    
.importzp math_buffer           

; ------------------------------------------------------------------------

.segment "CODE"

; input: mathbuffer as index
; no output
; switches the last coin with the current index one and does -1
handle_coin_collection:
    dec list_pickup ; -1 to active amount of coins as we're removing one
    beq @skipCoinListMov ; if 0 skip all!
    
    clc 
    lda list_pickup
    adc #1

    jsr convert_index_to_position ; convert last item index to a position we can use



    cpx math_buffer ; compare x (last element) and math_buffer (element we're replacing)
    beq @skipCoinListMov ; if they are they same, skip! as they're now out of bounds :)
    ; if not then.... change them

    stx math_buffer+1 ; put the element we're going to "remove" (put at the back) in math_buffer+1
    
    ; element to remove = math_buffer
    ; element to keep = math_buffer+1

    ldx math_buffer+1
    ldy math_buffer

    lda list_pickup, x
    sta list_pickup, y
    
    lda list_pickup+1, x
    sta list_pickup+1, y

    lda list_pickup+2, x
    sta list_pickup+2, y


@skipCoinListMov:
    rts 