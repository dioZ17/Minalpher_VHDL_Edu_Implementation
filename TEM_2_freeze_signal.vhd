
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity freeze_signal is 
	 port(
	  INPUT : in std_logic_vector(255 downto 0);
		Clock, CLR : in  std_logic;
		Limit: in std_logic_vector(7 downto 0);
		OUTPUT : out std_logic_vector(255 downto 0);
		maxd: out std_logic
		);
		
 end freeze_signal;
-------------------------
architecture structural of freeze_signal is

COMPONENT limit_counter 
	 port(
		Clock, CLR : in  std_logic;
		Limit: in std_logic_vector(7 downto 0);
		Q : out std_logic_vector(5 downto 0);
		Maxd : out std_logic
		);
end COMPONENT limit_counter;

--COMPONENT freeze
--	port
--	(
--		maxd 	: in std_logic;
--		INPUT	: in std_logic_vector(255 downto 0);
--		clr		: in std_logic;
--		Q		: out std_logic_vector(255 downto 0)
--		);
--	end COMPONENT freeze;
COMPONENT d_latch_top
	Port
	(
		EN  : in std_logic;
		D	: in std_logic;
		Q	: out std_logic
	);
END COMPONENT d_latch_top;

signal freeze_signal : std_logic;
--signal and_interc    : std_logic_vector( 255 downto 0);
--signal latch_s    : std_logic_vector( 255 downto 0);

-----------------------------
begin
  lcnt: limit_counter Port Map
  (
    clock => clock,
    clr   => clr,
    Limit => Limit,
    Maxd  => Freeze_signal
    );
  
  G1:FOR n IN 255 downto 0 GENERATE
  dlat: d_latch_top PORT Map
  (
	EN  => Freeze_signal,
	D	=> INPUT(n),
	Q	=> OUTPUT(n)
  );
  END GENERATE G1;
  
  maxd <= Freeze_signal;
  
--    frez: freeze Port Map
--    (
--      maxd => freeze_signal,
--      INPUT => INPUT,
--     clr => clr,
 --     Q   => OUTPUT
--      );
 
-- 	process(INPUT, Freeze_signal,clr) 
	--begin
--		FOR n in 255 downto 0 loop
--			and_interc(n) <= INPUT(n) and Freeze_signal;
--			latch_s(n) <= and_interc(n) and "not"(clr);
--		end Loop;
--	end process;
  
--OUTPUT <= latch_s;

 end structural;