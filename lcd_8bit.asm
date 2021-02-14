

;********************************************************************************
;********************************************************************************
;15/12/2010
;HD44780 LCD ekrana 8-bit data ile "Musa Cufalci" yazar.
;HD44780 writes "Musa Cufalci" to the LCD screen with 8-bit data.
;********************************************************************************
;********************************************************************************

	title		"lcd_8bit.asm 8-bit data kontrol"
	list		p=16F84
	#include	"P16F84.inc"

__CONFIG 	_CP_OFF&_WDT_OFF&_PWRTE_ON&_XT_OSC

cntl		equ	0x10
cnth		equ	0x11
cx		equ	0x12
vericnt equ	0x13
RS		equ	0x00
RW		equ	0x01
EN		equ	0x02

		org 0x00
		
basla;********************************************************************
		call	kurulum
		call	lcd_reset
		call	clear
		call	iki_satir
		call	display_on
		call	cursor_inc
		call	clear
		call	mesaj
tekrar	goto	tekrar 


kurulum;******************************************************************

		bsf 	STATUS,RP0		;Bank 1'e geç
		clrf	TRISA
		clrf	TRISB
		bcf	STATUS,RP0		;Bank 0'a dön	
		clrf	vericnt
		return
		
		
clear;*******************************************************************

		call	timer_low		;bekle
		movlw	b'00000001'		;displayi temizle
		movwf	PORTB
		bcf	PORTA,RS		;RS -> komut
		bcf	PORTA,RW		;RW -> yaz
		bsf	PORTA,EN		;--
		nop				;  \
		bcf	PORTA,EN		;   --
		return
		
lcd_reset;****************************************************************

		movlw	b'00000011'
		movwf	cx
nexti	call	timer_low
		bcf	PORTA,RS
		bcf	PORTA,RW
		movlw	0x30
		movwf	PORTB
		bsf	PORTA,EN	;--
		nop			;  \
		bcf	PORTA,EN	;   --
		decfsz	cx,F
		goto	nexti
		return
		
		
iki_satir;******************************************************************

		call	timer_low
		movlw	0x30
		movwf   PORTB
		bcf	PORTA,RS	;RS -> komut
		bcf	PORTA,RW	;RW -> yaz
		bsf	PORTA,EN	;--
		nop			;  \
		bcf	PORTA,EN	;   --
		return
		
cursor_inc;******************************************************************

		call	timer_low
		movlw	0x06
		movwf   PORTB
		bcf	PORTA,RS	;RS -> komut
		bcf	PORTA,RW	;RW -> yaz
		bsf	PORTA,EN	;--
		nop			;  \
		bcf	PORTA,EN	;   --
		return
		
display_on;******************************************************************

		call	timer_low
		movlw	0x0E
		movwf   PORTB
		bcf	PORTA,RS	;RS -> komut
		bcf	PORTA,RW	;RW -> yaz
		bsf	PORTA,EN	;--
		nop			;  \
		bcf	PORTA,EN	;   --
		return
		
		
mesaj;******************************************************************

m_devam	call	timer_low
		bsf	PORTA,RS	;RS <- veri
		bcf	PORTA,RW	;RW -> yaz
		movf	vericnt,W
		call	mesaj_verisi
		iorlw	0
		bz	m_son
		movwf	PORTB
		incf	vericnt,1
		bsf	PORTA,EN	;--
		nop			;  \
		bcf	PORTA,EN	;   --
		goto	m_devam
m_son	return



mesaj_verisi;******************************************************************

		addwf	PCL,1
		retlw	"M"
		retlw	"u"
		retlw	"s"
		retlw	"a"
		retlw	" "
		retlw	"C"
		retlw	"u"
		retlw	"f"
		retlw	"a"
		retlw	"l"
		retlw	"c"
		retlw	"i"
		retlw	0
		
		
timer_low;******************************************************************
		movlw	0xff
		movwf	cnth
dongu2		movlw	0xff
		movwf	cntl
dongu1		decfsz	cntl,F
		goto	dongu1
		decfsz	cnth,F
		goto	dongu2
		return
		end
		
;********************************************************************************
;********************************************************************************
		
		
		
		
	

