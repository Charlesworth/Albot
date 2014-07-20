/*
	Motor PWM Control using a ATMega64 with Motors on OC3A and OC3B
	Joerg Wolf, April 2006
*/

#include <avr/io.h>
#include "PWM.h"

#define LEFT_FORWARD    0x40
#define LEFT_REVERSE    0x80
#define RIGHT_FORWARD   0x20
#define RIGHT_REVERSE   0x10
#define LEFT_PWM        OCR3A
#define RIGHT_PWM       OCR3B
#define LEFT_MOT        0
#define RIGHT_MOT       1

/****************************************************************************\
*   Motor initialisation, set up hardware and data structures
\****************************************************************************/

void Motor_Init(void)
{
	DDRE = 0x18;               // Set PE3 and PE4 for output (PWM)
	DDRA = 0xF0;               // Set PortA4-7 for output (Motor direction control)
	// Set up Timer3 and the output compare units for PWM 10 bits
	// Inverted PWM
	TCCR3A = (1 << COM3A1) | (1 << COM3B1) | (1 << WGM31) | (1 << WGM30)|(1 << COM3A0) | (1 << COM3B0); 
    	// Use divide by 1 prescaler for 15.6kHz at 10 bits;
    	// 31.2 kHz at 9 bits (too high for H Bridge);
	TCCR3B = (1 << WGM32) | (1 << CS30);
 
	DDRD=0x39;	// 0011 1001   make the shaft encoder pins an input

	EIMSK = 0x06;  // Enable interrupts int1 and int2
	EICRA = (1<<ISC21)|(1<<ISC20)|(1<<ISC11)|(1<<ISC10);  // Triggering on leading edge int1 & int2
			
//  Initialise the PWM output, initially stop it from moving anywhere

	SetSpeed(0,0);
	
}


/****************************************************************************\
*   Set the speed of the motors
    Converts Vout from +-1024 to a PWM value and
*   Sets the H-bridge values for motor direction
\****************************************************************************/

void SetSpeed(int LM_Voltage,int RM_Voltage)
{
	unsigned char PVal;

	// Setup the H-bridge logic for motor direction
	PVal = PORTA;
	// Clear current motor setting
	PVal &= ~( LEFT_FORWARD|LEFT_REVERSE|RIGHT_FORWARD|RIGHT_REVERSE);
	if (LM_Voltage >= 0)                  // Set motor direction
        	PVal |= LEFT_FORWARD;        // through h-bridge bits
	else if (LM_Voltage < 0){
        	PVal |= LEFT_REVERSE;
        	LM_Voltage=-LM_Voltage;               // Take the absolute value
	}
	if (RM_Voltage >= 0)                  // Set motor direction
        	PVal |= RIGHT_FORWARD;        // through h-bridge bits
	else if (RM_Voltage < 0){
        	PVal |= RIGHT_REVERSE;
        	RM_Voltage=-RM_Voltage;               // Take the absolute value
	}
	PORTA = PVal;
	if (LM_Voltage > 1023){LM_Voltage = 1023;}    // Saturation clamp 100% PWM
	if (RM_Voltage > 1023){RM_Voltage = 1023;}
	LEFT_PWM  = LM_Voltage;
	RIGHT_PWM = RM_Voltage;
}
