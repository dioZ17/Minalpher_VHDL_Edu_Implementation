library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_latch_top is
    Port ( D  : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           Q  : out STD_LOGIC);
end d_latch_top;

architecture Behavioral of d_latch_top is
    signal DATA : STD_LOGIC;
begin

    DATA <= D when (EN = '1') else DATA;
    Q <= DATA;

end Behavioral;