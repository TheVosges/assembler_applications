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
	rjmp del3

del3: ldi r22,0x25
del2: ldi r21,0xff
del1: ldi r20, 0xff
wait:
	;zegar 7,3728 MHz
	dec r20 ;1T
	brne wait ;2T/1T
	nop	;1T
	dec r21 ;1T
	brne del1	;2T/1T
	nop	;1T
	dec r22
	brne del2
	; (3*256+1+1+2)*256+1 = 197 633 takty = 26,8 ms
	; 26,8 * 37 = ok 1000 ms
	rjmp zgas

zgas: 
	out portc, r19
	rjmp del6

del6: ldi r22,0x25
del5: ldi r21,0xff
del4: ldi r20, 0xff
wait1:
	;zegar 7,3728 MHz
	dec r20
	brne wait1
	nop
	dec r21
	brne del4
	nop
	dec r22
	brne del5
	rjmp zapal