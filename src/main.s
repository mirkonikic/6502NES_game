;CPU MEMORY MAP
;$0000 - $00FF 	-  Zero Page
;$0100 - $01FF	-  Stack Memory
;$0200 - $07FF	-  RAM
;$0800 - $0FFF	-  mirror 0000-07FF
;$1000 - $17FF	-  mirror -||-
;$1800 - $1FFF	-  mirror -||-
;$2000 - $2007	-  I/O Registers
;$2008 - $3FFF	-  mirror 2000-2007
;$4000 - $401F	-  I/O Registers
;$4020 - $5FFF	-  Expansion ROM - to expand VRAM
;$6000 - $7FFF	-  SRAM - Used to save ram between gameplays
;$8000 - $FFFF	-  PRG-ROM
;$FFFA - $FFFB	-  NMI Interrupt handler routine
;$FFFC - $FFFD	-  Power on reset handler routine
;$FFFE - $FFFF	-  Break instruction handler routine

;PPU MEMORY MAP
;$2000 - PPU Control Register 1 - write only
;$2001 - PPU Control Register 2 - write only
;$2002 - PPU Status Register - read only
	;Video Control
;$2003 - Sprite Memory Address - write only
;$2004 - Sprite Memory Data - write/read
;$2005 - Background Scroll - write
;$2006 - PPU Memory Address - write
;$2007 - PPU Memory Data - read/write

;Joystick
;$4016 - Joystick 1 - read/write
;$4017 - Joystick 2 - read/write

; $ - denotes a hexadecimal address
; % - denotes a binary address
; # - denotes an immediate value
; #$ - denotes an immediate hex value
; #% - denotes an immediate binary value

;3 different interrupts: NMI ($FFFA), Reset Vector ($FFFC), BRK/IRQ ($FFFE)

;Byte     Contents
;---------------------------------------------------------------------------
;0-3      String "NES^Z" used to recognize .NES files.
;4        Number of 16kB ROM banks.
;5        Number of 8kB VROM banks.
;6        bit 0     1 for vertical mirroring, 0 for horizontal mirroring.
;         bit 1     1 for battery-backed RAM at $6000-$7FFF.
;         bit 2     1 for a 512-byte trainer at $7000-$71FF.
;         bit 3     1 for a four-screen VRAM layout. 
;         bit 4-7   Four lower bits of ROM Mapper Type.
;7        bit 0     1 for VS-System cartridges.
;         bit 1-3   Reserved, must be zeroes!
;         bit 4-7   Four higher bits of ROM Mapper Type.
;8        Number of 8kB RAM banks. For compatibility with the previous
;         versions of the .NES format, assume 1x8kB RAM page when this
;         byte is zero.
;9        bit 0     1 for PAL cartridges, otherwise assume NTSC.
;         bit 1-7   Reserved, must be zeroes!
;10-15    Reserved, must be zeroes!
;16-...   ROM banks, in ascending order. If a trainer is present, its
;         512 bytes precede the ROM bank contents.
;...-EOF  VROM banks, in ascending order.
;---------------------------------------------------------------------------

;P (status register)	N V   B D I Z C		#5 IS UNUSED
;			0 0 0 0 0 0 0 0
;			7 6 5 4 3 2 1 0

;ROM - game code or graphics
;RAM - program memory, code for the game as in running process
;CHR - character memory, data for graphics
;CPU - central processing unit
;PPU - picture processing unit, graphics chip
;APU - audio processing unit

;RAM map
;$0000 - $00FF	Zero Page
;$0100 - $019F	Data to be copied to nametable during next VBLANK
;$01A0 - $01FF	Stack
;$0200 - $02FF	Data to be copied to OAM during next VBLANK
;$0300 - $03FF	Variables used by sound player
;$0400 - $07FF	Arrays and less often accessed global variables

;OAM - Memory inside PPU that contains a display list of up to 64 sprites, where each sprite occupies 4bytes, byte0 - Yposition of sprite, byte1 - index number of sprite in selected pattern table in PPUCTRL register, byte2 - attributes, byte3 - Xposition of sprite			Sprites are numbered 0-63: sp0:00-03, sp1:04-07...

;nametable - 1024 byte area of memory used by PPU to lay out backgrounds. Each byte in the nametable controls one 8x8 pixel, character cell, and each nametable has 30rows of 32tiles each, for 960 bytes. The rest is used by each nametables attribute table. 
;|$2000|$2400|
;-------------
;|$2800|$2C00|

;attribute table - 64 byte array at the end of each nametable that controls which palette is assigned to each part of background, each starting at: $23C0, $27C0, $2BC0, $2FC0 respectively, colors in order of: xx000000 - top left, 00xx - top right, bottom left and bottom right

;character - CHR - 

