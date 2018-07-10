LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE WORK.MINALPHER_PKG.ALL;
USE IEEE.NUMERIC_STD.ALL;
------------------------
--This architecture of the Complete P function
--is syncronous and consists of one P process
--running 17 loops + 1 for the last round
--It takes 1 cc for reset
--1 for initialization of the input dff
--16 cc for the P_process loop
--and outputs the result in a total of 17 cc
--after the reset
------------------------
entity P_Procedure_16_Rounds is
port(
	clock: in std_logic;
	reset: in std_logic;
	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0);
	finish : out std_logic
	);
end P_Procedure_16_Rounds;
---------------------------------------
architecture structural of P_Procedure_16_Rounds is

--COMPONENTS

    COMPONENT counter 
        
             port(Clock, CLR : in  std_logic;
        
             Q : out std_logic_vector(3 downto 0));
        
    end COMPONENT counter;
	
	COMPONENT dff PORT
	(
		d, clk, rst: in std_logic;
		q: out std_logic
	);
	END COMPONENT dff;
	
	COMPONENT mul_2to1 PORT
	(
		I0,I1,S:IN std_logic;Y:OUT std_logic
	);
	END COMPONENT mul_2to1;
	
	COMPONENT SubNibbler PORT
			(
			
			bytein: in std_logic_vector(3 downto 0);
			byteout: out std_logic_vector(3 downto 0)
			);
	end COMPONENT SubNibbler;
 
 
-------------------4 different shuffle rows my god----------------
	COMPONENT ShuffleRows1 PORT(
					INPUT_NIBS: in std_logic_vector (31 downto 0);
					OUTPUT_NIBS: out std_logic_vector (31 downto 0)
				);
	END COMPONENT ShuffleRows1;

	COMPONENT ShuffleRows2 PORT(
					INPUT_NIBS: in std_logic_vector (31 downto 0);
					OUTPUT_NIBS: out std_logic_vector (31 downto 0)
				);
	END COMPONENT ShuffleRows2;
	
	COMPONENT ShuffleRows1_reverse PORT(
					INPUT_NIBS: in std_logic_vector (31 downto 0);
					OUTPUT_NIBS: out std_logic_vector (31 downto 0)
				);
	END COMPONENT ShuffleRows1_reverse;

	COMPONENT ShuffleRows2_reverse PORT(
					INPUT_NIBS: in std_logic_vector (31 downto 0);
					OUTPUT_NIBS: out std_logic_vector (31 downto 0)
				);
	END COMPONENT ShuffleRows2_reverse;
-----------------------------------------------------------------
	
	COMPONENT P_procedure PORT
			(
			r: in std_logic_vector(3 downto 0);
			--clock: in std_logic;
			--reset: in std_logic;
			INPUT_BITS: in std_logic_vector (255 downto 0);
			OUTPUT_BITS: out std_logic_vector (255 downto 0)
			);
	END COMPONENT P_procedure;
	
  COMPONENT freeze_signal is 
     port(
      INPUT : in std_logic_vector(255 downto 0);
      Clock, CLR : in  std_logic;
      Limit: in std_logic_vector(7 downto 0);
      OUTPUT : out std_logic_vector(255 downto 0);
	  Maxd : out std_logic
      );
      
   end COMPONENT freeze_signal;
--WIRES
signal mux_init : std_logic;
--signal dff_in  	: std_logic_vector(255 downto 0);
signal dff_out  : std_logic_vector(255 downto 0);
signal P_in	: std_logic_vector(255 downto 0);
signal P_out	: std_logic_vector(255 downto 0);
--signal init_sel : std_logic;
signal round 	: std_logic_vector(3 downto 0);

signal lr_interconnect1 : std_logic_vector(255 downto 0);
signal lr_interconnect2 : std_logic_vector(255 downto 0);
signal lr_interconnect3 : std_logic_vector(255 downto 0);

signal out_Freeze : std_logic_vector(255 downto 0);

begin
------------------------
--Dff Initializer
------------------------
--IDFF: dff
--	PORT MAP(
--				d=>"not"(reset),
--				rst=>reset,
--				clk =>clock,
--				q => init_sel
--			);


--GI: FOR n IN 255 downto 0 GENERATE
--IMUX: mul_2to1
--	PORT MAP(
--				I0 => INPUT_BITS(n),
--				I1 => P_out(n),
--				S  => init_sel,
--				Y  => dff_in(n)
--			);
--END GENERATE GI;


------------------------
            
