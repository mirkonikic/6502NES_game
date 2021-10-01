;Attributes
	;000000xx - color palette
	;000xxx00 - not used
	;00x00000 - priority bit (1 displays sprite behind, 0 front)
	;0x000000 - Flips sprite horizontally (1 is flipped)
	;x0000000 - Flips sprite vertically (1 is flipped)

;	Sprite Memory : $0200
;0200 - harry tl
;0201 - herry tr
;0202 - harry bl
;0203 - harry br
;
;
;
;

sprite_data:
;intro:
	;harry falls from top
	;squishes OF letters and stands on them
	;press start to play blinking
	;when pressed letters fall
	;second later harry does too
harry_data:
        .byte   $68, $e3, $00, $5C
        .byte   $68, $e4, $00, $64
        .byte   $70, $f3, $00, $5C
        .byte   $70, $f4, $00, $64

title_game:
        .byte   $68, $47, $00, $6C
        .byte   $68, $41, $00, $74
        .byte   $70, $4D, $00, $6C
        .byte   $70, $45, $00, $74

title_of:
        .byte $68, $4f, $00, $7E
        .byte $70, $46, $00, $7E


title_life:
        .byte   $68, $4C, $00, $88
        .byte   $68, $49, $00, $8F
        .byte   $70, $46, $00, $88
        .byte   $70, $45, $00, $8F

press_start_to_play:

made_by_mirko:

block_data:
zero:
        .byte   $08, $10, $00, $78
o_br:
        .byte   $08, $11, $00, $80
o_bl:
        .byte   $08, $12, $00, $82
o_tr:
        .byte   $08, $14, $00, $84
o_tl:
        .byte   $08, $18, $00, $86
t_b:
        .byte   $08, $13, $00, $88
t_l:
        .byte   $08, $15, $00, $90
t_r:
        .byte   $10, $20, $00, $92
t_u:
        .byte   $10, $22, $00, $94
t_d:
        .byte   $10, $19, $00, $96
t_nd:
        .byte   $10, $16, $00, $98
full:
        .byte   $10, $1f, $00, $9f

