
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;
USE IEEE.NUMERIC_STD.ALL;

------------------------
entity TEM_DEC is
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
end TEM_DEC;
---------------------------------------
architecture synthesis of TEM_DEC is
	
	COMPONENT S_R_latch_top PORT
     (		 S : in    STD_LOGIC;
           R : in    STD_LOGIC;
           Q : inout STD_LOGIC); -- changed out to inout
	end COMPONENT S_R_latch_top;

	
	COMPONENT P_Back_Proc_16_Rounds PORT
			(
			clock: in std_logic;
			reset: in std_logic;
			INPUT_BITS: in std_logic_vector (255 downto 0);
			OUTPUT_BITS: out std_logic_vector (255 downto 0);
			finish: out std_logic
			);
	END COMPONENT P_Back_Proc_16_Rounds;
	
	COMPONENT P_Procedure_16_Rounds PORT
			(
			clock: in std_logic;
			reset: in std_logic;
			INPUT_BITS: in std_logic_vector (255 downto 0);
			OUTPUT_BITS: out std_logic_vector (255 downto 0);
			finish: out std_logic
			);
	END COMPONENT P_Procedure_16_Rounds;

	COMPONENT mans_Multiplier port
	(

	clk : in std_logic;
	rst : in std_logic;

	i: in std_logic_vector (5 downto 0); --64 values
	j: in std_logic_vector (1 downto 0);
	A: in std_logic_vector(255 downto 0);
	
	output: out std_logic_vector (255 downto 0);
	finish : out std_logic
	);
	end COMPONENT mans_Multiplier;
	
	signal K_extend : std_logic_vector(255 downto 0);
	signal P1_out 	: std_logic_vector(255 downto 0);
	signal P2_out 	: std_logic_vector(255 downto 0);
	signal P2_in 	: std_logic_vector(255 downto 0);
	signal L 		: std_logic_vector(255 downto 0);
	signal Mul_out	: std_logic_vector(255 downto 0);
	
	signal C_EN		: std_logic;
	signal C_EN_midi	: std_logic;
	signal CP_EN		: std_logic;
	signal CP_EN_midi	: std_logic;
-------------------------------------------
	
begin

K_extend(255 downto 128) <= K;
K_extend(127 downto 104) <= flag;
K_extend(103 downto 0)	<= N;

--The output of P1 will need 16 cc to complete
L00:P_Procedure_16_Rounds
	PORT MAP(
			clock=>clk,
			reset=>rst,
			INPUT_BITS => K_extend,
			OUTPUT_BITS=> P1_out,
			finish => C_EN_midi
		);

		
		
		--GENERATE L
L <= K_extend xor P1_out;
		
-----CIPHERTEXT GENERATION-------------------
SR00:s_r_latch_top PORT MAP
	(
		R => "not"(C_EN_midi),
		S => rst,
		Q => C_EN
	);



M00:mans_Multiplier port MAP
	(
	clk 	=> clk,
	rst 	=> C_EN,

	i		=> i,
	j 		=> j,
	
	A		=> L,
	
	output	=> Mul_out,
	finish => CP_EN_midi
	);

	
P2_in <= C xor Mul_out;

sr01:s_r_latch_top PORT MAP
	(
		R => "not"(CP_EN_midi),
		S => rst,
		Q => CP_EN
	);

		
L01:P_Back_Proc_16_Rounds
	PORT MAP(
			clock=>clk,
			reset=>CP_EN,
			INPUT_BITS => P2_in,
			OUTPUT_BITS=> P2_out
		);

MSG <= Mul_out xor P2_out;
		
		

END SYNTHESIS;
------------------------------------------------------------------------
--				SIMULATION SCRIPT
--force -freeze sim:/tem_enc/K 128'h00000001000000010000000100000001 0
--force -freeze sim:/tem_enc/flag 24'h000000 0
--force -freeze sim:/tem_enc/N 104'h00000000000000000000000000 0
--force -freeze sim:/tem_enc/i 6'h03 0
--force -freeze sim:/tem_enc/j 6'h03 0
--force -freeze sim:/tem_enc/M 256'h1111111111111111111111111111111111111111111111111111111111111111 0
--force -freeze sim:/tem_enc/clk 1 0, 0 {50 ns} -r 100
--force -freeze sim:/tem_enc/rst 1 0



