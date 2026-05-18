LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY alu IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=logs(n)
		   m : integer := 16	); 
  PORT 
  ( 
  Y_in,X_in: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END alu;
------------- complete the alu Architecture code --------------
ARCHITECTURE struct OF alu IS 
	SUBTYPE vector IS std_logic_vector (n-1 DOWNTO 0);
	TYPE matrix IS ARRAY (k DOWNTO 0) OF vector;
	SIGNAL s_mat : matrix;
	SIGNAL c_vec,aluadd,alushift,alugic: std_logic_vector(2 DOWNTO 0);
	-- Signals For Sub-Modules Output
	SIGNAL ALUout :STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	SIGNAL x_add,y_add :vector;
	--SIGNAL X_in,Y_in :vector;
	SIGNAL x_Logic,y_Logic: vector;
	SIGNAL x_shifter,y_shifter :vector;
	SIGNAL carry_list :vector; 
	SIGNAL Out_option :matrix;
	signal ALUFN_in : std_logic_vector(4 downto 0);
	constant z_vec : std_logic_vector(n-1 downto 0) := (others => '0');
begin 
ALUFN_in<=ALUFN_i;
	 ----- Logic condition
	 x_Logic<=X_in when ALUFN_in(4 DOWNTO 3)="11" ELSE (others=>'Z');
	 y_Logic<=Y_in when ALUFN_in(4 DOWNTO 3)="11" ELSE (others=>'Z');
	 alugic <= ALUFN_in(2 DOWNTO 0) when ALUFN_in(4 DOWNTO 3) = "11" else "ZZZ";
	 ----end of logic conditions-----
	 ----start shifter-----
	 x_shifter<=X_in when ALUFN_in(4 DOWNTO 3) ="10" else (others => 'Z');----- decalre the x vector for the specific input
	 y_shifter<=Y_in when ALUFN_in(4 DOWNTO 3) ="10" else (others => 'Z');----- decalre the y vector for the specific input
	 alushift<= ALUFN_in(2 DOWNTO 0) when ALUFN_in(4 DOWNTO 3) ="10" else "ZZZ";
	 ------- START of the AdderSub ------
	 x_add<=X_in when ALUFN_in(4 DOWNTO 3) ="01" else (others => 'Z');----- decalre the x vector for the specific input
	 y_add<=Y_in when ALUFN_in(4 DOWNTO 3) ="01" else (others => 'Z');----- decalre the y vector for the specific input
	 aluadd<=ALUFN_in(2 DOWNTO 0) when ALUFN_in(4 DOWNTO 3) ="01" else "ZZZ";
	 ------- end of the defenition of conditions----
	 ----- start map porting-------
addlabel : AdderSub GENERIC map(n)  port map(y_add,x_add,aluadd,carry_list(2),Out_option(2)); --- if the alu is on adder optin we will take the 2 on the list
loglabel : Logic GENERIC map(n) Port map(x_Logic,y_Logic,alugic,Out_option(1)); --the carry alawys 0 when we r on Logic outpot
shiftlabel : Shifter GENERIC map(n,k) Port map(x_shifter,y_shifter,alushift,carry_list(0),Out_option(0));
	 ALUout<= Out_option(0) when (ALUFN_in(4 DOWNTO 3)) ="10" else ---- define the output option for the specfic input 
			    Out_option(1) when ALUFN_in(4 DOWNTO 3) = "11" else ---- define the output option for the specfic input
				Out_option(2) when ALUFN_in(4 DOWNTO 3) = "01" else (others=>'0');---- define the output option for the specfic input
	-----------	Flags---------
	Cflag_o<= carry_list(0)  when (ALUFN_in(4 DOWNTO 3)) ="10" else
			carry_list(2)  when (ALUFN_in(4 DOWNTO 3)) ="01" else '0';
	--------Negative flag-----------
	Nflag_o<= '1' when ALUout(n-1)='1'
				else '0';
	-------V flag-----------
	Vflag_o<= '1' when (ALUFN_in="01000" AND (x_add(n-1) = y_add(n-1)) AND (x_add(n-1) /= ALUout(n-1)))
					else '1' when (ALUFN_in= "01001" AND( x_add(n-1)=ALUout(n-1)and x_add(n-1)/=y_add(n-1)))
					else '0';
	--------zero flag--------
	Zflag_o <= '1' when (unsigned(ALUout)=unsigned(z_vec))
				else '0' ;
	------def of outpot-----
	ALUout_o<=ALUout;
END struct;