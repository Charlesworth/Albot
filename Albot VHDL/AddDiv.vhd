LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity bit_AddDiv is
	port
	(in_Bus : in std_logic_vector(7 downto 0);
	 out_bus : out std_logic_vector(7 downto 0);
	 WindowEnable : in std_logic;
	 clk : in std_logic;
	 U_enable : std_logic
	);
end bit_AddDiv;


architecture str_AddDiv of bit_AddDiv is

begin
A_BUS: process(in_bus, WindowEnable, clk, U_enable)

begin
	if (WindowEnable = '1') and (clk = '1') and (U_enable = '1')
		then 
			out_bus <= in_bus;
	end if;
	
end Process A_BUS;

end str_AddDiv;
	
	
	