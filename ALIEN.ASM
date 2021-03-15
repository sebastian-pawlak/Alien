; "Alien", Atari XL/XE Intro 128B
; (121 bytes of code + 6 bytes of header)
; code by tr1x / Agenda
; requirements: original Atari XL/XE 64KB PAL
; version: 1.0
; release date: 2021-03-13

rtclok	equ $0012
pcolr0	equ $02c0
color0	equ $02c4
chbas	equ $02f4
hposm0	equ $d004
grafm	equ $d011
random	equ $d20a
pmbase	equ $d407
wsync	equ $d40a
vcount	equ $d40b
osgraph	equ $ef9c


	org $0080

start	lda #$02
	jsr osgraph

	lda #$2a		; %00101010
	sta chbas
	sta grafm

	; set color palette
	;ldx #$02		; not necessary, since X=2 after "jsr osgraph"
loopa1	lda colors,x
	sta pcolr0,x
	txa
	sta $be70+20*5+8,x	; head of the alien
	dex
	bpl loopa1

	; initialization of positions of stars
loopb1	lda random
	sta starpos,x
	dex
	bne loopb1

loopc2	ldx vcount
	bne loopc2
loopc3	dec starpos,x
	lda starpos,x	
	ldy #$02
	sta $d01f
	sta wsync
loopc4	sta hposm0,y
	asl
	dey
	bpl loopc4
	dex
	bne loopc3

	sta color0

	; animation of tentacles
	ldx #3
	ldy #4
	bcc skipd1
	inx
	dey	
skipd1	stx $be70+20*6+9
	sty $be70+20*6+10

	bvc loopc2		; jmp loopc2, infinite loop


colors	.byte $2c, $36, $42


	org $2a00+8

alien	.byte $03, $07, $1f, $33, $b1, $ff, $7d, $3f	; head, left
	.byte $c0, $e0, $f8, $cc, $8d, $ff, $be, $fc	; head, right
	.byte $14, $12, $22, $41, $21, $21, $11, $12	; tentacle, left/right
	.byte $14, $24, $48, $48, $26, $11, $11, $22	; tentacle, right/left


	; positions of stars
starpos	equ *+7