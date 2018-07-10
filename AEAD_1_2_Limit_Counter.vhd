------------------------------------------
--The limit counter outputs the clock adder
--and a bit that freezes to 0 when the adder
--reaches the limit
-----------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity limit_counter is 
	 port(
		Clock, CLR : in  std_logic;
		Limit: in std_logic_vector(7 downto 0);
		Q : out std_logic_vector(5 downto 0);
		Maxd : out std_logic
		);
		
 end limit_counter;
-------------------------------------------



 architecture archi of limit_counter is  

 
	COMPONENT S_R_latch_top Port 
		(
		S : in    STD_LOGIC;
		R : in    STD_LOGIC;
        Q : inout STD_LOGIC); -- changed out to inout
	end COMPONENT S_R_latch_top;

	 COMPONENT clk_addr port
			(
			Clock, CLR : in  std_logic;
			Q : out std_logic_vector(5 downto 0)
			);
	 end COMPONENT clk_addr;
 
	 COMPONENT comparator is
		port (
			  clock: in std_logic; 
			  -- clock for synchronization
			  A: in std_logic_vector(7 downto 0); 
			  B: in std_logic_vector(7 downto 0); 
			  -- Two inputs
			  IAB: in std_logic; -- Expansion input ( Active low)
			  Output: out std_logic -- Output = 0 when A = B 
			);
		end COMPONENT comparator;
 
signal out_wire_cnt : std_logic_vector(5 downto 0);
signal out_wire_cmp : std_logic;
signal cnt_8_extens	: std_logic_vector(7 downto 0);
signal out_max		: std_logic;

--signal out_sync		: std_logic;

begin




	 CA00: clk_addr port map(
			clock 	=> clock,
			clr		=> clr,
			Q		=> out_wire_cnt
			);
			
			cnt_8_extens(7) <= '0';
			cnt_8_extens(6) <= '0';
			cnt_8_extens(5 downto 0) <= out_wire_cnt;
			
	CM00: comparator port map(
			clock 	=> clock,
			A 		=> cnt_8_extens,
			B		=> Limit,
			IAB		=> '0',
			Output	=> out_wire_cmp
			);

	L00: S_R_latch_top port map(
		S => clr,
		R => "not"(out_wire_cmp),
        Q => out_max -- changed out to inout
		);
	

	
	process(clr, out_wire_cnt)
	begin
		if(clr = '1') then
			Q <= (5 downto 0 => '0');
		else
			Q <= out_wire_cnt;
		end if;
	end process;
	
	Maxd <= out_max;
	
--	process (Clock, CLR) 
--	 begin   
--		   if (CLR='1') then   
--				  Q <= (5 downto 0 => '0');  
--				  Maxd <= '1';
--		   elsif (Clock'event and Clock='1') then --output not freezing to limit 
--				Maxd <= out_sync;
--				Q <= out_wire_cnt;
--		   end if;     
--	 end process; 

 end archi;
 

