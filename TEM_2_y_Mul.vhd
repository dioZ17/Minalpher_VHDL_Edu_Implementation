
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;


------------------------
entity y_mul is
port(

	--clk : in std_logic;
	rst : in std_logic;
	INPUT: in std_logic_vector (255 downto 0);
	output: out std_logic_vector (255 downto 0)
	);
end y_mul;
----------------------
architecture behvr of y_mul is

	COMPONENT x_mul port
		(
		rst : in std_logic;
		INPUT: in std_logic_vector (7 downto 0);
		output: out std_logic_vector (7 downto 0)
		);
	end COMPONENT x_mul;


signal mul_tmp : std_logic_vector(255 downto 0);

-----------------------

begin

 XM00: x_mul port map(
			rst 	=> rst,
			INPUT	=> INPUT(255 downto 248),
			output  => mul_tmp(7 downto 0)--x_out_wire
			);

	mul_tmp(255 downto 32) <= input(247 downto 24);
	mul_tmp(31 downto 24) <= INPUT(23 downto 16) xor INPUT(255 downto 248);	--byte 3	
	mul_tmp(23 downto 16) <= INPUT(15 downto 8) xor INPUT(255 downto 248); 	--byte 2
	mul_tmp(15 downto 8) <= INPUT(7 downto 0);
	
process(rst, mul_tmp)
	begin
		if (rst = '1') then
			 OUTPUT <= (255 downto 0 =>'0');  
		else
			OUTPUT <= mul_tmp;
		end if;
end process;



	
-- process(clk, rst)
 --begin
 -- if (rst='1') then   
--				  OUTPUT <= (255 downto 0 =>'0');  
--else
 --if(clk'event and clk = '1')then
--	OUTPUT <= mul_tmp;
--    end if;
-- end if;
-- end process;

--y^i*(y^j+1) = y^i +y^i*y^j
--OUTPUT <= mul_tmp;

end behvr;
--------------------------
