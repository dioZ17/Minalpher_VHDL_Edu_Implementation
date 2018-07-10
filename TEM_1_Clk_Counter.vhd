library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_counter is 
	 port(
		Clk : in  std_logic;
		Q : out std_logic_vector(5 downto 0));
 end clk_counter;

 architecture archi of clk_counter is  

 
 
 
	COMPONENT d_latch_top port
	(
		   D  : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           Q  : out STD_LOGIC
	);
		
	end COMPONENT d_latch_top;

	signal pass_pulse_in : std_logic_vector(5 downto 1);
	signal pass_pulse_out : std_logic_vector(5 downto 0);
	signal enable : std_logic_vector(5 downto 0);
begin

	DL00: d_latch_top	PORT MAP
		(
			D => clk,
			EN => '1',
			Q => pass_pulse_out(0)
		);

	enable(0) <= '1';
	
	pass_pulse_in(1) <= enable(0) and pass_pulse_out(0);
		pass_pulse_in(2) <= enable(1) and pass_pulse_out(1);
			pass_pulse_in(3) <= enable(2) and pass_pulse_out(2);
				pass_pulse_in(4) <= enable(3) and pass_pulse_out(3);
					pass_pulse_in(5) <= enable(4) and pass_pulse_out(4);

	--Adder Dff
	G0: for n in 5 downto 1 GENERATE
	DL01: d_latch_top	PORT MAP
		(
			EN => pass_pulse_in(n),--enable(n-1) and pass_pulse_out(n-1),
			D => clk,
			Q	=> pass_pulse_out(n)
		);
	END GENERATE G0;

		   Q(5 downto 0)<=pass_pulse_out;
		   --Q(0)<=clk;
 end archi;
 
