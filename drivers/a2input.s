.export get_key
.export check_for_abort_key
.export get_key_if_available
.export get_key_ip65
.export abort_key
.exportzp abort_key_default = $9b
.exportzp abort_key_disable = $80

.import ip65_process


.data

abort_key: .byte $9b            ; ESC


.code

; use Apple 2 monitor ROM function to read from keyboard
; inputs: none
; outputs: A contains ASCII value of key just pressed
get_key = $fd0c

; inputs: none
; outputs: sec if key pressed, clear otherwise
;          A contains ASCII value of key just pressed
get_key_if_available:
  sec
  lda $c000                     ; current key pressed
  bmi got_key
  clc
  rts

; process inbound ip packets while waiting for a keypress
get_key_ip65:
  jsr ip65_process
  lda $c000                     ; key down?
  bpl get_key_ip65
got_key:
  bit $c010                     ; clear the keyboard strobe
  and #$7f
  rts

; check whether the abort key is being pressed
; inputs: none
; outputs: sec if abort key pressed, clear otherwise
check_for_abort_key:
  lda $c000                     ; current key pressed
  cmp abort_key
  bne :+
  bit $c010                     ; clear the keyboard strobe
  sec
  rts
: clc
  rts



; -- LICENSE FOR a2input.s --
; The contents of this file are subject to the Mozilla Public License
; Version 1.1 (the "License"); you may not use this file except in
; compliance with the License. You may obtain a copy of the License at
; http://www.mozilla.org/MPL/
;
; Software distributed under the License is distributed on an "AS IS"
; basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
; License for the specific language governing rights and limitations
; under the License.
;
; The Original Code is ip65.
;
; The Initial Developer of the Original Code is Jonno Downes,
; jonno@jamtronix.com.
; Portions created by the Initial Developer are Copyright (C) 2009
; Jonno Downes. All Rights Reserved.
; -- LICENSE END --
