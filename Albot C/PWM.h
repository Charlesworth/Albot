/*
	Motor PWM Control using a ATMega64 with Motors on OC3A and OC3B
	Joerg Wolf, April 2006
*/
#ifndef PWM_H
#define PWM_H

// Initialisation routine - MUST be called before others will work

extern void Motor_Init(void);

// Directly set the voltage (-1023 <= v <= 1023) on each motor

extern void SetSpeed(int LM_Voltage,int RM_Voltage);

#endif
