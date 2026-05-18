LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

----------------------------------
entity top is
generic (n: integer :=16;
		 m: integer :=8
	);
	port(
	clk,en,rst : in std_logic;
	y,x: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	ALUout_o: OUT STD_LOGIC_VECTOR(m-1 downto 0);
	Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC;
	PWMout: out std_logic
	);
end top;

architecture top_dft of top is
signal X_i,Y_i : STD_LOGIC_VECTOR(m-1 DOWNTO 0);
signal X_DCS,Y_DCS : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
begin
X_i <= x(m-1 DOWNTO 0);
Y_i <= y(m-1 DOWNTO 0);
X_DCS <= x when ALUFN_i(4 DOWNTO 3)="00" else (others=>'0'); 
Y_DCS <= y when ALUFN_i(4 DOWNTO 3)="00" else (others=>'0');	
	sdc_pm: SDC generic map(16) port map(clk,en,rst,X_DCS,Y_DCS,ALUFN_i,PWMout);
	alu_pm: alu 
  generic map(n => 8, k => 4, m => 16)
  port map(
    Y_in      => Y_i,
    X_in      => X_i,
    ALUFN_i   => ALUFN_i,
    ALUout_o  => ALUout_o,
    Nflag_o   => Nflag_o,
    Cflag_o   => Cflag_o,
    Zflag_o   => Zflag_o,
    Vflag_o   => Vflag_o
  );
end top_dft;
	