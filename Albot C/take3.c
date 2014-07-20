#include <avr/io.h>
#include <avr/interrupt.h>
#include "PWM.h"
#include "PID.h"
#include <util/delay.h>
#define F_CPU 8000000UL

int SearchCount;				//define integer use to determine search counter
int NoteCount;

int main(void)
{	
    Motor_Init();
	PID_Init();
	SetPIDInput(0,0);

	DDRB = 0xFF;		//[1111 1111] Set Port B as outputs - 0xFF data direction register B
	DDRC = 0x80;		//[1000 0000] Set PORTC bits 0 to 6 as inputs and bit 7 as output 
	PORTC = 0x7f;		//[0111 1111] Set internal pull-ups and bit 7 to 0
	
	PORTC &= ~(1<<7);  //set PORTC pin7 handshake bit to a 0
	PORTB &= ~(1<<7);  //set PORTB pin7 LED off

	const int LineFollowSpeed = -40; // The line follower optical detectors are on the back!
	unsigned char Command;
	int RgtWheelSpeed  = 0;
	int LftWheelSpeed  = 0;
	
	sei(); 						// Set Interrupts (switch on interrupts)
	int Search=1;				//define interger used to determine whether the line has been found since power on
		
	for(;;) { 					// Execute infinite loop (at high speed)
	
		Command = PINC;         // Read from FPGA ...
		PORTB = Command;		// ... reflect input to ALbot LEDs

		PORTC= Command; 		//send the same data to the motorcontroller PID

		if ( PIDInterruptFlag ) { // If the 250Hz timer interrupt has fired and set the
		                           // PID interrupt flag ...
								   
								   // ... send control to the motors
								
								   // ... but first reset the flag ...
	
			cli();                 // Clear interrupts (switch off interrupts)
			PIDInterruptFlag = 0;  // Clear interrupt flag
			sei();                 // Set interrupts (switch on interrupts)
		//*****************************************FIRST FOLOW THE LIE WITH THE LEFT OPTO*************************************************************
			/*if(PORTC== 3) 								//If both opto sensors are on the black line
				{
					LftWheelSpeed =  -60;				//Both wheels forward at -110 for extra speed on striaghts
					RgtWheelSpeed =  -60;		
					start=0;								//indicator variable: line has been found 
				}

			if(PORTC== 1)								//If only the left opto sensor is on the black line
				{
					LftWheelSpeed =   -LineFollowSpeed;  	//Rotate left
					RgtWheelSpeed =   LineFollowSpeed;
					left=1;									//state variable: line is currently to the left of the optos
					start=0;								//indicator variable: line has been found 
				}	
				
			if(PORTC== 2)								//If only the right opto sensor is on the black line
				{
					LftWheelSpeed =    LineFollowSpeed;  		//Rotate right
					RgtWheelSpeed =	   -LineFollowSpeed;
					left=0;									//state variable: line is currently to the right of the optos
					start=0;								//indicator variable: line has been found 
				}
			
			if(PORTC== 0)								//If nither opto sensor is on the black line
			{
				if(start==0)								//Has the line been found yet? If Yes
				{
						if(left==1)								//If the line last sensed on the left of the optos
						{
						LftWheelSpeed =  LineFollowSpeed; 			//turn left
						RgtWheelSpeed =  -LineFollowSpeed;										
						}
						else									//Else
						{
						LftWheelSpeed =  -LineFollowSpeed; 			//turn right
						RgtWheelSpeed =  LineFollowSpeed;	
						}
				}
				else										//else the line has not yet been found, begin a line search
				{
						LftWheelSpeed =  -60; 					//wide circular turn to search for a line
						RgtWheelSpeed =  -40;												
				}
			}	*/
			if(PORTC== 3 || PORTC == 1){ 								//If both opto sensors are on the black line
					LftWheelSpeed =  -60;				//Both wheels forward at -110 for extra speed on striaghts
					RgtWheelSpeed =  -60;		
					Search=0;								//indicator variable: line has been found 
					SearchCount=0;
			}else if(PORTC == 2 || PORTC == 0){
					Search=1;	
			}

		//*******************************************Line lost routine here*************************************************************************
			if(Search == 1){
				if(PORTC== 2){
					if(SearchCount <= 250){
						RgtWheelSpeed =  0; 					//left turn to search for a line
						LftWheelSpeed =  -60;
						SearchCount++;
					}else if(SearchCount <= 750){
						RgtWheelSpeed =  -60; 					//right turn to search for a line
						LftWheelSpeed =  0;
						SearchCount++;
					}else if(SearchCount <= 1500){
						RgtWheelSpeed =  0; 					//left turn to search for a line
						LftWheelSpeed =  -60;
						SearchCount++;
					}else if(SearchCount <= 2500){
						RgtWheelSpeed =  -60; 					//right turn to search for a line
						LftWheelSpeed =  0;
						SearchCount++;
					}
				}else if(PORTC == 0){
					if(SearchCount <= 250){
						RgtWheelSpeed =  -60; 					//right turn to search for a line
						LftWheelSpeed =  0;
						SearchCount++;
					}else if(SearchCount <= 750){
						RgtWheelSpeed =  0; 					//left turn to search for a line
						LftWheelSpeed =  -60;
						SearchCount++;
					}else if(SearchCount <= 1500){
						RgtWheelSpeed =  -60; 					//right turn to search for a line
						LftWheelSpeed =  0;
						SearchCount++;
					}else if(SearchCount <= 2500){
						RgtWheelSpeed =  0; 					//left turn to search for a line
						LftWheelSpeed =  -60;
						SearchCount++;
					}
				}
			}

			SetPIDInput ( LftWheelSpeed, RgtWheelSpeed );	//Request the speed for the PID to achieve	
			PIDHeartBeat();									//Let it do its work adjusting the voltages to achieve the given speed	
		//*******************************************NEXT SEND BACK INFORMATION ON WHETHER NOTE IS ON AND OFF**************************************
			if(PORTC== 3 || PORTC == 2){ 								//If both opto sensors are on the black line
					NoteCount++;
			}else if(PORTC == 1 || PORTC == 0){
					NoteCount--;
			}

			if(NoteCount >= 50){
				//output to FPGA play note
			}else{
				//output to FPGA no note
			}
			
		}
	}
	return 0;	//return to the start of the for loop
}


