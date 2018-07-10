-----------------------
--This is an asyncronous system
--that outputs the multiplication 
--of A(y+1)^j for 0<= j <= 2
--Drive 3 subsystems to a 4to1 mux
--2: Ay^2 + 2Ay + A
--1: Ay+A
--0: A
------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity y_plus_1_mul_at_j is
port(
	rst : in std_logic;
	j : in std_logic_vector(1 downto 0);
	INPUT : in std_logic_vector(255 downto 0);
	OUTPUT: out std_logic_vector(255 downto 0)
	);
end y_plus_1_mul_at_j;
----------------------
architecture struct of y_plus_1_mul_at_j is

	COMPONENT mul_2to1 port
	(
	I0,I1,S:IN std_logic;Y:OUT std_logic);
	end COMPONENT mul_2to1;

	COMPONENT y_mul PORT
		(
		rst : in std_logic;
		INPUT: in std_logic_vector (255 downto 0);
		output: out std_logic_vector (255 downto 0)
		);
	END COMPONENT y_mul;

	COMPONENT full_adder_1 PORT
	(
	A : in STD_LOGIC;
	B : in STD_LOGIC;
	Cin : in STD_LOGIC;
	S : out STD_LOGIC;
	Cout : out STD_LOGIC);
	end COMPONENT full_adder_1;

	
	--signal outp_wire: std_logic_vector(255 downto 0);
	signal ymulA : std_logic_vector(255 downto 0);
	signal mux0_out : std_logic_vector(255 downto 0);
	signal ymul_to_add : std_logic_vector(255 downto 0);
	signal ya_shift : std_logic_vector(255 downto 0);
	signal add2add_4mux0 : std_logic_vector(255 downto 0);
	signal in_mux1 : std_logic_vector(255 downto 0);
	--signal mux0_to_mux2 : std_logic_vector(255 downto 0);	
	signal carry_interconnect : std_logic_vector(256 downto 0);
	signal carry_interconnect2 : std_logic_vector(256 downto 0);
	signal j_or				:std_logic;
	
------------------------
begin


--First y*A
-------------------------------------
	YM00: y_mul port map(
			rst 	=> rst,
			INPUT	=> INPUT,
			output  => ymulA
			);
			
--y^2*A
--------------------------------------
	YM01: y_mul port map(
	rst 	=> rst,
	INPUT	=> ymulA,
	output  => ymul_to_add
	);

--2y*A
--------------------------------------
		ya_shift(255 downto 1) <= ymulA(254 downto 0);
		ya_shift(0) <= '0';
		carry_interconnect(0) <='0';
	

--Add y^2*A + 2y*A
-------------------------------------
	GA1 : FOR n IN 255 downto 0 GENERATE
	FA00: full_adder_1 PORT MAP
			(
						
			A => ymul_to_add(n),
			B => ya_shift(n),
			Cin => carry_interconnect(n),
			S => Add2Add_4mux0(n),
			Cout => carry_interconnect(n+1)--clock=>clock,
			);
	END GENERATE GA1;
	
	carry_interconnect2(0) <='0';
	
--MUX 1 : bit 0 -> j = {2,1}
--------------------------------------
		GM0: FOR n IN 255 downto 0 GENERATE
	M00: mul_2to1 port map(
		I0 => Add2Add_4mux0(n),
		I1 => ymulA(n),
		S  => j(0),
		Y  => mux0_out(n) 
		);
	END GENERATE GM0;
	
--2nd Adder
--------------------------------------
	GA2 : FOR n IN 255 downto 0 GENERATE
	FA00: full_adder_1 PORT MAP
			(
						
			A => mux0_out(n),
			B => INPUT(n),
			Cin => carry_interconnect2(n),
			S => in_mux1(n),
			Cout => carry_interconnect2(n+1)--clock=>clock,
			);
	END GENERATE GA2;
	
	--j Or
	j_or <= j(1) or j(0);
	
	---MUX for OR j----
	GM1: FOR n IN 255 downto 0 GENERATE
	M01: mul_2to1 port map(
		I0 => INPUT(n),
		I1 => in_mux1(n),
		S  => j_or,
		Y  => OUTPUT(n) 
		);
	END GENERATE GM1;
		

end struct;
--------------------------


