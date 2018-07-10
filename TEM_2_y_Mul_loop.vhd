LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity y_mul_loop is
port(
	clk : in std_logic;
	rst : in std_logic;
	INPUT: in std_logic_vector (255 downto 0);
	output: out std_logic_vector (255 downto 0)
	);
end y_mul_loop;
----------------------
architecture behvr of y_mul_loop is


	COMPONENT dff port 
	(
		d, clk, rst: in std_logic;
		q: out std_logic
	);
	end COMPONENT dff;
 
	COMPONENT y_mul PORT
		(
		rst : in std_logic;
		--clk : in std_logic;
		INPUT: in std_logic_vector (255 downto 0);
		output: out std_logic_vector (255 downto 0)
		);
	END COMPONENT y_mul;
 
	COMPONENT mul_2to1 port
		(
			I0,I1,S:IN std_logic;Y:OUT std_logic
		);
	end COMPONENT mul_2to1;
	
	signal y_to_dff : std_logic_vector(255 downto 0);
	signal dff_to_mux : std_logic_vector(255 downto 0);
	signal mux_to_y : std_logic_vector(255 downto 0);
	signal mux_select : std_logic;
----------------------

------------------------
	
begin

	G0: FOR n IN 255 downto 0 GENERATE
	dff0: dff PORT MAP
	(
		d => y_to_dff(n),
		clk => clk,
		rst => rst,
		q => dff_to_mux(n)
	);
	END GENERATE G0;
	
	G1: FOR n IN 255 downto 0 GENERATE 
	mu00: mul_2to1 PORT MAP
	(
		I0 => dff_to_mux(n),
		I1 => INPUT(n),
		S 	=> mux_select,
		Y	=> mux_to_y(n)
	);
	END GENERATE G1;


	ym00: y_mul PORT MAP
	(
		rst => rst,
		--clk => clk,
		INPUT	=> mux_to_y,
		OUTPUT	=> y_to_dff
	);

	dff1 : dff PORT MAP
	(
		d => rst,
		clk => clk,
		rst => '0',
		q => mux_select
	);

	OUTPUT <= y_to_dff;
	
end behvr;


