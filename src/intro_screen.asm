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