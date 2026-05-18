LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY SDC IS
generic (m: integer :=16
				);
	Port ( 
	clk,en,rst : in std_logic;
	x,y :in std_logic_vector(m-1 downto 0);
	ALUFN: in std_logic_vector(4 downto 0);
	PWMout: out std_logic);
	end SDC ;
architecture SDC_dft of SDC is 	
signal counterOut :std_logic_vector(m-1 downto 0);
signal en_in,EQUY_in: std_logic;
signal PWMmode: std_logic_vector(2 downto 0);
signal x_in,y_in : std_logic_vector(m-1 downto 0);
begin

PWMmode<=ALUFN(2 downto 0);
x_in<=x when ALUFN(4 downto 3)="00"	else 
        (others=>'0');	
y_in<=y when ALUFN(4 downto 3)="00" else 
		(others=>'0');
en_in<=en when ALUFN(4 downto 3)="00" else 
		'0';



cntPM: counter generic map(16) port map (clk,en_in,rst,EQUY_in,counterOut);
PWM_PM :PWMUNIT generic map (16) port map (clk,en_in,x_in,y_in,counterOut,PWMmode,PWMout,EQUY_in);
end SDC_dft;