;print splash_screen
	
  ;ispisi "created by MIRKO from MIPE"
  ;blink "press start to continue"

;splash
	;wait on START press	
	;MADE BY:
        ;MIRKO NIKIC
        ;who is part of MIPE STUDIOS
        ;CREDITS...
        ;
        ;THAN SUDDENLY BLACK SCREEN


;intro
	;GAME OF LIFE	:harry:
	;press start to play


;gameplay:
	;background is all tiles
	;sprites are colored ones



	
	;ubaci lowr i highr memory address od splash screen data adrese
	LDA #<SplashScreenData
	STA world
	LDA #>SplashScreenData	
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
LoadSplashScreen:
	LDA (world), Y	;() <- address
	STA $2007	;put in PPU memory
	INY	
	CPX #$03
	BNE :+
	CPY #$C0
	BEQ DoneSplashScreen

:
	CPY #$00
	BNE LoadSplashScreen
	INX
	INC world+1
	JMP LoadSplashScreen		

DoneSplashScreen:
;ispisi press start, to bi trebalo da blinkuje
	;mislim da se to radi sa dva pattern name table-a
;include readio2.asm (faster version)
;parsujes samo
;start press
	;JMP DoneSplashScreen


