
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------
entity P_Procedure is
port(
	r: in std_logic_vector(3 downto 0);

	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0)
	);
end P_Procedure;
----------------------
architecture structural of P_Procedure is
	signal ASN : std_logic_vector(127 downto 0);
	signal BSN : std_logic_vector(127 downto 0);

	signal ASR : std_logic_vector(127 downto 0);
	signal BSR : std_logic_vector(127 downto 0);

	signal ASM : std_logic_vector(127 downto 0);
	signal BSM : std_logic_vector(127 downto 0);

	signal AXM : std_logic_vector(127 downto 0);
	signal BXM : std_logic_vector(127 downto 0);

	signal AMC : std_logic_vector(127 downto 0);
	signal BMC : std_logic_vector(127 downto 0);
	signal RCO : std_logic_vector(127 downto 0);
	
	COMPONENT subNibbler PORT(	
					bytein: in std_logic_vector(3 downto 0);
					byteout: out std_logic_vector(3 downto 0)
				);
	END COMPONENT subNibbler;
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
	COMPONENT MixColumns PORT( 
					INPUT_NIBS: in std_logic_vector (15 downto 0);
					OUTPUT_NIBS: out std_logic_vector (15 downto 0)
				);
	END COMPONENT MixColumns;

	COMPONENT RoundConstant PORT(
					r: in std_logic_vector (3 downto 0);
					OUTPUT_NIBBS: out std_logic_vector(127 downto 0)
				);
	END COMPONENT RoundConstant;


begin
-----------------------------------------------------------------
---SUBSTITUTE NIBBLES
-----------------------------------------------------------------
	G1 : FOR n IN 31 DOWNTO 0 GENERATE 
	SN00:subNibbler
		 PORT MAP( 	--clk => clock,
				--rst => reset,
				bytein(3) => INPUT_BITS(n*4+3),
				bytein(2) => INPUT_BITS(n*4+2),
				bytein(1) => INPUT_BITS(n*4+1),
				bytein(0) => INPUT_BITS(n*4),

				byteout(3) => BSN(n*4+3),
				byteout(2) => BSN(n*4+2),
				byteout(1) => BSN(n*4+1),
				byteout(0) => BSN(n*4)

			);
		END GENERATE G1;


	G2 : FOR n IN 63 DOWNTO 32 GENERATE 
	SN01:subNibbler
		 PORT MAP( 	
				bytein(3) => INPUT_BITS(n*4+3),
				bytein(2) => INPUT_BITS(n*4+2),
				bytein(1) => INPUT_BITS(n*4+1),
				bytein(0) => INPUT_BITS(n*4),

				byteout(3) => ASN((n-32)*4+3),
				byteout(2) => ASN((n-32)*4+2),
				byteout(1) => ASN((n-32)*4+1),
				byteout(0) => ASN((n-32)*4)

			);
		END GENERATE G2;

-----------------------------------------------------------------
--SHUFFLE ROWS
-----------------------------------------------------------------

	--SHUFFLE B MATRIX's ROWS
			SRB3:ShuffleRows2_reverse
		 PORT MAP( 	
				INPUT_NIBS => BSN(32*3+31 downto 32*3),
				OUTPUT_NIBS => BSR(32*3+31 downto 32*3)
			);
		

		SRB2:ShuffleRows1_reverse
		 PORT MAP( 	
				INPUT_NIBS => BSN(32*2+31 downto 32*2),
				OUTPUT_NIBS => BSR(32*2+31 downto 32*2)
			);
			
		SRB1:ShuffleRows2
		 PORT MAP( 	
				INPUT_NIBS => BSN(32*1+31 downto 32*1),
				OUTPUT_NIBS => BSR(32*1+31 downto 32*1)
			);
		

		SRB0:ShuffleRows1
		 PORT MAP( 	
				INPUT_NIBS => BSN(32*0+31 downto 32*0),
				OUTPUT_NIBS => BSR(32*0+31 downto 32*0)
			);
	
	--SHUFFLE A MATRIX's ROWS
		SRA3:ShuffleRows2
		 PORT MAP( 	
				INPUT_NIBS => ASN(32*3+31 downto 32*3),
				OUTPUT_NIBS => ASR(32*3+31 downto 32*3)
			);
		

		SRA2:ShuffleRows1
		 PORT MAP( 	
				INPUT_NIBS => ASN(32*2+31 downto 32*2),
				OUTPUT_NIBS => ASR(32*2+31 downto 32*2)
			);
			
		SRA1:ShuffleRows2_reverse
		 PORT MAP( 	
				INPUT_NIBS => ASN(32*1+31 downto 32*1),
				OUTPUT_NIBS => ASR(32*1+31 downto 32*1)
			);
		

		SRA0:ShuffleRows1_reverse
		 PORT MAP( 	
				INPUT_NIBS => ASN(32*0+31 downto 32*0),
				OUTPUT_NIBS => ASR(32*0+31 downto 32*0)
			);

