			
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity StateMachine is
	port (
		clk : in std_logic;
		nReset : in std_logic;

		Dout : out std_logic_vector(7 downto 0);	-- data read from ds1621

		error : out std_logic; -- no correct ack received

		SCL : inout std_logic;
		SDA : inout std_logic
	);
end entity StateMachine;

architecture structural of StateMachine is
	---------------------------------------------------------------------------
	YUVmachine: process (Hsync, Vsync, YUV_Cstate) 
	begin
		case YUV_Cstate is
			when "000" =>
				YUV_Nstate <="001";
				YUVclk<= '0';
				Yclk<='0';
				Uclk<='0';
				Y1clk<='0';
				Vclk<='0';
			when "001" =>
				YUV_Nstate <="010";
				YUVclk<='1' ; --and Hsync;
				Yclk<='1';
				Uclk<='0';
				Y1clk<='0';
				Vclk<='0';
			when "010" =>
				YUV_Nstate <="011";
				YUVclk<='0';
				Yclk<='0';
				Uclk<='1';
				Y1clk<='0';
				Vclk<='0';
			when "011" =>
				YUV_Nstate <="100";
				YUVclk<='0';
				Yclk<='0';
				Uclk<='0';
				Y1clk<='1';
				Vclk<='0';
			when "100" =>
				YUV_Nstate <="001";
				YUVclk<='0';
				Yclk<='0';
				Uclk<='0';
				Y1clk<='0';
				Vclk<='1';
			when others =>
				Yclk<='0';
				Uclk<='0';
				Y1clk<='0';
				Vclk<='0';
				YUV_Nstate <="001";
				YUVclk<='0';
		end case;
			-- genregs
		if (Hsync='0') then
			YUV_Cstate <="000";
		elsif (clk'event) and (clk = '0') then -- PC 04.08.06 was '1'
			YUV_Cstate<=YUV_Nstate;
		end if;
		
	end process structural;
	---------------------------------------------------------------------------			