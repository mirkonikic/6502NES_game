PHA	;push contents of A register
updateplayer:
	LDA button_state
	AND #%10000000
	BEQ right_not
	
	INC harry_tl_x
right_not:
	AND #%010000000
	;BNE left_is_down
	AND #%00100000
	;BNE up_is_down
	AND #%00010000
	;BNE down_is_down
	AND #%00001000
	;BNE a_is_down
	AND #%00000100
	;BNE b_is_down
	AND #%00000010
	;BNE select_is_down
	AND #%00000001
	;BNE start_is_down
	JMP end_update	

end_update:
PLA	;pull contents of A register
