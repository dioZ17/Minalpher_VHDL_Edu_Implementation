library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_counter is 
	 port(
		Clock, CLR : in  std_logic;
		Q : out std_logic_vector(5 downto 0));
 end clk_counter;
