
;WAIT FOR VBLANK
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)

;DISABLE PPU
	LDA #%00000000
	STA $2001
	
;POPUNI NAAMETABLE 1
	;ubaci lowr i highr memory address od splash screen data adrese
	LDA #<IntroScreenData
	STA world
	LDA #>IntroScreenData	
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
LoadIntroScreen:
	LDA (world), Y	;() <- address
	STA $2007	;put in PPU memory
	INY	
	CPX #$03
	BNE :+
	CPY #$C0
	BEQ DoneIntroScreen
:
	CPY #$00
	BNE LoadIntroScreen
	INX
	INC world+1
	JMP LoadIntroScreen		

;LOAD NAMETABLE 2
;LOAD NAMETABLE 2
;LOAD NAMETABLE 2 za skrolling

DoneIntroScreen:
;WAIT FOR VBLANK
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)
;Enable PPU
	LDA #%00011110
	STA $2001	;PPUMASK
	;...



;Load Sprites

	LDX #$00	
sprite_load:
	;byte0 - Y coordinate
	;byte1 - index number of sprite in main.chr
	;byte2 - attributes...
	;byte3 - X coordinate
	LDA sprite_data, X
	STA $0200, X		;adresa koju sam odredio da je sprite data
	INX
	CPX #$40	;svaki sprite se sastoji od 4 byte-a, ispisao sam to gore
	BNE sprite_load



;DODAJ MEHANIKU ZA INTRO IGRICU
;OVO RADIM DA BIH NAUCIO ANIMACIJU I NEKE EFEKTE
;READ IO
;READ IO
;READ IO
;READ IO za harrija

updatejoypad:
       NOP
       LDA #1
       STA $4016
       LDA #0
       STA $4016
 
       LDA joypad1
       NOP
       LDA joypad1
       NOP
       LDA joypad1
       NOP
       LDA joypad1
       NOP
;parsujes start
       LSR
       BCS splash_end
       JMP updatejoypad
       LDA joypad1
       LDA joypad1
       LDA joypad1
       LDA joypad1

splash_end:
       LDA #$46
       STA $0000
       ;... continue


;.include "wait_1_second.asm"
