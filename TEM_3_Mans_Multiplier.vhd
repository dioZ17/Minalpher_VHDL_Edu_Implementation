--NOTES: CHECK OUTPUT TIMERS BECAUSE WE USED TO HAVE I_MAX_SYNC NOW IMAX 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity mans_Multiplier is
port(

	clk : in std_logic;
	rst : in std_logic;

	i: in std_logic_vector (5 downto 0); --64 values
	j: in std_logic_vector (1 downto 0);
	A: in std_logic_vector(255 downto 0);
	
	output: out std_logic_vector (255 downto 0);
	finish: out std_logic
	);
end mans_Multiplier;
----------------------
architecture EMM of mans_Multiplier is

--	COMPONENT clk_divider
--	port(

--		clk : in std_logic;
--		div_clk : out std_logic
--		);
--	end COMPONENT clk_divider;
  COMPONENT freeze_signal is 
     port(
      INPUT : in std_logic_vector(255 downto 0);
      Clock, CLR : in  std_logic;
      Limit: in std_logic_vector(7 downto 0);
      OUTPUT : out std_logic_vector(255 downto 0);
	  Maxd : out std_logic
      );
      
   end COMPONENT freeze_signal;

--	COMPONENT freeze PORT
--	(
--		maxd 	: in std_logic;
--		INPUT	: in std_logic_vector(255 downto 0);
--		clr		: in std_logic;
--		Q		: out std_logic_vector(255 downto 0)
--		);
--	end COMPONENT freeze;

	COMPONENT y_plus_1_mul_at_j PORT
		(
		j: in std_logic_vector(1 downto 0);
		rst : in std_logic;
		INPUT: in std_logic_vector (255 downto 0);
		output: out std_logic_vector (255 downto 0)
		);
	END COMPONENT y_plus_1_mul_at_j;

	COMPONENT y_mul_loop PORT
		(
		rst : in std_logic;
		clk : in std_logic;
		INPUT: in std_logic_vector (255 downto 0);
		output: out std_logic_vector (255 downto 0)
		);
	END COMPONENT y_mul_loop;
	
--	COMPONENT limit_counter port
--		(
--		Clock, CLR : in  std_logic;
--		Limit: in std_logic_vector(7 downto 0);
--		Q : out std_logic_vector(5 downto 0);
--		Maxd : out std_logic
--		);
--	END COMPONENT limit_counter;

	COMPONENT dff port 
	(
		d, clk, rst: in std_logic;
		q: out std_logic
	);
	end COMPONENT dff;
	--SIGNALS--
	signal i_extend : std_logic_vector(7 downto 0);
	signal i_count  : std_logic_vector(5 downto 0);
	signal i_max	: std_logic;
	signal i_max_sync	: std_logic;
	
	signal yp1_to_y : std_logic_vector(255 downto 0);
	signal y_to_freeze : std_logic_vector(255 downto 0);
	
	--signal clk_2	: std_logic;
	
	--signal rst_or_max : std_logic;
	
BEGIN

	--Signal Inits--

	i_extend(5 downto 0) 	<= i;
	i_extend(6)				<= '0';
	i_extend(7)				<= '0';

	
	-- COMPONENTS --
	

	YP00:y_plus_1_mul_at_j PORT MAP
		(
			j		=> j,
			rst		=> rst,
			INPUT	=> A,
			output	=> yp1_to_y
		);
	
	Y00:y_mul_loop PORT MAP
		(
		rst		=> rst,
		clk 	=> clk,
		INPUT	=> yp1_to_y,
		output	=> y_to_freeze
		);
	
--	L00: limit_counter PORT MAP
--		(
--			Clock	=> clk,
--			CLR		=> rst,
--			Limit	=> i_extend,
--			Q		=> i_count,
---			Maxd	=> i_max
	--	);
			
--		DF00: dff	PORT MAP
--		(
--			d		=> i_max,
--			clk		=> clk,
--			rst		=> rst,
--			q		=> i_max_sync
--		);
		
--	FR00:freeze PORT MAP
--		(
--		maxd 	=> i_max_sync,
--		INPUT	=> y_to_freeze,
--		clr		=> rst,
--		Q		=> OUTPUT
--		);

		FR00: freeze_signal PORT MAP
		(
		  INPUT => y_to_freeze,
		  Clock => clk,
		  CLR 	=> rst,
		  Limit => i_extend,
		  OUTPUT=> OUTPUT,
		  Maxd  => finish
			
		);
	
		--finish <= i_max_sync;

end EMM;


-----------------------------------------------
-----SIMULATION SCRIPT--------------------------

--force -freeze sim:/mans_multiplier/clk 1 0, 0 {50 ns} -r 100
--force -freeze sim:/mans_multiplier/rst 1 0
--force -freeze sim:/mans_multiplier/i 6'h05 0
--force -freeze sim:/mans_multiplier/j 6'h04 0
--force -freeze sim:/mans_multiplier/A 256'h55771111111111111111111111111111111111111111111111111111111111FF 0











-----------------------
--This is a syncronous system
--that outputs the multiplication of 
-- A * (y+1)^j*y^i in a total of i+j+1 cc
-- 

