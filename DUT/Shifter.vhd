LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
---- entity start -----
entity Shifter is 
generic (n : integer :=16;
	 k : integer :=4
	 );
	 
Port ( 
	x,y :in std_logic_vector(n-1 downto 0);
	dir: in std_logic_vector(2 downto 0);--- make a choise to rotate right or left 
	res	: out std_logic_vector(n-1 downto 0);
	cout:OUT std_logic);
	end Shifter;
	------------ archistart-------
architecture dft_Shifter of Shifter is 
 signal c_0 :std_logic;
 SUBTYPE vector IS std_logic_vector (n-1 DOWNTO 0);
	TYPE matrix IS ARRAY ((2**k)-1 DOWNTO 0) OF vector;--- make a matrix for all the options of shifting 0-2**k shifts
	signal th_l,th_r : matrix; --- trash hold matrix for all the shifters
	signal q : integer;
 begin
 q<= to_integer(unsigned(x(k-1 DOWNTO 0)));--- the num of shifts by the sum of x by k bits
	th_l(0)<=y;---- intital start for zero shifting 
 ndlop : for i in 1 to(2**(k)-1) generate--- create a matrix with shifts to the left
	th_l(i)<=th_l(i-1)(n-2 DOWNTO 0) &'0';---the next line is shift left of the priv line 
	end generate;
 flop2 : for t in 1 to ((2**k)-1) generate
	th_r(0)<=y;---- intital start for zero shifting 
	th_r(t)<='0' & th_r(t-1)(n-1 DOWNTO 1);
	
	end generate;
res<= 	th_l(0) when q=0 else 
		th_l(q) when dir = "000" else 
		th_r(q) when dir = "001" else 
		(others=>'0');
cout <='0' when  q = 0 else 
	th_l(q-1)(n-1) when dir = "000" else 
		th_r(q-1)(0) when dir ="001" 
		else  '0';
	end dft_Shifter;