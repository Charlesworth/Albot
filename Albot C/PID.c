#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <math.h>

#include "PWM.h"

#define VKp               	16
#define HKp               	16
#define Kp			         6
#define NoiseThresHold      28
#define sfactor(x)        (x*4)

#define TMRRESET    194

#define HBEAT       0
#define MSGRCV      1
#define DBGR        2
#define DBGL        3

typedef struct
{
   int RawIntCnt;
   int EncCnt;        // Shaft Encoder count for this wheel
   int EncCnt_Old;    // Shaft encoder count last time (1/250 sec ago)
   int Vin;           // Voltage in -> actually requested speed
} MOTOR_DATA;

volatile MOTOR_DATA  LM, RM;

volatile unsigned char PIDInterruptFlag;

void PID_Init (void)
{
	/* Timer0 is for the PID Controller */
	
	TCCR0 = 0x07;  // Use 1024 prescaler on Timer 0 pdf p.105 (this actually sets to 128. For 1024, should be 0x07 with atmega128 
	TIMSK = 0x01;  // Enable timer (overflow interrupt enabled. Same on ATMEGA128) 

	PIDInterruptFlag = 0;
	
	LM.EncCnt     = 0;  RM.EncCnt     = 0;
	LM.EncCnt_Old = 0;  RM.EncCnt_Old = 0;
	LM.Vin        = 0;  RM.Vin        = 0;
}

SIGNAL(SIG_OVERFLOW0)		//PID Controller sampling
{
    cli();
	
	TCNT0=TMRRESET;

	LM.EncCnt = LM.RawIntCnt;
	RM.EncCnt = RM.RawIntCnt;
	LM.RawIntCnt = 0;
	RM.RawIntCnt = 0;

	PIDInterruptFlag = 1;
	
	sei();	
}

SIGNAL(SIG_INTERRUPT1)  // Left wheel shaft encoder interrupt
{
	if (PIND & '\x40'){ // Check wheel direction status bit
		LM.RawIntCnt--;
	}else{
		LM.RawIntCnt++;
	}	
}

SIGNAL(SIG_INTERRUPT2)  // Right wheel shaft encoder interrupt
{
	if (PIND & '\x80'){ // Check wheel direction status bit
		RM.RawIntCnt++;
	}else{
		RM.RawIntCnt--;
	}
}

void SetPIDInput ( int LftMotorSpeed,int RgtMotorSpeed )
{
	LM.Vin = LftMotorSpeed;
	RM.Vin = RgtMotorSpeed;
}

void PIDHeartBeat(void)
{
	if( (LM.Vin==0) && (RM.Vin==0) ){
	
		// Hold the position
		
		int EL = (0 - sfactor(LM.EncCnt));
		int ER = (0 - sfactor(RM.EncCnt));

		if((EL < NoiseThresHold)&&(EL > -NoiseThresHold)){ EL = EL/4;}	// deadband
        if((ER < NoiseThresHold)&&(ER > -NoiseThresHold)){ ER = ER/4;}
		
		SetSpeed(	HKp * EL,HKp * ER);
		
	}else{
	
		// Robot is moving
		
		int EL = (LM.Vin - sfactor(LM.EncCnt));
		int ER = (RM.Vin - sfactor(RM.EncCnt));
		if( LM.EncCnt - LM.EncCnt_Old >= 2){
			EL = EL/8;
		}
		if( RM.EncCnt - RM.EncCnt_Old >= 2){
			ER = ER/8;
		}
		
		SetSpeed(	(VKp+3) * EL,		(VKp+3) * ER);
	}
	LM.EncCnt_Old = LM.EncCnt;
	RM.EncCnt_Old = RM.EncCnt;
}

