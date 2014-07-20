LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all; -- for integer to bit_vector conversion

ENTITY Sequencer IS
	PORT
	(
		TrainFlag 	 : IN  std_logic;
		Vsync 		 : IN  std_logic;
		Aclr		 : IN std_logic; -- hold decode of pixel colour 01==red, 10==green, 11==blue
		CountOUT 	 : out  natural range 0 to 10 ;
		TRaccumFLAG 	 : out  std_logic;  -- seq. Training accumulate pixels in window
		TRcalcFLAG 	 	 : out  std_logic;  -- seq. training calc. average of pixels for window
		outFLAG : out std_logic --for debugging
	);
END Sequencer;

ARCHITECTURE Sequencer_v1 OF Sequencer IS
	shared variable stopFLAG:  std_logic :='1';
	signal STOP: std_logic :='1'; -- used to enable the counter, hence cleared to stop it.
	signal Scount : natural;
	
	component dff port(d,clk,clrn,prn:in std_logic; q:out std_logic);end component;

BEGIN
	
u1: dff port map('1',TrainFLAG,stopFLAG,'1',STOP);-- train for one frame only
	outFLAG <= Vsync; --STOP; -- debugging
	CountOUT<=(Scount);
	

	---------------------------------------------------------------------------	
	CLOCK: process (Aclr,Vsync, STOP, TrainFLAG, Scount)
	begin
		if (Aclr='1') then
		 Scount <= 0;
		 stopFLAG :='1';
 		 TRaccumFLAG <= '0';
 		 TRcalcFLAG <= '0';
		elsif (Vsync'event) and (Vsync='1')  then
		 if (STOP = '1') then Scount <= Scount + 1; end if;
		end if;
		case Scount is
			when 0 =>
				stopFLAG:='1';
				if (TrainFLAG = '1') then TRaccumFLAG <= '1'; end if;
			when 1 =>		
				if (TrainFLAG = '1') then
					TRaccumFLAG <= '0';
				else 
					TRcalcFLAG <= '1'; 
				end if;
				 
			when 2 =>
				if (TrainFLAG = '0')then TRcalcFLAG <= '0'; end if;
			when 3=>
				TRaccumFLAG <= '0';				
			when others =>
				TRaccumFLAG <= '0';
				TRcalcFLAG <= '0';
				stopFLAG :='0';
		end case;			
	end process CLOCK;
---------------------------------------------------------------------------	
end 	Sequencer_v1;