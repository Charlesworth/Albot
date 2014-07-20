LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL; 
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_Std.all;

entity LED_mov is
	port
	(
	 
	 Clk : in std_logic;
	 CalculateSIGNAL: in std_logic;
	 Uin : in std_logic_vector(7 downto 0);
	 Vin : in std_logic_vector(7 downto 0);
	 AverageValU : in std_logic_vector(15 downto 0);
	 AverageValV : in std_logic_vector(15 downto 0);
	 Column : unsigned(10 downto 0);
	 aclr : in std_logic;
	 LED1 : out std_logic;
	 LED2 : out std_logic
		 
	);
end LED_mov;

architecture str_LED of LED_mov is
signal AvUHigh : std_logic_vector(15 downto 0);	--Threshold high value
	signal AvULow : std_logic_vector(15 downto 0);	--Threshold low value

begin


Average_thresh : process (AverageValU, AverageValV, aclr)

	begin
	
		if (aclr = '1') then
		
				AvUHigh <= AverageValU + "0000000000000010";
				AvULow <= AverageValU - "0000000000000010"; 
			
		end if;
	
end process Average_thresh;


compare : process(Clk, Column, CalculateSIGNAL, Uin, Vin, AverageValU)

	begin
		
		if (CalculateSIGNAL'event) and (CalculateSIGNAL='1') then
			if(Column <= "0010100000") then
			
				if(AverageValU = Uin) then
				
					LED1 <= '1';
						
						else
							
							LED1 <= '0';
							
						end if;				
					end if;
				end if;
	
					
	
end process compare;


end str_LED;