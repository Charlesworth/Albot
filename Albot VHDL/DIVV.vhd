LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use ieee.numeric_std.all;




entity bit_DIVV is
	port
	(in_Bus : in std_logic_vector(7 downto 0);
	 out_bus : out std_logic_vector(15 downto 0);
	 WindowEnable : in std_logic;
	 clk : in std_logic;
	 U_enable : std_logic;
	 TrainFlag: in std_logic;
	 aclr : in std_logic;
	 AccumulateSIGNAL: in std_logic;
	 CalculateSIGNAL: in std_logic;
	 last_row : in std_logic
	
	);
end bit_DIVV;

architecture str_AddDiv1 of bit_DIVV is


signal data_total : std_logic_vector (15 downto 0); 
signal add : integer range -16384 to 16383;
 


begin
TRAINcalculate: process(TrainFlag,CalculateSIGNAL) -- at end of training period do this, but only at start of a frame (and end of Vsync period)
variable Calc_total : std_logic_vector(15 downto 0);

	begin
		
		if (CalculateSIGNAL'event) and (CalculateSIGNAL='1') then  
		 
		data_total <= data_total sll 2;
		out_bus <= data_total;
		 
		 if (TrainFlag = '1')then
-- HERE
		 end if;
		end if;
	end process TRAINcalculate;
	
end str_AddDiv1;