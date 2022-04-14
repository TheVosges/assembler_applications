/*
 * list1_ex1.asm
 *
 *  Created: 14.03.2022 07:52:55
 *   Author: student
 */ 

 start:
	;stos
	ldi r20, low(RAMEND)
	out spl, r20
	ldi r20, high(RAMEND)
	out sph, r20

	;przygotowanie
	ldi r16, 0xff
	out ddrc, r16
	ldi r16, 0

	;zgaszenie diod
	ldi r17,0xff
	out portc, r17

	ldi r18, 0b00001111
	ldi r19, 0b11110000
	rjmp zapal

zapal:
	out portc, r18
	rjmp del2

del2: ldi r21,0x40
del1: ldi r20, 0xff
wait:
	;zegar 7,3728 MHz
	dec r20 ;1T
	brne wait ;2T/1T
	nop	;1T
	dec r21 ;1T
	brne del1	;2T/1T
	nop	;1T
	; (3*256+1+1+2)*48+1 = 37 056 takty = 5 ms
	rjmp zgas

zgas: 
	out portc, r19
	rjmp del5

del5: ldi r21,0x40
del4: ldi r20, 0xff
wait1:
	;zegar 7,3728 MHz
	dec r20
	brne wait1
	nop
	dec r21
	brne del4
	nop
	rjmp zapal