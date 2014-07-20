LIBRARY ieee;
USE ieee.std_logic_1164.all;
-- not both this and below -- USE ieee.std_logic_arith.all;
--use IEEE.numeric_bit.all; -- for integer to bit_vector conversion
use IEEE.numeric_std.all; -- for integer to bit_vector conversion

-- VGA std format 640 by 480 pixels in a frame
-- register them, count line by line
-- 

ENTITY SlowCounter IS
	PORT
	(
		Clk 		 : IN  std_logic;
		ClockOUT	 : OUT std_logic
		
	);
END SlowCounter;


-- first register the pixel stream
ARCHITECTURE SlowCounter_v1 OF SlowCounter IS
	CONSTANT maxval: natural := 100; -- **************NOTE: this is carefully chosen to ensure TrainFLAG (in Debouncer)is only one frame long
	signal Counter: natural range 0 to maxval; -- reduce clock to approx 500ms from 64uS (Hsync input)
	signal Ctemp: std_logic := '0';
begin
	---------------------------------------------------------------------------
	process (clk)
	begin
		if (clk'event) and (clk ='1') then
			Counter <= Counter +1;
			if Counter = 0 then
			 Ctemp <= '0';
			end if;
			if Counter = maxval then
			 Ctemp <= not(Ctemp);
			end if;
		end if;
	end process;
	
	Clockout <= Ctemp;
	---------------------------------------------------------------------------
END SlowCounter_v1;