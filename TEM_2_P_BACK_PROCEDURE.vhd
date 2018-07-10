

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
------------------------
entity P_Back_Proc is
port(
	r: in std_logic_vector(3 downto 0);

	INPUT_BITS: in std_logic_vector (255 downto 0);
	OUTPUT_BITS: out std_logic_vector (255 downto 0)
	);
end P_Back_Proc;
----------------------
architecture synthesis of P_Back_Proc is
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

	--signal ONB : nibble_matrix;
	signal RCO_TMP : std_logic_vector(127 downto 0);
	signal RCO : std_logic_vector(127 downto 0);

	signal RAXM : std_logic_vector(127 downto 0);
	signal RBXM : std_logic_vector(127 downto 0);
	
	signal RAMC : std_logic_vector(127 downto 0);
	signal RBMC : std_logic_vector(127 downto 0);
	
	signal BEX : std_logic_vector(127 downto 0);
	
	signal AOS : std_logic_vector(127 downto 0);
	signal BOS : std_logic_vector(127 downto 0);
	
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
					OUTPUT_NIBBS: out std_logic_vector (127 downto 0)
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
		 PORT MAP( 	--clk => clock,
				--rst => reset,
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
				OUTPUT_NIBBS => RCO--_TMP
			);

				--FIX NIBBS TO BITS
				--RCO_TMP <= CONV_NIBBS_TO_LOGIC(ONB);

-----------------------------------------------------------------
--XOR AND MIX COLUMNS OF ROUND CONST -- THIS HAS BEEN CHANGED WITH RC xor B and then M
-----------------------------------------------------------------
--In this section of the b_proc we are asked to calculate the round constant
--in M E(r-i) but E is a 127 bit vector. Assuming the rest less sig bits are 0
--RAXM = RBXM therefore we will just MC the RC 
-----------------------------------------------------------------
	--RAXM => RCO;
	
--	G7 : FOR n IN 7 DOWNTO 0 GENERATE 
--	MC02:MixColumns
--		 PORT MAP( 	
--				INPUT_NIBS(15 downto 12) => RCO_TMP(4*4*(n+1)-1 downto 4*4*(n+1)-4),
--				INPUT_NIBS(11 downto 8) => RCO_TMP(4*3*(n+1)-1 downto 4*3*(n+1)-4),
--				INPUT_NIBS(7 downto 4) => RCO_TMP(4*2*(n+1)-1 downto 4*2*(n+1)-4),
--				INPUT_NIBS(3 downto 0) => RCO_TMP(4*(n+1)-1 downto 4*(n+1)-4),
--
--				OUTPUT_NIBS => RCO(16*n+15 downto 16*n)
--			);
--	END GENERATE G7;
-------------------------------------------------------------------
BEX <= RCO xor BMC xor AMC;

	G7 : FOR n IN 7 DOWNTO 0 GENERATE 
	MC02:MixColumns
		 PORT MAP( 	
				INPUT_NIBS(15 downto 12) => AMC(4*4*(n+1)-1 downto 4*4*(n+1)-4),
				INPUT_NIBS(11 downto 8) => AMC(4*3*(n+1)-1 downto 4*3*(n+1)-4),
				INPUT_NIBS(7 downto 4) => AMC(4*2*(n+1)-1 downto 4*2*(n+1)-4),
				INPUT_NIBS(3 downto 0) => AMC(4*(n+1)-1 downto 4*(n+1)-4),

				OUTPUT_NIBS => AOS(16*n+15 downto 16*n)
			);
	END GENERATE G7;
	
	G8 : FOR n IN 7 DOWNTO 0 GENERATE 
	MC02:MixColumns
		 PORT MAP( 	
				INPUT_NIBS(15 downto 12) => BEX(4*4*(n+1)-1 downto 4*4*(n+1)-4),
				INPUT_NIBS(11 downto 8) => BEX(4*3*(n+1)-1 downto 4*3*(n+1)-4),
				INPUT_NIBS(7 downto 4) => BEX(4*2*(n+1)-1 downto 4*2*(n+1)-4),
				INPUT_NIBS(3 downto 0) => BEX(4*(n+1)-1 downto 4*(n+1)-4),

				OUTPUT_NIBS => BOS(16*n+15 downto 16*n)
			);
	END GENERATE G8;

-----------------------------------------------------------------
--END ROUND / OUPTUTS
-----------------------------------------------------------------
	
	OUTPUT_BITS(255 downto 128) <= AOS;--AMC;
	OUTPUT_BITS(127 downto 0) <= BOS;--RCO xor BMC;

	end synthesis;
--------------------------