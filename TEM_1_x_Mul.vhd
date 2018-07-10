
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------
entity x_mul is
port(
	rst : in std_logic;
	INPUT: in std_logic_vector (7 downto 0);
	output: out std_logic_vector (7 downto 0)
	);
end x_mul;
----------------------
architecture behvr of x_mul is

signal mul_tmp1 : std_logic_vector(7 downto 0);

begin

-----------------------
	mul_tmp1(7) <= INPUT(6) xor INPUT(7);	--mul x
	mul_tmp1(6) <= INPUT(5);
	mul_tmp1(5) <= INPUT(4) xor INPUT(7);
	mul_tmp1(4) <= INPUT(3);
	mul_tmp1(3) <= INPUT(2);
	mul_tmp1(2) <= INPUT(1);
	mul_tmp1(1) <= INPUT(0) xor INPUT(7);
	mul_tmp1(0) <= INPUT(7);

--------------------------
--To avoid clock complexity
--throughout the higher lvl
--design we will generate this
--asyncronically
--------------------------

process(rst, mul_tmp1)
begin
	if(rst = '1') then
		OUTPUT <= (7 downto 0 => '0');
	else
		OUTPUT <= mul_tmp1;

	end if;
end process;
 


end behvr;
--------------------------

