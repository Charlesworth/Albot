LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all; -- for integer to bit_vector conversion
--LIBRARY altera;
--USE altera.maxplus2.ALL;
--LIBRARY lpm;
--USE lpm.lpm_components.ALL;
  

-- VGA std format 640 by 480 pixels in a frame
-- register them, count line by line
-- checks the colour of each pixel, if it is ORANGE, then light an LED up

ENTITY PixelProcessor IS
	PORT
	(
		clk 		 : in  std_logic;
		TrainFLAG	 : in  std_logic; -- '1'to '0' transition means take current frame target area average RGB/YUV colours for recognition
		Aclr		 : in std_logic ; -- used to clear the accumulators used during training

		VVV		 : in  unsigned (7 downto 0) ;
		Hsync		 : in std_logic; -- vertical and horizontal sync signals
		Row			 : in unsigned (8 downto 0); -- 480 == 256+128+64 ie. "111000000"
		Column		 : in unsigned (9 downto 0); -- 640 == 512+128 ie. "1010000000"
		Vsync		 : in std_logic;
		AccumulateSIGNAL : in std_logic; -- is HIGH during hysnc's within a frame, reset by Vsync
		CalculateSIGNAL : in std_logic; -- is HIGH during gap between last hysnc in a frame, reset by Vsync
		WindowROW	: in std_logic; -- true for valid ROWs in specified processing window
		WindowCOLUMN: in std_logic;  -- true for valid COLUMNs in specified processing window

		UflagREG,YflagREG,Y1flagREG,VFlagREG: out std_logic;
		flag: out std_logic; -- debugging flag
		PixelMATCH: out std_logic
		-- Row & Column strobed are latched to ensure stable values in sync with pixel data

	);
END PixelProcessor;


-- first register the pixel stream
ARCHITECTURE PixelProcessor_v1 OF PixelProcessor IS

	signal p1:  unsigned (7 downto 0);
	signal r1:  unsigned (9 downto 0);
	signal	tempV: integer range 0 to 512;
	signal Window: std_logic;
	signal	 VFlag: std_logic;
	signal	flagCLK: std_logic;
	signal  VVVmean: integer range 0 to 512;

--HERE can use 32bit integers to start then refine to change bit width to suit.

	shared variable TESTpixCOUNT: natural range 0 to 307200 :=0; -- max range of full VGA resolution
	shared variable TRAINpixCOUNT: natural range 0 to 307200 :=0;
	
	
BEGIN

	---------------------------------------------------------------------------	
	TRAINaccumulate: process(clk, TrainFlag, aclr, AccumulateSIGNAL,Window)
	begin
		if (aclr = '1') then
--HERE

		elsif (clk'event) and (clk='0') then
		  if (TrainFlag='1')and (AccumulateSIGNAL='1') and (Window ='1')  then	
--HERE
		  end if;
		end if;
	end process TRAINaccumulate;	
	---------------------------------------------------------------------------
	TRAINcalculate: process(TrainFlag,CalculateSIGNAL) -- at end of training period do this, but only at start of a frame (and end of Vsync period)
	begin
		if (CalculateSIGNAL'event) and (CalculateSIGNAL='1') then  
		 if (TrainFlag = '1')then
-- HERE
		 end if;
		end if;
	end process TRAINcalculate;	
	---------------------------------------------------------------------------
		
	TESTaccumulate: process(clk, Vsync, TrainFLAG, AccumulateSIGNAL, Window)
	begin
		if (Vsync = '1') then -- clear count for every frame
--HERE
		elsif (clk'event) and (clk='0')  then	 -- when not training try testing for object
			if (TrainFLAG='0') and (AccumulateSIGNAL ='1') and (Window='1') then
--HERE
			end if;
		end if;
	end process TESTaccumulate;
	---------------------------------------------------------------------------
	
	TESTcalculate: process(TrainFLAG, CalculateSIGNAL)
	begin
		if (CalculateSIGNAL'event) and (CalculateSIGNAL='1') and (TrainFlag = '0') then
--HERE
		
		end if;
		
	end process TESTcalculate;	
	---------------------------------------------------------------------------

END PixelProcessor_v1;
