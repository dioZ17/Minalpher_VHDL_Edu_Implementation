library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity JK_ff is 
	 port(
		rst : in std_logic;
		J,K: in std_logic;
		Clock : in  std_logic;
		Q, not_Q: out std_logic
		);
		
 end JK_ff;

Architecture behavioral of JK_FF is
begin
PROCESS(CLOCK)
variable TMP: std_logic;
begin
if (rst='1') then
	TMP:='0';
--else if (set = '1') then
--	TMP:='1';
	else

if(CLOCK='1' and CLOCK'EVENT) then
if(J='0' and K='0')then
TMP:=TMP;
elsif(J='1' and K='1')then
TMP:= "not"(TMP);
elsif(J='0' and K='1')then
TMP:='0';
else
TMP:='1';
end if;
end if;

end if;
--end if;
Q<=TMP;
not_Q <="not"(TMP);
end PROCESS;
end behavioral;
 
--  architecture structural of JK_ff is  
  
--  signal K_and : std_logic;
--  signal J_and : std_logic;
--  signal K_nor : std_logic;
--  signal J_nor : std_logic;
  
  
--	begin
	
--	K_and <= K_nor and K and Clock;
--	J_and <= J_nor and J and Clock;
--	K_nor <= K_and nor J_nor;
--	J_nor <= J_and nor K_nor;
--	
--	Q <= K_nor;
--	not_Q <= J_nor;
--	
--	end structural;