CNT: Counter PORT MAP
			(
			Clock 	=> clock,
			CLR		=> reset,--"not"(init_sel),
             Q 		=> round(3 downto 0)
			 );
        


G0: FOR n IN 255 DOWNTO 0 GENERATE
DFF00: dff
	PORT MAP(
				d => P_out(n),--dff_in(n),
				clk => clock,
				rst => reset,
				q => dff_out(n)
			);
END GENERATE G0;


----------------------------
--Mux Initializer WITH dff rst stall
----------------------------
DFFST: dff
	PORT MAP(
				d => reset,--dff_in(n),
				clk => clock,
				rst => '0',
				q => mux_init
			);


GM: FOR n IN 255 downto 0 GENERATE
IMUX: mul_2to1
	PORT MAP(
				I0 => dff_out(n),
				I1 => INPUT_BITS(n),
				S  => mux_init,
				Y  => P_in(n)
			);
END GENERATE GM;

----------------------------
--G1 : FOR n IN 0 TO 15 GENERATE
P00:P_procedure
	PORT MAP(
			r=> round, --round const
			--clock=>clock,
			--reset=>reset,
			INPUT_BITS => P_in,
			OUTPUT_BITS=> P_out
		);
--END GENERATE G1;

lr_interconnect1 <= P_out;

--LAST ROUND CONSTANT
G2 : FOR n IN 63 DOWNTO 0 GENERATE
SN00:SubNibbler
	PORT MAP(
			bytein => lr_interconnect1(n*4+3 downto n*4),
			byteout => lr_interconnect2(n*4+3 downto n*4)
			);
END GENERATE G2;


--G3 : FOR n IN 7 DOWNTO 4 GENERATE
--SR00:ShuffleRows1
--	PORT MAP(
--			INPUT_NIBS => lr_interconnect2(n*32+31 downto n*32),
--			OUTPUT_NIBS => lr_interconnect3(n*32+31 downto n*32)
--			);
--END GENERATE G3;	
--
--G4 : FOR n IN 3 DOWNTO 0 GENERATE
--SR01:ShuffleRows2
--	PORT MAP(
--			INPUT_NIBS => lr_interconnect2(n*32+31 downto n*32),
--			OUTPUT_NIBS => lr_interconnect3(n*32+31 downto n*32)
--			);
--END GENERATE G4;	

--FINAL ROUND SHUFFLE ROWS
	--SHUFFLE B MATRIX's ROWS
	
			SRA3:ShuffleRows2_reverse
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*3+31 downto 32*3),
				OUTPUT_NIBS => lr_interconnect3(32*3+31 downto 32*3)
			);
		

		SRA2:ShuffleRows1_reverse
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*2+31 downto 32*2),
				OUTPUT_NIBS => lr_interconnect3(32*2+31 downto 32*2)
			);
			
		SRA1:ShuffleRows2
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*1+31 downto 32*1),
				OUTPUT_NIBS => lr_interconnect3(32*1+31 downto 32*1)
			);
		

		SRA0:ShuffleRows1
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*0+31 downto 32*0),
				OUTPUT_NIBS => lr_interconnect3(32*0+31 downto 32*0)
			);
	
	--SHUFFLE A MATRIX's ROWS
		SRB3:ShuffleRows2
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*7+31 downto 32*7),
				OUTPUT_NIBS => lr_interconnect3(32*7+31 downto 32*7)
			);
		

		SRB2:ShuffleRows1
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*6+31 downto 32*6),
				OUTPUT_NIBS => lr_interconnect3(32*6+31 downto 32*6)
			);
			
		SRB1:ShuffleRows2_reverse
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*5+31 downto 32*5),
				OUTPUT_NIBS => lr_interconnect3(32*5+31 downto 32*5)
			);
		

		SRB0:ShuffleRows1_reverse
		 PORT MAP( 	
				INPUT_NIBS => lr_interconnect2(32*4+31 downto 32*4),
				OUTPUT_NIBS => lr_interconnect3(32*4+31 downto 32*4)
			);

		




OUT_FREEZE(255 downto 128) <= lr_interconnect3(127 downto 0);
OUT_FREEZE(127 downto 0) <= lr_interconnect3(255 downto 128);


		frez:	freeze_signal 
     port MAP 
     (
      INPUT => OUT_FREEZE,
      Clock => clock,
      CLR   => reset, 
      Limit => "00010000", --counter out_bits are 4 so 16 rounds it is--"00010000", --starts counting from zero so 16-> 17 rounds
      OUTPUT => OUTPUT_BITS,
	  Maxd	=> finish
      );
      
			
			

END structural;