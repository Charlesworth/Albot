#ifndef PID_H
#define PID_H

// Proportional Integral Derivative (PID) controller interface
// ===========================================================

// Timer interrupt - set true by chip timer 250 times a second, must be reset by user

extern volatile unsigned char PIDInterruptFlag;

// Initialisation routine - MUST be called before others will work

extern void PID_Init (void);

// Request a speed from the PID controller

extern void SetPIDInput( int LftMotorSpeed,int RgtMotorSpeed );

// Call 250 times a second (ie whenever TimerInterrupt is true) so the PID can do its 
// task of adjust the motor voltages to achieve the speed requested (by SetPIDInput)

extern void PIDHeartBeat(void);

#endif

