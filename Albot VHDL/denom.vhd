LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL; 
--use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_Std.all;

entity bit_denom is
	port
	(
	 denominator : out std_logic_vector(15 downto 0) := "0000000000110001"
	 
	 );
end bit_denom;	 

architecture str_denom of bit_denom is

begin

end str_denom;