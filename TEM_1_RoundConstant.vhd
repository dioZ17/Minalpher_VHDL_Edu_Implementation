
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity RoundConstant is
port(
	r: in std_logic_vector (3 downto 0);
	--OUTPUT_NIBBS: out nibble_matrix
	OUTPUT_NIBBS: out std_logic_vector(127 downto 0)
	);
end RoundConstant;
----------------------
architecture behaviour of RoundConstant is


begin
--OUTPUT_NIBBS(7,3) <= r xor "0000";	OUTPUT_NIBBS(6,3) <= r xor "0001";	OUTPUT_NIBBS(5,3) <= r xor "0010";	OUTPUT_NIBBS(4,3) <= r xor "0011";	OUTPUT_NIBBS(3,3) <= "0000"; 	OUTPUT_NIBBS(3,2) <= "0000"; 	OUTPUT_NIBBS(3,1) <= "0000"; 	OUTPUT_NIBBS(3,0) <= "0000";
--OUTPUT_NIBBS(7,2) <= r xor "0001";	OUTPUT_NIBBS(6,2) <= r xor "0000";	OUTPUT_NIBBS(5,2) <= r xor "0011";	OUTPUT_NIBBS(4,2) <= r xor "0010";	OUTPUT_NIBBS(2,3) <= "0000"; 	OUTPUT_NIBBS(2,2) <= "0000"; 	OUTPUT_NIBBS(2,1) <= "0000"; 	OUTPUT_NIBBS(2,0) <= "0000";
--OUTPUT_NIBBS(7,1) <= r xor "0010";	OUTPUT_NIBBS(6,1) <= r xor "0011";	OUTPUT_NIBBS(5,1) <= r xor "0000";	OUTPUT_NIBBS(4,1) <= r xor "0001";	OUTPUT_NIBBS(1,3) <= "0000"; 	OUTPUT_NIBBS(1,2) <= "0000"; 	OUTPUT_NIBBS(1,1) <= "0000"; 	OUTPUT_NIBBS(1,0) <= "0000";
--OUTPUT_NIBBS(7,0) <= r xor "0011";	OUTPUT_NIBBS(6,0) <= r xor "0010";	OUTPUT_NIBBS(5,0) <= r xor "0001";	OUTPUT_NIBBS(4,0) <= r xor "0000";	OUTPUT_NIBBS(0,3) <= "0000"; 	OUTPUT_NIBBS(0,2) <= "0000"; 	OUTPUT_NIBBS(0,1) <= "0000"; 	OUTPUT_NIBBS(0,0) <= "0000";	

OUTPUT_NIBBS(127 downto 124) <= r xor "0000";	OUTPUT_NIBBS(123 downto 120) <= r xor "0001";	OUTPUT_NIBBS(119 downto 116) <= r xor "0010";	OUTPUT_NIBBS(115 downto 112) <= r xor "0011";	OUTPUT_NIBBS(111 downto 96)<= "0000000000000000";
OUTPUT_NIBBS(95 downto 92)   <= r xor "0001";	OUTPUT_NIBBS(91 downto 88)   <= r xor "0000";	OUTPUT_NIBBS(87 downto 84)   <= r xor "0011";	OUTPUT_NIBBS(83 downto 80)   <= r xor "0010";	OUTPUT_NIBBS(79 downto 64) <= "0000000000000000";
OUTPUT_NIBBS(63 downto 60)   <= r xor "0010";	OUTPUT_NIBBS(59 downto 56)   <= r xor "0011";	OUTPUT_NIBBS(55 downto 52)   <= r xor "0000";	OUTPUT_NIBBS(51 downto 48)   <= r xor "0001";	OUTPUT_NIBBS(47 downto 32) <= "0000000000000000"; 
OUTPUT_NIBBS(31 downto 28)   <= r xor "0011";	OUTPUT_NIBBS(27 downto 24)   <= r xor "0010";	OUTPUT_NIBBS(23 downto 20)   <= r xor "0001";	OUTPUT_NIBBS(19 downto 16)   <= r xor "0000";	OUTPUT_NIBBS(15 downto 0)  <= "0000000000000000";
end behaviour;
--------------------------