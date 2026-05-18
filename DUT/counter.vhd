LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity counter is 
	generic (m: integer :=16
					);
	Port ( 
	clk,en,rst : in std_logic;
	EQUY:in std_logic;
	count: out std_logic_vector(m-1 downto 0));
	end counter ;
architecture cnt of counter is 
signal counter :std_logic_vector(m-1 downto 0);
BEGIN
lp1: process(clk,rst) 
begin
		if rising_edge(clk) then
			if (rst='1' or EQUY='1') then 
				counter<=(others=>'0'); --- in case we arrive to the max value we demand or we rst the counter 
			elsif en='1' then  
				counter<=counter+'1'; 
			end if;
		end if;
	end process;
count<=counter;
end cnt;
