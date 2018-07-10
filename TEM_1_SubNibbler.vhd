-------
 
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
 

entity SubNibbler is
port(

	bytein: in std_logic_vector(3 downto 0);
	byteout: out std_logic_vector(3 downto 0)
	);
end SubNibbler;
 


architecture rtl of SubNibbler	is

signal A3 : std_logic;
signal A2 : std_logic;
signal A1 : std_logic;
signal A0 : std_logic;
signal A3n : std_logic;
signal A2n : std_logic;
signal A1n : std_logic;
signal A0n : std_logic;
begin


A3 <= bytein(3);
A2 <= bytein(2);
A1 <= bytein(1);
A0 <= bytein(0);
A3n <= "not"(bytein(3));
A2n <= "not"(bytein(2));
A1n <= "not"(bytein(1));
A0n <= "not"(bytein(0));

byteout(3) <= (A3n and A2 and A0)	or (A3n and A2 and A1)	or (A3 and A1n and A0)	or (A3 and A1 and A0n)	or (A3n and A2n and A1n and A0n);--(A3 and A2n and A0) 	or (A3 and A1 and A0n) 	or (A3n and A2 and A1) 	or (A3n and A1n and (A2 xnor A0));
byteout(2) <= (A3n and A1 and A0n)  or (A2n and A1 and A0n) or (A2 and A1 and A0)	or (A3 and A2n and A1n) or (A3 and A1n and A0n);--(A3 and A2n and A1n)	or (A3n and A1 and A0n) or (A2 and A1 and A0) 	or (A3 and A1n and (A2 xor A0));
byteout(1) <= (A3n and A2n and A1n) or (A2 and A1n and A0n)	or (A2 and A1 and A0)	or (A3 and A1 and A0n);
byteout(0) <= (A3n and A2n and A1n)	or (A3 and A2n and A1n) or (A3 and A2 and A0)	or (A3n and A1 and A0);









end rtl;
 