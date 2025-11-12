;; 
;; Use this file to define zero-page variables. 
;; REMEMBER: We only have 256 bytes of zero-page memory, so use this space wisely and only when needed.
;; In order to keep consistent track of zero-page memory ALL zero-page variables should be defined in this file 
;;

.exportzp some_var
.exportzp some_other_var
.exportzp some_array

.segment "ZEROPAGE" ; zero-page memory, fast access: Use sparingly!

some_var: .res 1
some_other_var: .res 1
some_array: .res 5

