LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity GPIO is generic(
n : integer := 8 ;
m :integer := 16;
k :integer := 7 
);
port ( clk : in std_logic;
	   KEY0,KEY1,KEY2,KEY3 :IN std_logic;
	   SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9 : IN std_logic;
	   HEX5,HEX4,HEX3,HEX2,HEX1,HEX0 : out std_logic_vector(k-1 downto 0);
	   LEDs  	 : out std_logic_vector(9 downto 0);
	   PWM    :OUT std_logic
);
end GPIO;
architecture dft_GPIO of GPIO is 
signal Y_top,X_top: std_logic_vector(m-1 downto 0);
signal ALUFN_top   : std_logic_vector(4   downto 0);
signal Y_HEX,X_HEX,low_x,high_x,low_y,high_y,alufn_reg : std_logic_vector(n-1 downto 0);
signal MHZ2 :std_logic;
signal ALUOUT : std_logic_vector(n-1 DOWNTO 0);
signal low_val,high_val : std_logic_vector(3 DOWNTO 0);
signal HEX5temp,HEX4temp,HEX3temp,HEX2temp,HEX1temp,HEX0temp : std_logic_vector(k-1 DOWNTO 0);
signal PrintHEX2,PrintHEX3,PrintHEX1,PrintHEX0 : std_logic_vector(3 downto 0);
signal key3real,key2real,key1real,key0real :std_logic;
begin
low_val <= SW3&SW2&SW1&SW0;
high_val <= SW7&SW6&SW5&SW4;
key3real<=not(KEY3);
key2real<=not(KEY2);
key1real<=not(KEY1);
key0real<=not(KEY0);

PLL_pm:PLL port map(open,clk,MHZ2,open);
process(MHZ2,key3real,key2real,key1real,key0real,SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9)
begin
	if rising_edge(MHZ2) then 
			if (key0real='1') then 
				if SW9='1' then 
					high_y <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0;
			
					else 
					low_y <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0;
				end if;
			end if;
			
			if (key1real='1') then 
				if SW9='1' then 
					high_x <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0;
						else 
						low_x <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0;
				end if;
			end if;
				
			
			if (key2real='1' ) then 
				alufn_reg <= SW7&SW6&SW5&SW4&SW3&SW2&SW1&SW0;
			end if;
	end if;
END process;

 PrintHEX3 <= low_y(7 downto 4)  when (sw9='0') else
			 high_y(7 downto 4) when (sw9='1' )
			  else (others=>'0');
			  
 PrintHEX2 <= low_y(3  downto 0) when (sw9='0' ) else 
			  high_y(3  downto 0)when (sw9='1' )
			  else (others=>'0');
			  
 PrintHEX1 <= low_x(7 downto 4)  when (sw9='0' ) else 
			  high_x(7 downto 4) when (sw9='1')
			  else (others=>'0');
			  
 PrintHEX0 <= low_x(3 downto 0)  when (sw9='0' ) else
			  high_x(3 downto 0) when (sw9='1' )
			  else (others=>'0');
			  
pb:HEXdecode generic map(z => 4,k => 7) port map(PrintHEX2,HEX2);
pb2:HEXdecode generic map(4,7)  port map(PrintHEX3,HEX3);
pc:HEXdecode  generic map(4,7) port map(PrintHEX0,HEX0);
pc2:HEXdecode generic map(4,7)  port map(PrintHEX1,HEX1);

Y_top <= high_y&low_y;
X_top <= high_x&low_x;
ALUFN_top <= alufn_reg(4 downto 0);
LEDs(9 downto 5) <= ALUFN_top when key2real='1'; 


top_pm: Top generic map(16,8) port map(MHZ2,SW8,key3real,Y_top,X_top,ALUFN_top,ALUOUT,LEDS(3),LEDs(2),LEDs(1),LEDs(0),PWM);  ---- need to add 

pe1:HEXdecode generic map(4,7) port map(ALUOUT(3 DOWNTO 0),HEX4);
pe2:Hexdecode generic map(4,7) port map (ALUOUT(7 DOWNTO 4),HEX5); -- add the HEX4 ,HEX 5 as well 
	
end dft_GPIO;