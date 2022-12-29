; Gamecoding course ZX81 machinecode




; Base model for optimal ZX81 code in lowres 

; 12 bytes from #4000 to #400B free reuseble for own "variables"

	org #4009

; in LOWRES more sysvar are used, but in this way the shortest code
; over sysvar to start machinecode. This saves 11 bytes of BASIC

; DO NOT CHANGE AFTER BASIC+3 (=DFILE)
basic   ld h,dfile/256			; highbyte of dfile
        jr init1

	db 236				; BASIC over DFILE data
	db 212,28			
	db 126,143,0,18

eline	dw last
chadd	dw last-1
        db 0,0,0,0,0,0			; x
berg	db 0				; x

mem	db 0,0				; x OVERWRITTEN ON LOAD

init1	ld l, dfile mod 256		; low byte of dfile
	jr init2			
		
lastk	db 255,255,255
margin  db 55

nxtlin  dw basic			; BASIC-line over sysvar	

flagx   equ init2+2
init2	ld (basic+3),hl			; repair correct DFILE flagx will be set with 64, the correct value

	db 0,0,0			; x used by ZX81, not effective code after loading
	db 0,0,33			; skip frames with LD HL,NN

frames  dw 65535

	jp gamecode			; YOUR ACTUAL GAMECODE, can be everywhere
	db 0,0

cdflag  db 64
; DO NOT CHANGE SYSVAR ABOVE!

; free codeable memory
gamecode

waitforkey
	ld a,0
	in a,(254)
	cpl
	and %00011111
	jp z, waitforkey

; clear message
	ld bc,#0305
	call field
	ld b,11				; number of chars to clear
loop_clear
	ld (hl),128
	inc hl
	djnz loop_clear


	ld bc,#0101			; B=1, C=1, first position on the screen
newdot
	push bc				; save xy player 
	call rnd			; get a random number	
	ld b,a				; set as Y
	call rnd			; get a next random number
	ld c,a				; st as X
	call field
	ld (hl),27+128		; place an inverted dot
	pop bc				; get xy player

moveloop
	call field
	ld (hl),"O"+101	; we write a "O" INVERTED on the screen

	push hl	
	ld hl,frames		; make hl point to the timecounter
	ld a,(hl)		; get the timecounter in A
	sub 2			; take of 2, the number we want to test
wfr
	cp (hl)			; test if the value is the same
	jr nz,wfr		; NOW WE WAIT UNTIL FRAMES MATCHES A!
	pop hl

	push bc			; NOW WE NEED TO SAVE BC!

wkey
	ld bc,(lastk)		; get key information
	ld a,c			; copy C in A to keep C
	inc a			; Test if NOKEY pressed
	jr z,wkey		; NO KEY, wait for key

	ld (hl),128		; we pressed a key, so we erase the old position

	call #7bd		; BC holds info about key, ROM can translated this here
	pop bc
	ld a,(hl)		; get character

	cp "O"-27		; did we press the "O"?
	jr nz,right		; we didn't go left
left
	dec c
	jr nz,okmove
	inc c			
	jr okmove
right
	cp "P"-27		; did we press "P", right
	jr nz,up		
	inc c			; move right
	ld a,c			; get new position
	cp 21			; test out of screen
	jr nz,okmove		; if not, move allowed
	dec c
	jr okmove
up
	cp "A"-27
	jr nz,down
	dec b
	jr nz,okmove
	inc b			
	jr okmove
down
	cp "Q"-27		; did we press "A", down
	jr nz,okmove		
	inc b			; move down
	ld a,b			; get new position
	cp 21			; test out of screen
	jr nz,okmove		; if not, move allowed
	dec b
okmove
	jr moveloop		; stay in playloop
		

; BC = XY, return HL=field on screen
field
	push bc			; save Y and X
	ld hl,screen-21-1	; always 1xY and 1xX added, line is 20+HALT
	ld de,21		; the size of 1 line (20 + HALT)
frow
	add hl,de		; add rows until B=0
	djnz frow		; DEC B, JR NZ frow
	add hl,bc		; B now 0, C is X, so HL now field on screen
	pop bc			; get back original Y X
	ret

rnd
	ld de,0			; get the pointer in ROM
	ld hl,(frames)		; for randomness get framecounter
	add hl,de		; add framecounter
	dec hl			; when framecounter is unchanged make sure a change is done
	ld a,h			; H can have any value, but ROM is #0000-#1FFF
	and #0f			; only #0000-#0f00 is what we use
	ld h,a			; set pointer back within ROM
	ld (rnd+1),hl		; save current pointer (selfmodifying code!!!)
	ld a,(hl)		; get value in ROM
range
	sub 20			; we need 0-19 only
	jr nc,range
	adc a,20		; undo last subtraction, range 1-20
	ret			; back to mainprogram


; the display file, Code the lines needed.
dfile 	db 118

; each line has text and a Newline
screen
	block 20, 128	; block places 20x character 128,inverted space
	db 118
	block 20, 128
	db 118
	block 4, 128
	db "P"+101,"R"+101,"E"+101,"S"+101,"S"+101, 128,"A"+101,128,"K"+101,"E"+101,"Y"+101
	block 5, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118
	block 20, 128
	db 118

; this byte fills the unused part of the screen
	jp (hl)
	
vars    db 128
last	equ $   	

end                	