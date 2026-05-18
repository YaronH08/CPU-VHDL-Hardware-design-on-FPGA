LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity Logic is 
	generic (n: integer :=8);
	Port ( 
	x,y :in std_logic_vector(n-1 downto 0);
	ALUFN: in std_logic_vector(2 downto 0);
	ALUout: out std_logic_vector(n-1 downto 0));
	end Logic ;
-------------------- architecture STARTS---------
architecture dft_Logic of Logic is
signal x_realtime, y_realtime : std_logic_vector(n-1 downto 0);
begin
x_realtime<=y(n-1 downto 4)&x(3 downto 0);
y_realtime<=y(3 downto 0)&x(n-1 downto 4);
lp1 :  for j in 0 to n-1 generate
	ALUout(j) <= not y(j)	when ALUFN="000" else
				y(j) or x(j)when ALUFN="001" else
				y(j) and x(j)when ALUFN="010" else
				y(j) XOR x(j)when ALUFN="011" else
				y(j) NOR x(j)when ALUFN="100" else
				y(j) NAND x(j)when ALUFN="101" else
				y(j) xnor x(j)when ALUFN="110" else
				y_realtime(j) XOR x_realtime(j) when ALUFN="111" else
				'0';
	end generate;
end dft_Logic;