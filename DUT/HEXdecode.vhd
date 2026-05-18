LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;


entity HEXdecode is 
generic (z : integer := 4;
		 k : integer := 7);
port ( 
input : in std_logic_vector(z-1 downto 0);
printHEX :out std_logic_vector(k-1 downto 0)
);
end HEXdecode;

architecture dtf_HEX of HEXdecode is 
begin 
printHEX<=  "1000000" when input = "0000" else  ----zero
		    "1111001" when input = "0001" else --- one 
		    "0100100" when input = "0010" else ---- two
		    "0110000" when input = "0011" else -- 3
		    "0011001" when input = "0100" else ---4 
		    "0010010" when input = "0101" else ---5
		    "0000011" when input = "0110" else --6
		    "1111000" when input = "0111" else --7
		    "0000000" when input = "1000" else --8
		    "0011000" when input = "1001" else ---9 
		    "0001000" when input = "1010" else -- A
			"0000011" when input = "1011" else -- B
			"1000110" when input = "1100" else -- C
			"0100001" when input = "1101" else -- D
			"0000110" when input = "1110" else -- E
			"0001110" when input = "1111"   else			   -- F
			"1111111"; -- None

end dtf_HEX;