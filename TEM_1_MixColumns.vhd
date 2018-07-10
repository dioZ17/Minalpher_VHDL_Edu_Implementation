-------------------------------------
----COLUMN MIXER-
-------------------------------------
---- BE CAREFUL ON INPUT
---- WE HAVE TO INPUT NIBS BY COLUMNS
---- SO IF bits = 128, COLUMNS = 8, ROWS = 4
---- i = row_ind, j = col_ind
---- FOR THE FIRST COLUMN WE INPUT 4*(i+1)*(j+1)-1 downto 4*(i+1)*(j+1)-4

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity MixColumns is
port(
	INPUT_NIBS: in std_logic_vector (15 downto 0);
	OUTPUT_NIBS: out std_logic_vector (15 downto 0)
	);
end MixColumns;
----------------------
architecture behaviour of MixColumns is
begin
	
	OUTPUT_NIBS(15 downto 12) <= INPUT_NIBS(15 downto 12) xor INPUT_NIBS(3 downto 0) xor INPUT_NIBS(11 downto 8); 		--3
	OUTPUT_NIBS(11 downto 8) <= INPUT_NIBS(11 downto 8) xor INPUT_NIBS(15 downto 12) xor INPUT_NIBS(7 downto 4); 		--2
	OUTPUT_NIBS(7 downto 4) <= INPUT_NIBS(7 downto 4) xor INPUT_NIBS(11 downto 8) xor INPUT_NIBS(3 downto 0); 		--1
	OUTPUT_NIBS(3 downto 0) <= INPUT_NIBS(3 downto 0) xor INPUT_NIBS(7 downto 4) xor INPUT_NIBS(15 downto 12); 		--0

end behaviour;
--------------------------