;iNES header
.segment "HEADER"
	;0->3 Must not be modified
	.byte "NES"	;NES magic number
	.byte $1A	;Necessary character break

	;4->8->15 Can be modified
	.byte $02	;Number of PRG-ROM blocks(size in units of 16kB)
	.byte $01	;Number of CHR-ROM blocks(size in units of 8kB)
	
	;flag6: lsb 		- mirroring(0=h, 1=v)
	;	000000x0	- cartridge contains battery backed RAM (1)
	;	00000x00	- 512 byte trainer at $7000-$71FF (1)
	;	0000x000	- Ignore mirroring control, provide four VRAM(1)
	;	xxxx0000	- lower byte nibble of the mapper number
	.byte %00000001	;Lower half of mapper number & flags
	;flag7
	;	0000000x	- VS Unisystem (1)
	;	000000x0	- PlayChoice-10 (1)
	;	0000xx00	- if eq 2, 8-15 are in NES 2.0 format
	;	xxxx0000	- Upper nibble of mapper number
	.byte %00000000	;Upper half of mapper number & flags
	
	;Not used, must be filled with all zeros
	.byte $00, $00, $00, "M", "I", "R", "K", "O"

.include "alias.asm"
.segment "ZEROPAGE"
world: .res 2	;16 bit addressing to load map
button_state: .res 1	;8 bits to store button information
sel_x: .res 1	;reserve 1 byte for x axis of selected cell
sel_y: .res 1	;reserve 1 byte for y axis of selected cell

.segment "STARTUP"
RST:
	SEI	;Disables all interrupts
	CLD	;disable decimal mode, NES doesnt, but 6502 does

	;Disable sound IRQ (Interrupt request)
	LDX #$40	;if bit 6 is set 1, audio is disabled 01000000
	STX $4017	;APU Frame Counter

	;Initialize stack register
	LDX #$FF	;Because stack starts at $0100 and ends at $01FF so when we set S (stack pointer) to point to FF, it decreases to FE, than FD...
	TXS		;Move data from X to S register, now PHA and PLA

	INX		;Zero out X
	;Set PPU Registers
	STX $2000	;PPUCTRL
	STX $2001	;PPUMASK
	STX $4010	;Disable PCM Channel, so we dont get weird sounds

	;wait for PPU init, try to draw something
	;read from $2002, PPUSTATUS, bit 7 shows if we are in VBLANK
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)
	
	AND #$00	;Clear out the A register
	
	;Clear out the memory
clearmemory:
	STA $0000, X	;0000->00FF
	STA $0100, X	;0100->01FF
	STA $0200, X	;...
	STA $0300, X	;
	STA $0400, X	;
	STA $0500, X	;
	STA $0600, X	;
	STA $0700, X	;0700->07FF	;0800 je kraj RAM memorije
	
	;PPU Update, deo memorije koji sadrzi Sprites, zato necemo 0
	LDA #$FF
	STA $0200, X	;0200->02FF
	LDA #$00	

	INX
	BNE clearmemory ;Kada se desi roll over sa FF na vrednost 00, registera X, tada se podesi Zero Flag, jer je rezultat operacije bio 0

	;PPU memorija mora da se refreshuje svaki frejm jer postoji memory decay, zbog kog se gube vrednosti u memoriji ako se ne refreshuje duze vreme

	;Read VBLANK Again, to make sure its realy ready
:	
	LDA $2002
	AND #%10000000
	BPL :-		;branch if positive, :- (branch to previous label)

	;Updating Sprite memory
	LDA #$02	;most significant memory
	STA $4014 	;Ubaci high byte of display address, onda ce $0200-$02ff biti prebacen u OAM
	NOP		;da bi sacekali da PPU prebaci dspmem u OAM
	
;PPU memory map
;$0000-$0FFF	pattern table 0
;$1000-$1FFF	pattern table 1
;$2000-$23FF	nametable 0
;$2400-$27FF	nametable 1
;$2800-$2BFF	nametable 2
;$2C00-$2FFF	nametable 3
;$3000-$3EFF	mirror 2000-2eff
;$3F00-$3F1F	palette RAM indexes
;$3F20-$3FFF	mirrors 3f00-3f1f
	;CPU ne moze da upisuje u VRAM od PPU-a, pa je potrebno preko registara da kaze gde u PPU-u zeli da pise, prvo pisati u PPUADDR addressu, gornji i donji byte addresse koja je 16bit addressa zbog 16 bit magistrale, pa ponovno pise u PPUDDATA da popuni VRAM, valid addresses are 0000-3FFF 
	;Palette information
	LDA #$3F	;higher byte of address
	STA $2006
	LDA #$00	;lower byte of address
	STA $2006
	
	LDX #$00	;loop counter
palette_load:
	;two sets of pallets bckg and front, (4x4pallets)x2sets - 32 colors, 0 is bckg always
	LDA palette_data_bckg, X	;preci ce u sprite data	
	STA $2007
	INX
	CPX #$20	;32 decimal
	BNE palette_load

	;Kako sam podesio u $4014 da display memory bude u #$20 high byte-u, znaci da ce 2000-20ff biti sprite data memory


