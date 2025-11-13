; ADC task for reading temperature sensors

#include <p16f72.inc>

    CODE

GLOBAL ADC_SETUP, ADC_LOOP

; ADC values buffer (5 channels)
ADC_VALUES EQU 0x30 ; 5 bytes starting at 0x30

; Temporary variables
TEMP EQU 0x20
TEMP2 EQU 0x21

ADC_SETUP:
    ; ADC already configured in hardware.s
    RETURN

ADC_LOOP:
    ; Read ADC values for 5 channels
    MOVLW   5
    MOVWF   TEMP    ; Channel count
    MOVLW   ADC_VALUES
    MOVWF   FSR     ; Point to buffer

READ_ADC_LOOP:
    ; Configure ADC channel (simplified - assumes sequential channels AN0-AN4)
    MOVF    TEMP, W
    SUBLW   5
    MOVWF   ADCON0  ; Set channel (AN0=0, AN1=8, etc.)

    ; Start conversion
    BSF     ADCON0, GO

    ; Wait for conversion
ADC_WAIT:
    BTFSC   ADCON0, GO
    GOTO    ADC_WAIT

    ; Store result (8-bit for simplicity)
    MOVF    ADRES, W
    MOVWF   INDF
    INCF    FSR, F

    DECFSZ  TEMP, F
    GOTO    READ_ADC_LOOP

    RETURN

END