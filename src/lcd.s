; LCD driver implementation for 16x2 LCD in 4-bit mode

#include <p16f72.inc>

    CODE

; Pin definitions for LCD
#define LCD_RS          PORTB, 0
#define LCD_EN          PORTB, 1
#define LCD_BACKLIGHT   PORTB, 2
#define LCD_D0          PORTB, 3
#define LCD_D1          PORTB, 4
#define LCD_D2          PORTB, 5
#define LCD_D3          PORTB, 6

; Global declarations
GLOBAL LCD_INIT, LCD_CLEAR, LCD_COMMAND, LCD_DATA, LCD_SEND_STRING, LCD_PRINT

; Delay subroutine (approximate ms delay at 4MHz clock)
; Input: W register = delay in ms
DELAY_MS:
    MOVWF   TEMP
DELAY_LOOP:
    MOVLW   0xFA
    MOVWF   TEMP2
INNER_LOOP:
    DECFSZ  TEMP2, F
    GOTO    INNER_LOOP
    DECFSZ  TEMP, F
    GOTO    DELAY_LOOP
    RETURN

; Write 4 bits to LCD data pins
; Input: W register = 4-bit data
LCD_WRITE_4BITS:
    BCF     LCD_RS          ; RS low for command
    MOVWF   TEMP
    BTFSC   TEMP, 0
    BSF     LCD_D0
    BTFSS   TEMP, 0
    BCF     LCD_D0
    BTFSC   TEMP, 1
    BSF     LCD_D1
    BTFSS   TEMP, 1
    BCF     LCD_D1
    BTFSC   TEMP, 2
    BSF     LCD_D2
    BTFSS   TEMP, 2
    BCF     LCD_D2
    BTFSC   TEMP, 3
    BSF     LCD_D3
    BTFSS   TEMP, 3
    BCF     LCD_D3
    CALL    LCD_PULSE_ENABLE
    RETURN

; Pulse enable pin
LCD_PULSE_ENABLE:
    BSF     LCD_EN
    MOVLW   1
    CALL    DELAY_MS
    BCF     LCD_EN
    MOVLW   1
    CALL    DELAY_MS
    RETURN

; Initialize LCD in 4-bit mode
LCD_INIT:
    MOVLW   20
    CALL    DELAY_MS        ; Wait for LCD to power up

    MOVLW   0x03
    CALL    LCD_WRITE_4BITS
    MOVLW   5
    CALL    DELAY_MS
    MOVLW   0x03
    CALL    LCD_WRITE_4BITS
    MOVLW   1
    CALL    DELAY_MS
    MOVLW   0x03
    CALL    LCD_WRITE_4BITS
    MOVLW   0x02
    CALL    LCD_WRITE_4BITS

    MOVLW   0x28            ; Function set: 4-bit, 2 lines, 5x8
    CALL    LCD_COMMAND
    MOVLW   0x0C            ; Display on, cursor off, blink off
    CALL    LCD_COMMAND
    MOVLW   0x01            ; Clear display
    CALL    LCD_COMMAND
    MOVLW   2
    CALL    DELAY_MS
    MOVLW   0x06            ; Entry mode: increment, no shift
    CALL    LCD_COMMAND

    BSF     LCD_BACKLIGHT   ; Turn on backlight
    RETURN

; Send command to LCD
; Input: W register = command
LCD_COMMAND:
    BCF     LCD_RS
    MOVWF   TEMP
    SWAPF   TEMP, W
    ANDLW   0x0F
    CALL    LCD_WRITE_4BITS
    MOVF    TEMP, W
    ANDLW   0x0F
    CALL    LCD_WRITE_4BITS
    RETURN

; Send data to LCD
; Input: W register = data
LCD_DATA:
    BSF     LCD_RS
    MOVWF   TEMP
    SWAPF   TEMP, W
    ANDLW   0x0F
    CALL    LCD_WRITE_4BITS
    MOVF    TEMP, W
    ANDLW   0x0F
    CALL    LCD_WRITE_4BITS
    RETURN

; Send string to LCD
; Input: FSR = pointer to string
LCD_SEND_STRING:
    MOVF    INDF, W
    IORLW   0
    BTFSC   STATUS, Z
    RETURN
    CALL    LCD_DATA
    INCF    FSR, F
    GOTO    LCD_SEND_STRING

; Print message at position
; Input: W = pos_x (0 or 1), TEMP = pos_y (0-15), FSR = message pointer
LCD_PRINT:
    MOVWF   TEMP3           ; pos_x
    MOVF    TEMP, W         ; pos_y
    SUBLW   15
    BTFSC   STATUS, C
    MOVLW   15
    MOVWF   TEMP

    MOVF    TEMP3, W
    BTFSC   STATUS, Z       ; if pos_x == 0
    GOTO    ROW1
    MOVLW   0xC0            ; Row 2
    GOTO    SET_POS
ROW1:
    MOVLW   0x80            ; Row 1
SET_POS:
    ADDWF   TEMP, W
    CALL    LCD_COMMAND
    CALL    LCD_SEND_STRING
    RETURN

; Clear LCD display
LCD_CLEAR:
    MOVLW   0x01
    CALL    LCD_COMMAND
    MOVLW   2
    CALL    DELAY_MS
    RETURN

; Temporary variables
TEMP    EQU 0x20
TEMP2   EQU 0x21
TEMP3   EQU 0x22

END