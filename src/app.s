; Main application file

#include "inc/p16f72.inc"

EXTERN HARDWARE_INIT, LCD_INIT, ADC_SETUP, ADC_LOOP, LCD_TASK_SETUP, LCD_TASK_LOOP

; Configuration word
; Adjust config bits to your hardware. These symbols are provided by p16f72.inc.
__config _CP_ALL & _WDT_ON & _BODEN_OFF & _PWRTE_OFF & _HS_OSC

; Reset vector
    ORG 0x0000
    GOTO SETUP

; Interrupt vector (if needed)
    ORG 0x0004
    RETFIE

SETUP:
    CALL HARDWARE_INIT
    CALL LCD_INIT
    CALL ADC_SETUP
    CALL LCD_TASK_SETUP

LOOP:
    CALL ADC_LOOP
    CALL LCD_TASK_LOOP
    GOTO LOOP

END