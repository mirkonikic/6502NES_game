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

;iNES header
.segment "HEADER"
	;0->3 Must not be modified
	.byte "NES"	;NES magic number
	.byte $1A	;Necessary character break

	;4->8->15 Can be modified
	.byte $01	;Number of PRG-ROM blocks
	.byte $01	;Number of CHR-ROM blocks
	.byte $00	;Lower half of mapper number & flags
	.byte $00	;Upper half of mapper number & flags
	;Not used, must be filled with all zeros
	.byte $00, $00, $00, $00, $00, $00, $00, $00

.segment "ZEROPAGE"

.segment "STARTUP"

.segment "VECTORS"

.segment "CHARS"
