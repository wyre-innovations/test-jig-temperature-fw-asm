; LCD task for displaying temperature data

#include "inc/device.inc"
#include "inc/p16f72.inc"

    CODE

EXTERN LCD_CLEAR, LCD_SEND_STRING, LCD_PRINT, ADC_VALUES

GLOBAL LCD_TASK_SETUP, LCD_TASK_LOOP

; Messages
MSG_LINE1:
    DB '1'
    DB ':'
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB '2'
    DB ':'
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB 0
MSG_LINE2:
    DB '3'
    DB ':'
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB '4'
    DB ':'
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB 0
MSG_LINE1_ALT:
    DB '5'
    DB ':'
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB 0
MSG_LINE2_ALT:
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB ' '
    DB 0

; Temporary variables
TEMP EQU 0x20
TEMP2 EQU 0x21
DISPLAY_ROUND EQU 0x23

LCD_TASK_SETUP:
    ; LCD already initialized in app.s
    CALL    LCD_CLEAR
    CLRF    DISPLAY_ROUND
    RETURN

LCD_TASK_LOOP:
    ; Format and display temperatures
    CALL    FORMAT_DISPLAY

    ; Toggle display round
    MOVF    DISPLAY_ROUND, W
    XORLW   1
    MOVWF   DISPLAY_ROUND

    ; Delay 2 seconds
    MOVLW   0xC8
    CALL    DELAY_MS

    RETURN

; Format display subroutine
FORMAT_DISPLAY:
    MOVF    DISPLAY_ROUND, W
    BTFSC   STATUS, Z
    GOTO    DISPLAY_FIRST_SET

    ; Display second set (temperature 5)
    MOVLW   HIGH(MSG_LINE1_ALT)
    MOVWF   PCLATH
    MOVLW   LOW(MSG_LINE1_ALT)
    MOVWF   FSR
    MOVLW   0
    MOVWF   TEMP    ; pos_x
    MOVLW   0
    MOVWF   TEMP2   ; pos_y
    CALL    LCD_PRINT

    MOVLW   HIGH(MSG_LINE2_ALT)
    MOVWF   PCLATH
    MOVLW   LOW(MSG_LINE2_ALT)
    MOVWF   FSR
    MOVLW   1
    MOVWF   TEMP    ; pos_x
    MOVLW   0
    MOVWF   TEMP2   ; pos_y
    CALL    LCD_PRINT
    RETURN

DISPLAY_FIRST_SET:
    ; Display first set (temperatures 1-4)
    MOVLW   HIGH(MSG_LINE1)
    MOVWF   PCLATH
    MOVLW   LOW(MSG_LINE1)
    MOVWF   FSR
    MOVLW   0
    MOVWF   TEMP    ; pos_x
    MOVLW   0
    MOVWF   TEMP2   ; pos_y
    CALL    LCD_PRINT

    MOVLW   HIGH(MSG_LINE2)
    MOVWF   PCLATH
    MOVLW   LOW(MSG_LINE2)
    MOVWF   FSR
    MOVLW   1
    MOVWF   TEMP    ; pos_x
    MOVLW   0
    MOVWF   TEMP2   ; pos_y
    CALL    LCD_PRINT
    RETURN

; Delay subroutine (ms)
DELAY_MS:
    MOVWF   TEMP3
DELAY_OUTER:
    MOVLW   0xFA
    MOVWF   TEMP2
DELAY_INNER:
    DECFSZ  TEMP2, F
    GOTO    DELAY_INNER
    DECFSZ  TEMP3, F
    GOTO    DELAY_OUTER
    RETURN

TEMP3 EQU 0x22

END