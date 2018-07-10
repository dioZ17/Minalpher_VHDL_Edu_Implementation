LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY mul_2to1 IS
port(I0,I1,S:IN std_logic;Y:OUT std_logic);
end mul_2to1;
architecture arch_mul of mul_2to1 is
  begin
    Y<=((not S) and I0) or (S and I1);

  end arch_mul;

