
;WAIT FOR VBLANK
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)

;DISABLE PPU
	LDA #%00000000
	STA $2001
	
	;ubaci lowr i highr memory address od splash screen data adrese
	LDA #<InfoScreenData
	STA world
	LDA #>InfoScreenData	
	STA world+1

	;setup PPU for address which we want to populate (nametable)
	BIT $2002	;similar to read, but faster since its 1 bit
	LDA #$20
	STA $2006
	LDA #$00
	STA $2006
;if by accident you write in wrong address to $2006
;by reading from $2002, it will reset the PPU so that you can write again

	;clear X and Y
	LDX #$00
	LDY #$00
	
	;load PPU
LoadInfoScreen:
	LDA (world), Y	;() <- address
	STA $2007	;put in PPU memory
	INY	
	CPX #$03
	BNE :+
	CPY #$C0
	BEQ DoneInfoScreen

:
	CPY #$00
	BNE LoadInfoScreen
	INX
	INC world+1
	JMP LoadInfoScreen		

DoneInfoScreen:
;WAIT FOR VBLANK
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)
;Enable PPU
	LDA #%00011110
	STA $2001	;PPUMASK
	;...




;Mora ovde jer iznad nije radio PPU, pa ne uradi nista
;CLEAR SPRITE MEMORY
	LDX #$00
	LDA #$FF
ClearSprites:
	STA $0200, X	;0200->02FF
	INX
	BNE ClearSprites ;Kada se desi roll over sa FF na vrednost 00, registera X, tada se podesi Zero Flag, jer je rezultat operacije bio 0