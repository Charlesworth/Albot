LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL; 
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_Std.all;

entity bit_AddDiv2 is
	port
	(
	 denominator : out std_logic_vector(15 downto 0) := "0000000000110100";
	 out_bus : out std_logic_vector(15 downto 0);
	 in_Bus : in std_logic_vector(7 downto 0);
	 WindowEnable : in std_logic;
	 clk : in std_logic;
	 U_enable : std_logic;
	 TrainFlag: in std_logic;
	 aclr : in std_logic;
	 AccumulateSIGNAL: in std_logic;
	 CalculateSIGNAL: in std_logic;
	 last_row : in std_logic
	
	);
end bit_AddDiv2;


architecture str_AddDiv1 of bit_AddDiv2 is


signal data_total : std_logic_vector (15 downto 0); 
signal DT : integer;
signal add : integer; 


begin


TRAINaccumulate: process(clk, TrainFlag, aclr, AccumulateSIGNAL,WindowEnable)


begin

		DT <= to_integer(unsigned(in_Bus));	--transform in bus to integer
		
		if (aclr = '1') then

		DT <= 0;
		add <= 0;
		
		
		elsif (clk'event) and (clk='0') then
		  if (TrainFlag='1')and (AccumulateSIGNAL='1') and (WindowEnable ='1') then	
		  
		  add <= add + DT;
		  
		  
		  end if;
		 end if;		
	end process TRAINaccumulate;	

TRAINcalculate: process(TrainFlag,CalculateSIGNAL) -- at end of training period do this, but only at start of a frame (and end of Vsync period)

	begin
		
		if (CalculateSIGNAL'event) and (CalculateSIGNAL='1') then  

		 data_total <= std_logic_vector(to_unsigned(add, data_total'length)); --s <= std_logic_vector(to_unsigned(i,s'length));
		 out_bus <= data_total;
		 
		 
		 if (TrainFlag = '1')then
		
		--here
		
		 end if;
		end if;
	end process TRAINcalculate;
	
end str_AddDiv1;
	
	--to_integer(unsigned(current_state));
