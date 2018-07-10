LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;
------------------------
entity P_testbench is
port(
	clock: in std_logic;
	reset: in std_logic;
	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0);
	finish : out std_logic
	);
end P_testbench;

architecture structural of P_testbench is
------------------------------------------------

COMPONENT P_Procedure_16_Rounds 
port(
	clock: in std_logic;
	reset: in std_logic;
	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0);
	finish : out std_logic
	);
end COMPONENT P_Procedure_16_Rounds;

COMPONENT P_Back_Proc_16_Rounds 
port(
	clock: in std_logic;
	reset: in std_logic;
	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0);
	finish : out std_logic
	);
end COMPONENT P_Back_Proc_16_Rounds;

signal interconnect : std_logic_vector (255 downto 0);
signal EN : std_logic;

-------------------------------

begin
  
  P0: P_procedure_16_rounds port map
  (
    clock => clock,
    reset => reset,
    INPUT_BITS => input_bits,
    OUTPUT_bits => interconnect,
    finish => EN
  );
  
  
  P1: P_Back_Proc_16_Rounds port map
  (
    clock => clock,
    reset => EN,
    INPUT_BITS => interconnect,
    OUTPUT_bits => output_bits,
    finish => finish
  );
  
end structural;