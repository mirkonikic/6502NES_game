updatejoy:
; first, strobe the joypad
	NOP
	LDA #1
	STA $4016
	LDA #0
	STA $4016
	NOP

; now we're going to loop 8 times (once for each button), and
; rotate each button's status into our button_state variable

	LDX #$08            ; set X to 8 (the number of times we want to loop)
	joyloop:
	LDA $4016         ; get button state
	LSR A             ; shift it into the C flag
	ROR button_state  ; rotate C flag into our button_state variable
	DEX               ; decrement X (our loop counter)
	BNE joyloop       ; jump back to our loop until X is zero

;EXAMPLE HOW TO USE THIS PROCEDURE
;	LDA button_state
;	AND key_right
;	BNE right_is_pressed
;	JMP right_isnt_pressed
