/*
 * Timer.asm
 *
 *  Created: 05.07.2011 12:37:56
 *   Author: DH
 *   
 */ 


.include "m168def.inc"
 
.def temp = r16
.def leds = r17
.def zaehl = r18					; Zähler (weiterer delay)
 
.org 0x0000
        rjmp    main                  ; Reset Handler
.org OVF0addr
        rjmp    timer0_overflow       ; Timer Overflow Handler
 
main:
        ; Zähler auf Null
	ldi     zaehl, 0x00

        ; Stackpointer initialisieren
        ldi     temp, HIGH(RAMEND)
        out     SPH, temp
        ldi     temp, LOW(RAMEND)     
        out     SPL, temp
	
        ldi     temp, 0xFF            ; Port B auf Ausgang
        out     DDRB, temp
 
        ldi     leds, 0xFF
 
        ldi     temp, 0b00000101      ;(1<<CS00) CS00 setzen: Teiler 1  | (1<<CS00 | 1<<CS02) Teiler : 1024
        out     TCCR0B, temp	      ; TCCR0B für Prescaler
		 
        ldi     temp, (1<<TOIE0)      ; TOIE0: Interrupt bei Timer Overflow
        sts     TIMSK0, temp	      ; TIMSK
 
        sei
 
loop:   rjmp    loop
 
timer0_overflow:                      ; Timer 0 Overflow Handler
        inc 	zaehl
	CPI 	zaehl, 50	      ; kontrolle r18 = Wert
	breq 	switch                ; wenn ergebniss wahr zu switch
	reti

switch:
        out     PORTB, leds
        com     leds
		ldi zaehl, 0x00
        reti