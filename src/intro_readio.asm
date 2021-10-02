update_joypad:
	NOP
	LDA #1
	STA $4016
	LDA #0
	STA $4016

ReadA: 
	LDA joypad1     ; player 1 - A
	AND #%00000001  ; only look at bit 0
	BEQ ReadADone   ; branch to ReadADone if button is NOT pressed (0)
ReadADone:        ; handling this button is done
  
ReadB: 
	LDA joypad1     ; player 1 - B
	AND #%00000001  ; only look at bit 0
	BEQ ReadBDone   ; branch to ReadBDone if button is NOT pressed (0)
ReadBDone:        ; handling this button is done

ReadSelect: 
	LDA joypad1     ; player 1 - A
	LSR A
	BCS HandleSelect
	JMP ReadSelectDone
	;AND #%00000001  ; only look at bit 0
	;BEQ ReadSelectDone   ; branch to ReadADone if button is NOT pressed (0)
ReadSelectDone:

ReadStart: 
	LDA joypad1     ; player 1 - A
	;AND #%00000001  ; only look at bit 0
	;BEQ ReadStartDone   ; branch to ReadADone if button is NOT pressed (0)
	;LSR A
	;BCS HandleStart
	;JMP ReadStartDone
ReadStartDone:

ReadUp: 
	LDA joypad1     ; player 1 - A
	LSR
	BCS HandleUp
	JMP ReadUpDone   ; branch to ReadADone if button is NOT pressed (0)
HandleUp:
	INC harry_tl_y
	INC harry_tr_y
	INC harry_bl_y
	INC harry_br_y
ReadUpDone:

ReadDown: 
	LDA joypad1     ; player 1 - A
	LSR A
	BCS HandleDown
	JMP ReadDownDone
HandleDown:
	DEC harry_tl_y
	DEC harry_tr_y
	DEC harry_bl_y
	DEC harry_br_y
ReadDownDone:

ReadLeft: 
	LDA joypad1     ; player 1 - A
	LSR A
	BCS HandleLeft
	JMP ReadLeftDone
HandleLeft:
	INC harry_tl_x
	INC harry_tr_x
	INC harry_bl_x
	INC harry_br_x
ReadLeftDone:

ReadRight: 
	LDA joypad1     ; player 1 - A
	LSR A
	BCS HandleRight
	JMP ReadRightDone
HandleRight:
	DEC harry_tl_x
	DEC harry_tr_x
	DEC harry_bl_x
	DEC harry_br_x
ReadRightDone:


;Loop the input checking
	JMP update_joypad


;If start is pressed continue on
HandleSelect:
	

