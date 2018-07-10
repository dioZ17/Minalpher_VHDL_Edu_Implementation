LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------
entity ShuffleRows1 is
port(
	INPUT_NIBS: in std_logic_vector (31 downto 0);
	OUTPUT_NIBS: out std_logic_vector (31 downto 0)
	);
end ShuffleRows1;
----------------------
architecture SR1 of ShuffleRows1 is
begin

	OUTPUT_NIBS(31 downto 28) <= INPUT_NIBS(4*5+3 downto 4*5); 			--7		5
	OUTPUT_NIBS(27 downto 24) <= INPUT_NIBS(4* 4 +3 downto 4* 4); 		--6		4
	OUTPUT_NIBS(23 downto 20) <= INPUT_NIBS(4* 3 +3 downto 4* 3);		--5		3
	OUTPUT_NIBS(19 downto 16) <= INPUT_NIBS(4* 2 +3 downto 4* 2);		--4		2
	OUTPUT_NIBS(15 downto 12) <= INPUT_NIBS(4* 0 +3 downto 4* 0);		--3		0
	OUTPUT_NIBS(11 downto 8) <= INPUT_NIBS(4* 1 +3 downto 4* 1);		--2		1
	OUTPUT_NIBS(7 downto 4) <= INPUT_NIBS(4* 7 +3 downto 4* 7);			--1		7
	OUTPUT_NIBS(3 downto 0) <= INPUT_NIBS(4* 6 +3 downto 4* 6);			--0		6
end SR1;
--------------------------
