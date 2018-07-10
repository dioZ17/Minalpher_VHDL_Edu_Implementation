

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;
USE IEEE.NUMERIC_STD.ALL;
-----------------------------------

entity Crypto_TestBench is
port(
	--INPUTS
	K	: in std_logic_vector (127 downto 0);
	flag: in std_logic_vector (23 downto 0);
	N	: in std_logic_vector (103 downto 0);
	i	: in std_logic_vector (5 downto 0);	--NOT YET IMPLEMEMNTED
	j	: in std_logic_vector (1 downto 0);
	
	INPUT	: in std_logic_vector (255 downto 0);
	
	clk : in std_logic;
	rst : in std_logic;
	
	--CIPHER
	OUTPUT: out std_logic_vector (255 downto 0)
	);
end Crypto_TestBench;
------------------------------------------------

architecture structural of Crypto_TestBench is

COMPONENT TEM_ENC port(
	--INPUTS
	K	: in std_logic_vector (127 downto 0);
	flag: in std_logic_vector (23 downto 0);
	N	: in std_logic_vector (103 downto 0);
	i	: in std_logic_vector (5 downto 0);	--NOT YET IMPLEMEMNTED
	j	: in std_logic_vector (1 downto 0);
	
	M	: in std_logic_vector (255 downto 0);
	
	clk : in std_logic;
	rst : in std_logic;
	
	--CIPHER
	CIPHER: out std_logic_vector (255 downto 0)
	);
end COMPONENT TEM_ENC;

COMPONENT TEM_DEC 
port(
	--INPUTS
	K	: in std_logic_vector (127 downto 0);
	flag: in std_logic_vector (23 downto 0);
	N	: in std_logic_vector (103 downto 0);
	i	: in std_logic_vector (5 downto 0);	--NOT YET IMPLEMEMNTED
	j	: in std_logic_vector (1 downto 0);
	
	C	: in std_logic_vector (255 downto 0);
	
	clk : in std_logic;
	rst : in std_logic;
	
	--CIPHER
	MSG: out std_logic_vector (255 downto 0)
	);
end COMPONENT TEM_DEC;

signal CYPHER : std_logic_vector(255 downto 0);

---------------------------------------------
begin
---------------------------------------------



TE00: TEM_ENC PORT MAP
	(
		K		=> K,
		flag	=> flag,
		N		=> N,
		i		=> i,
		j		=> j,
		
		M		=> INPUT,
		
		clk 	=> clk,
		rst 	=> rst,
		
		--CIPHER
		CIPHER 	=> CYPHER

	);
	
TD00: TEM_DEC PORT MAP
	(
		K		=> K,
		flag	=> flag,
		N		=> N,
		i		=> i,
		j		=> j,
		
		C		=> CYPHER,
		
		clk 	=> clk,
		rst 	=> rst,
		
		--CIPHER
		MSG 	=> OUTPUT

	);



end structural;
















