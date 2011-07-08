/*
 * Taster.asm
 *
 *  Created: 07.07.2011 12:00:00
 *   Author: DH
 *   Taster an PortD 4 mit internem Pullup 
 *   Ausgang an PortB 1 wird getoggelt
 */ 


 .def key_old = r3					; Warum nicht r1 ? 
 .def key_now = r4					; und nicht r2
 .def temp1   = r16					; Hilfsvar

 .include "m168def.inc"

 ldi	r16, 0xFF
 out	DDRB, r16					;PortB Ausgang

 ldi	r16, 0x00 
 out	DDRD, r16					;PortD Eingang

 ldi	r16, 0xFF
 out	PORTB, r16					;PortB 0 (alle aus)

 sbi	PORTD, 4					;PortD 4 auf eins, Interner Pullup aktiviert 
 ;ldi	r16, 0xFF 
 ;out    PortD, r16					;PortD auf eins, Interne Pullups aktiviert 
 ;ldi	temp1, 0x00					; Tasterzuzstand auf 0
 mov  key_old, temp1				; Tasterzustand beim Start

 loop:  
        in key_now, PinD			; Aktueller Tasterzustand
		mov temp1, key_now			; Key_now in Temp1 sichern
		eor  key_now, key_old		; Kontrolle auf Änderung mit Exklusiv Oder 
        mov  key_old, temp1			; Den aktuellen Tasterzustand in Temp1 speichern

		breq loop					; Das Ergebnis des XOR auswerten, keine Veränderung Schleife erneut durchlaufen.

		and  temp1, key_now			; War das ein 1->0 Übergang, wurde der Taster also
									; gedrückt (in key_now steht das Ergebnis vom XOR)
        brne loop					; 
                
	    sbi PinB, 3					; Bit PinB 3 toggeln 

        rjmp loop					; Endlosschleife in Loop
