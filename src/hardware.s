; Hardware initialization for ADC and GPIO
; Initialize RA0 to RA3 & RA5 as ADC channels
; Set RB0 to RB6 as GPIO outputs for LCD pins

#include "inc/p16f72.inc"

    CODE

GLOBAL HARDWARE_INIT

HARDWARE_INIT:
; ADC Configuration
; RA0-AN0, RA1-AN1, RA2-AN2, RA3-AN3, RA5-AN4
    MOVLW   0x00            ; ADCON1: All ADC pins analog (AN0-AN4)
    MOVWF   ADCON1

; Port A Configuration (ADC inputs)
    MOVLW   0x3F            ; TRISA: RA0-RA5 inputs
    MOVWF   TRISA

; Port B Configuration (GPIO outputs)
    MOVLW   0x80            ; TRISB: RB0-RB6 outputs, RB7 input
    MOVWF   TRISB

; Clear ports to start low
    CLRF    PORTA
    CLRF    PORTB

    RETURN

END