;LoadPalette
;LoadSprites
;LoadBackgroundNameTable
;LoadAttributesForNameTable


;OBRISAO SAM PRETHODNO UCITAVANJE SPRITEOVA
;JER SAD TO RADIM KAD KRENE IGRICA


;splash screen load?
;.include "splash_screen.asm"

;Enable interrupts, da bi PPU krenuo da crta
	CLI
	LDA #%10010000	
	;First bit: Generate NMI on start of every VBLANK
	;Second bit: Sprite size - (0)8x8, (1)8x16, bckg uses second charset
	STA $2000	;PPUCTRL register
	;turn on drawing
	LDA #%00011110
	;000 - Emphasize colors
	;First set bit: show sprites
	;Second set bit: show background
	;Third set bit: show sprites in leftmost 8 pixels of screen
	;Fourth set bit: show background in leftmost 8 pixels of screen
	;0 - grayscale (0) normal, (1) gray
	STA $2001	;PPUMASK

setup_controllers:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016

;main loop
splash_screen:
	;MADE BY:
	;MIRKO NIKIC
	;who is part of MIPE STUDIOS
	;CREDITS...
	;
	;THAN SUDDENLY BLACK SCREEN
	.include "splash_screen.asm"

intro:
	;harry falls from top of the screen
	;gets up in middle of screen
	;stands up and other letters appear
	;'press start to play' starts blinking
	.include "intro_screen.asm"

info_tutorial:
	;text about john conway and game of life
	;text on how to play with images
	;press start to play
	.include "info_screen.asm"

;set selection panel to top left
;on arrow press, one of these two increases
;and on arrow press, position of mouse sprite changes
;to sel_x and sel_y
	LDX #$00
	STX sel_x
	STX sel_x
start:
	;When start is pressed, letters fall down
	;and harry jumps down
	;Than CONWAYS GAME OF LIFE, appears on top
	;by Mirko Nikic appears on bottom next to harry
	;Cell table appears in middle of the screen taking most of the space
	;With A, you make cell alive
	;With B, you make cell dead
	;With Start you play the game
	;With Select you pause the game
	.include "setup_screen.asm"

gameplay:
	;cells are drawn, also pointer to select which are alive
	;start to play, exit to go back to intro
	;if start is pressed, every frame, every cell is stored as a bit
	;since it can be alive or dead, it will be stored as a seq of bits
	;each one is checked and updated
	.include "gameplay_screen.asm"
Loop:
;Init Code -> Infinite Loop -> NMI -> Graphics Updates -> Read Buttons -> Game Engine --\


	;Each cell is updated accordingly to the rules

;old version of reading from controller
	.include "readio.asm"	;Read I/O from joypad1
	;.include "parseio.asm"
;faster version of reading from controller and updating character
	;.include "readio2.asm"
	;.include "parseio2.asm"

;try to adjust the framerate
	JMP Loop

NMI:
	;copy data in 0200 to PPU
	LDA #$02	;copy sprite data from $0200 into PPU OAM
	STA $4014
	RTI	;ret interrupt (usually its rts, but for interrupts its rti)

; BCKG COLOR PALLET: A, B, C, D gde svako slovo ima po 4 boje
; FRNT COLOR PALLET: D, E, F, G gde svako slovo ima po 4 boje
;$3F00		Universal background color
;$3F01 - $3F03	Bckg palette 0
;$3F05 - $3F07	Bckg palette 1
;$3F09 - $3F0B	Bckg palette 2
;$3F0D - $3F0F	Bckg palette 3
;$3F11 - $3F13	Sprite palette 0
;$3F15 - $3F17	Sprite palette 1
;$3F19 - $3F1B	Sprite palette 2
;$3F1D - $3F1F	Sprite palette 3

SplashScreenData:
.include "splash_screen.bin"
IntroScreenData:
.include "intro_screen.bin"
.include "palettes.asm"
.include "sprites.asm"

;intro je na sred ekrana stoji ili animirano udje u ekran 
;	OO  GA OF LI	
;	II  ME OF FE

;    press start to play!
;		made by: Mirko Nikic

;odmah po kliku na start se udje u tabelu sa belim poljima
;na strelice mozes da selektujes celiju koju hoces da promenis
;nekako cuvam sta je selektovano i svaki frejm azuriram celije po pravilu

;	O O O
;	O x O
;	O O O

;	16 bitova potrebno za igru sa 16 celija, 0 ili 1
;	x x x x
;	x x x x
;	x x x x
;	x x x x

;	8x8 is one sprite, 64 sprites can fit the screen
;	8 vertical x 8 horisontal


;IF	komsije >= 4, celija umire od prenaseljenosti

.segment "VECTORS"
	.org $FFFA	
	.word NMI
	.word RST
	;defined break interrupt, not using it

.segment "CHARS"
	;.incbin "../chr/main.chr"
	;.incbin "../chr/gof_nes.chr"
	.incbin "../chr/gof.chr"
