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
	ld hl,screen

moveloop
	push hl				; save our displayposition
	
	ld hl,frames		; make hl point to the timecounter
	ld a,(hl)			; get the timecounter in A
	sub 2				; take of 2, the number we want to test
wfr	cp (hl)				; test if the value is the same
	jr nz,wfr			; NOW WE WAIT UNTIL FRAMES MATCHES A!

	pop hl				; retrieve our displayposition

	ld (hl),"O"-27		; we move a "O" on the screen

wkey
	ld bc,(lastk)		; get key information
	ld a,c				; copy C in A to keep C
	inc a				; Test if NOKEY pressed
	jr z,wkey			; NO KEY, wait for key

	ld (hl),128			; we pressed a key, so we erase the old position

	push hl				; Save screenpointer on stack
	call #7bd			; BC holds info about key, ROM can translated this here
	ld a,(hl)			; After the CALL registercp 128pair HL points to ASCII-character, get characer
	pop hl				; get screenpointer

	cp "O"-27			; did we press the "O"?
	jr nz,right			; we didn't go left

	dec hl				; move 1 position left
	ld a,(hl)			; get next position on the screen 
	cp 128				; test if it is on the screen
	jr z,okmove			; if inverted space, then move is ok
	inc hl				; undo move left
	jr okmove

right
	cp "P"-27			; did we press "P", right
	jr nz,okmove		; if not, movetest done
	inc hl				; move right
	ld a,(hl)			; get new position
	cp 128				; test out of screen
	jr z,okmove			; if not, move allowed
	dec hl				; undo move right
okmove
	jr moveloop		; stay in playloop


; the display file, Code the lines needed.
dfile 	db 118

; each line has text and a Newline
screen
	block 20, 128	; block places 20x character 128,inverted space
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
	block 20, 128
	db 118
	block 20, 128
	db 118

; this byte fills the unused part of the screen
	jp (hl)
	
vars    db 128
last	equ $   	

end                	