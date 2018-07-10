library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity S_R_latch_top is
    Port ( S : in    STD_LOGIC;
           R : in    STD_LOGIC;
           Q : inout STD_LOGIC); -- changed out to inout
end S_R_latch_top;

architecture Behavioral of S_R_latch_top is
signal notQ : STD_LOGIC;
begin

Q    <= R nor notQ;
notQ <= S nor Q;

end Behavioral;