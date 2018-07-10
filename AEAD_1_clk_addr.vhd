library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity clk_addr is 
	 port(
		Clock, CLR : in  std_logic;
		Q : out std_logic_vector(5 downto 0));
 end clk_addr;

 architecture archi of clk_addr is  
 
 --COMPONENT full_adder_1 
 --Port ( A : in STD_LOGIC;
 --B : in STD_LOGIC;
 --Cin : in STD_LOGIC;
 --S : out STD_LOGIC;
 --Cout : out STD_LOGIC);
--end COMPONENT full_adder_1;

signal tmp: std_logic_vector(5 downto 0);
--signal carry : std_logic_vector (6 downto 0);
--signal add_1 : std_logic;
begin

--G1 : for n in 5 downto 1 GENERATE
--FA00: full_adder_1 PORT MAP
--	(
--		A => '0',
--		B => '0',
--		Cin => carry(n),
--		Cout => carry(n+1),
--		S => tmp(n)
--		)
--FA01: full_adder_1 PORT MAP
--	(
--		A	=> add_1,
--		B	=> '0',
		
		

	process (Clock, CLR) 
	 begin   

		   if (CLR='1') then   

				  tmp <= (5 downto 0 => '0');  
				--tmp <= 0;
		   elsif (Clock'event and Clock='1') then 
			--	  tmp <= tmp + '1';
				tmp <= tmp + 1;
		   end if;     
	 end process; 
		   Q <= std_logic_vector(tmp);
		   --Q<=tmp 
 end archi;
 
