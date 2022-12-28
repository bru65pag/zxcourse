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
gamecode jr gamecode			; your code, this is example to show this works

; the display file, Code the lines needed.
dfile 	db 118

; each line has text and a Newline
	db 28,29,30,31,32,33,34,35,36,37
	db 28,29,30,31,32,33,34,35,36,37
	db 28,29,30,31,32,33,34,35,36,37
	db 28,29,30,31,32,33,34,35,36,37
	db 118
 	db "T"+101,"E"+101,"S"+101,"T"+101
	db 118

; this byte fills the unused part of the screen
	jp (hl)
	
vars    db 128
last	equ $   	

end                	