-----------------------------------------------------------------
--SWAP MATRICES
-----------------------------------------------------------------

	BSM <= ASR;
	ASM <= BSR;

-----------------------------------------------------------------
--XOR MATRICES
-----------------------------------------------------------------

	AXM <= ASM;
	BXM <= ASM xor BSM;

-----------------------------------------------------------------
--MIX COLUMNS
-----------------------------------------------------------------
--INDEX FORMULA IS 32 Col_i + 4 Row_i + 3|0

	G5 : FOR n IN 7 DOWNTO 0 GENERATE 
	MC00:MixColumns
		 PORT MAP( 	
	
				INPUT_NIBS(15 downto 12) => AXM(32*3+4*n+3 downto 32*3+4*n),
				INPUT_NIBS(11 downto 8) => AXM(32*2+4*n+3 downto 32*2+4*n),
				INPUT_NIBS(7 downto 4) => AXM(32*1+4*n+3 downto 32*1+4*n),
				INPUT_NIBS(3 downto 0) => AXM(32*0+4*n+3 downto 32*0+4*n),
	
				
				--OUTPUT_NIBS => AMC(16*n+15 downto 16*n)
				OUTPUT_NIBS(15 downto 12) => AMC(32*3+4*n+3 downto 32*3+4*n),
				OUTPUT_NIBS(11 downto 8) => AMC(32*2+4*n+3 downto 32*2+4*n),
				OUTPUT_NIBS(7 downto 4) => AMC(32*1+4*n+3 downto 32*1+4*n),
				OUTPUT_NIBS(3 downto 0) => AMC(32*0+4*n+3 downto 32*0+4*n)
			);
		END GENERATE G5;
	
	G6 : FOR n IN 7 DOWNTO 0 GENERATE 
	MC01:MixColumns
		 PORT MAP( 	
				INPUT_NIBS(15 downto 12) => BXM(32*3+4*n+3 downto 32*3+4*n),
				INPUT_NIBS(11 downto 8) => BXM(32*2+4*n+3 downto 32*2+4*n),
				INPUT_NIBS(7 downto 4) => BXM(32*1+4*n+3 downto 32*1+4*n),
				INPUT_NIBS(3 downto 0) => BXM(32*0+4*n+3 downto 32*0+4*n),
				
				
				--OUTPUT_NIBS => BMC(16*n+15 downto 16*n)
				OUTPUT_NIBS(15 downto 12) => BMC(32*3+4*n+3 downto 32*3+4*n),
				OUTPUT_NIBS(11 downto 8) => BMC(32*2+4*n+3 downto 32*2+4*n),
				OUTPUT_NIBS(7 downto 4) => BMC(32*1+4*n+3 downto 32*1+4*n),
				OUTPUT_NIBS(3 downto 0) => BMC(32*0+4*n+3 downto 32*0+4*n)
			);
		END GENERATE G6;
-----------------------------------------------------------------
--ROUND FUNCTION
-----------------------------------------------------------------

	RC:RoundConstant
		PORT MAP(
				r => r,
				OUTPUT_NIBBS => RCO
			);
-----------------------------------------------------------------
--END ROUND / OUPTUTS
-----------------------------------------------------------------
	
	OUTPUT_BITS(255 downto 128) <= AMC;
	OUTPUT_BITS(127 downto 0) <= RCO xor BMC;

	end structural;
--------------------------







