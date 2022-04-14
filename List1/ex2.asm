;
; AssemblerApplication1.asm
;
; Created: 3/20/2022 10:33:57 PM
; Author : arkad
.cseg
.org 0x0000
jmp start
.equ adr_c = 0x100
.equ dno_stosu = 0x500

.org 0x100
tab_c: .db 0b00000001, 0b00000010, 0b00000011, 0b00000100, 0b00000101, 0b00000110, 0b00000111, 0b00001000, 0b00001001, 0b00001010, 0b00001011, 0b00001100, 0b00001101, 0b00001110, 0b00001111 ;za?adowanie danych do tablicy

.org 0x150
start:
	;implementacja stosu
	ldi r17, low(dno_stosu) 
	out spl,r17
	ldi r17,high(dno_stosu)
	out sph,r17

	;przygodowanie rejestrów pary Z do rozkazu lpm
    ldi zl,low(adr_c<<1) 
	ldi zh,high(adr_c<<1)

	;przygotowanie portów wyj?cia wej?cia
	ldi r16,0xff ;portc - diody
	out ddrc,r16
	ldi r16,0
	out ddrb,r16 ;portb - przycisk
	ldi r18,0xff 
	out portb,r18 
	out portc,r18

main:
	;przygodowanie rejestrów pary Z do rozkazu lpm
	ldi zl,low(adr_c<<1) 
	ldi zh,high(adr_c<<1)
	ldi r18, 0	
	call odczytanie_numeru_przycisku
	mov r24,r23
	mov r17,r16
	call odczytanie_z_tablicy
	call wyswietl
	jmp main

;-----------------------ODCZYTANIE NUMERU PRZYCISKU--------------------------------
.org 0x200
odczytanie_numeru_przycisku:

		in r16,pinb ;sprawdzenie stanu przycisków
		com r16 ;negacja bitowa stanu przycisków		
		mov r20, r16
		ldi r21, 0x04 ;licznik powtorzen
		ldi r23, 0x00 ;licznik ilosci wcisnietych przyciskow
		jmp petla

petla:	
		cpi r21,0x00 ;petla wykona sie wartosc r21 razy
		breq koniec_pet ;je?eli p?tla wynona?a si? 8 razy sprawdzamy dane
		ror r20 ;przesuwamy dane w prawo
		dec r21 ;zmniejszamy ilo?? powtórze?
		brcs wcisniety_przycisk ;je?eli wci?ni?ty to skok
		jmp petla ;zap?tlenie 
		
wcisniety_przycisk:
		clc
		inc r23 ;zwi?kszam ilo?? wcisnietych przycisków
		brne petla ;jesli tak to skok do p?tla
		jmp petla ;do p?tli

koniec_pet:
		ret


;---------------------------WYCI?GNI?CIE DANYCH Z TABLICY NA PODSTAWIE NUMERU PRZYCISKU-------------------------------------
odczytanie_z_tablicy:
	dec r16
	add zl, r16
	ldi r16, 0
	adc zh, r16
	lpm r18, z
	ret
;--------------------------WY?WIETLENIE DANEJ--------------------------------------------------------------------------
wyswietl:
	cpi r23, 0x00
	breq zgas
	cpi r17, 16
	brcc zgas
	com r18
	out portc,r18
	ret

zgas:
	ldi r18,0xff
	out portc, r18
	ret