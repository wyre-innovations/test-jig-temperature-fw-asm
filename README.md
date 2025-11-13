# Test Jig - Temperature (using PIC Assembly)

This firmware implements a temperature monitoring system using 5 ADC channels connected to NTC thermistors, displaying readings on a 16x2 LCD in 4-bit mode.

## Project Structure

```
test-jig-temperature-fw-asm/
├── app.s          # Main application entry point
├── hardware.s     # Hardware initialization (ADC and GPIO)
├── adc_task.s     # ADC reading task
├── lcd_task.s     # LCD display task
├── lcd.s          # LCD driver routines
├── Makefile       # Build configuration
└── README.md      # This file
```

## Pinout

| Pin      | Function     | Description              |
|----------|--------------|--------------------------|
| RA0 (AN0)| ADC Channel  | Temperature Sensor 1     |
| RA1 (AN1)| ADC Channel  | Temperature Sensor 2     |
| RA2 (AN2)| ADC Channel  | Temperature Sensor 3     |
| RA3 (AN3)| ADC Channel  | Temperature Sensor 4     |
| RA5 (AN4)| ADC Channel  | Temperature Sensor 5 (Note: RA4 is not used) |
| RB0      | LCD_RS       | Register Select          |
| RB1      | LCD_EN       | Enable                   |
| RB2      | LCD_BACKLIGHT| Backlight Control        |
| RB3      | LCD_D4       | Data bit 4               |
| RB4      | LCD_D5       | Data bit 5               |
| RB5      | LCD_D6       | Data bit 6               |
| RB6      | LCD_D7       | Data bit 7               |

## Setup Instructions

### Prerequisites
- gpasm (GNU PIC assembler) - Install via Homebrew: `brew install gputils`
- PIC16F72 microcontroller
- 16x2 LCD display (HD44780 compatible)
- 5 NTC thermistors with voltage divider circuits
- PIC programmer (e.g., PICkit, ICD, or custom programmer)

### Building the Firmware

1. Clone or navigate to the project directory:
   ```bash
   cd test-jig-temperature-fw-asm
   ```

2. Build the project:
   ```bash
   make
   ```

   This will generate `app.hex` which can be programmed to the PIC16F72.

3. Clean build artifacts:
   ```bash
   make clean
   ```
