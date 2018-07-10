LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;
------------------------
entity P_testbench_1Round is
port(
	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0)
	);
end P_testbench_1Round;

architecture structural of P_testbench_1Round is
------------------------------------------------

	COMPONENT P_procedure PORT
			(
			r: in std_logic_vector(3 downto 0);
			--clock: in std_logic;
			--reset: in std_logic;
			INPUT_BITS: in std_logic_vector (255 downto 0);
			OUTPUT_BITS: out std_logic_vector (255 downto 0)
			);
	END COMPONENT P_procedure;

	COMPONENT P_Back_proc PORT
			(
			r: in std_logic_vector(3 downto 0);
			--clock: in std_logic;
			--reset: in std_logic;
			INPUT_BITS: in std_logic_vector (255 downto 0);
			OUTPUT_BITS: out std_logic_vector (255 downto 0)
			);
	END COMPONENT P_Back_proc;

signal interconnect : std_logic_vector (255 downto 0);
signal r 			: std_logic_vector (3 downto 0);

-------------------------------


begin
  
  r <= "0001";
  
  P0: P_procedure port map
  (
	r => r,
    INPUT_BITS => input_bits,
    OUTPUT_bits => interconnect
  );
  
  
  P1: P_Back_proc port map
  (
	r => r,	
    INPUT_BITS => interconnect,
    OUTPUT_bits => output_bits
  );
  
end structural;