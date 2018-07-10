-----------------------
--This is a syncronous system
--that outputs the multiplication 
--of A by y+1 in 1cc
------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity y_plus_1_mul is
port(
	rst : in std_logic;
	clk : in std_logic;
	INPUT : in std_logic_vector(255 downto 0);
	OUTPUT: out std_logic_vector(255 downto 0)
	);
end y_plus_1_mul;
----------------------
architecture bhvr of y_plus_1_mul is

	COMPONENT dff port 
	(
		d, clk, rst: in std_logic;
		q: out std_logic
	);
	end COMPONENT dff;
 
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
	signal mux_to_FA : std_logic_vector(255 downto 0);
	signal dff_to_mux : std_logic_vector(255 downto 0);
	signal Y_to_dff : std_logic_vector(255 downto 0);
	signal FA_to_Y : std_logic_vector(255 downto 0);
	signal carry_interconnect : std_logic_vector(256 downto 0);

	
------------------------
begin



	carry_interconnect(0) <='0';

	G3: FOR n IN 255 downto 0 GENERATE
	D00: dff port map(
		d => Y_to_dff(n),
		clk => clk,
		rst => rst,
		q => dff_to_mux(n)
	);
	end GENERATE G3;
	
	G2: FOR n IN 255 downto 0 GENERATE
	M00: mul_2to1 port map(
		I0 => dff_to_mux(n),
		I1 => '0',
		S  => rst,
		Y  => mux_to_FA(n) 
		);
	END GENERATE G2;
	
	--G3: FOR n IN 255 downto 0 GENERATE
	--M01: mul_2to1 port map(
	--	I0 => '0',
	--	I1 => Y_to_mux(n),
	--	S  => rst,
	--	Y  => mux_to_FA(n) 
	--	);
	--END GENERATE G3;


	G1 : FOR n IN 255 downto 0 GENERATE
	FA00: full_adder_1 PORT MAP
			(
						
			A => mux_to_FA(n),
			B => INPUT(n),
			Cin => carry_interconnect(n),
			S => FA_to_Y(n),
			Cout => carry_interconnect(n+1)--clock=>clock,
				--reset=>reset,
				
			);
	END GENERATE G1;


	YM00: y_mul port map(
			rst 	=> rst,
			INPUT	=> FA_to_Y,
			output  => y_to_dff
			);
				
			--outp_wire <= Y_to_FA;
		--	OUTPUT <= mux_to_FA;
			
 --process(clk,rst)
 --begin
 --
-- 
 --if (rst='1') then   
--				  OUTPUT <= (255 downto 0 => '0');  
--else
--if(clk'event and clk = '1')then
	OUTPUT <= mux_to_FA;
 --end if;
 --end if;
 --end process;			
			
			

end bhvr;
--------------------------

