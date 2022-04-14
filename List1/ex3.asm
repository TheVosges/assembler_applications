/*
 * AssemblerApplication1.asm
 *
 *  Created: 11.04.2022 08:15:33
 *   Author: student
 */ 
.cseg
.org 0x0000
jmp start
.equ dno_stosu = 0x500

.org 0x150
start:
	;implementacja stosu
	ldi r17, low(dno_stosu) 
	out spl,r17
	ldi r17,high(dno_stosu)
	out sph,r17

	;przygotowanie portÛw wyj?cia wej?cia
	ldi r16,0xff ;portc - diody
	out ddrc,r16
	ldi r16,0
	out ddrb,r16 ;portb - przycisk
	ldi r18,0xff 
	out portb,r18 
	out portc,r18
	ldi r18, 1 ; sta≥a = 1
	ldi r19, 0 ;licznik wciúniÍÊ
	ldi r24, 0b10100000

main:	
	call odczytaj_stabilnie
	cpi r16,0xff
	breq main
	sbrs r16, 0
	add r19, r18
	;sbrs r16, 1
	;sub r19, r18
	mov r23, r19;
	com r23;
	out portc, r23;
	call czy_puszczono
	jmp main

;---------SPRAWDZANIE STANU-------------------
odczytaj_stabilnie: 
	in r16, pinb ;stan bieøπcy
	p1:call del3
	mov r17, r16 ;kopia do stanu poprzedniego 
	in r16, pinb ;stan bieøπcy
	cp r16, r17
	brne p1 
	;sbrs r16, 0
	;add r19, r18
	ret


;------------OP”èNIENIE--------------------
del3: ldi r22,2
del2: ldi r21,0xff
del1: ldi r20, 0xff
wait:
	;zegar 7,3728 MHz
	;392198 takty = ok 53,6 ms
	dec r20 ;1T
	brne wait ;2T/1T
	nop	;1T
	dec r21 ;1T
	brne del1	;2T/1T
	nop	;1T
	dec r22
	brne del2 
	ret

;-------------CZY PUSZCZONO-------------
czy_puszczono:;in r16,pinb
	call odczytaj_stabilnie
	cpi r16, 0xff
	brne czy_puszczono
	ret



