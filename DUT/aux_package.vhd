library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
	component alu is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 16	); -- m=2^(k-1)
	PORT 
	( 	
		Y_in,X_in: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	end component;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component;
---------------------------------------------------------	
	
		component AdderSub IS
	GENERIC (n : INTEGER := 8);
	PORT (y,x	  :	IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		 sub_cont :	IN STD_LOGIC_VECTOR(2 DOWNTO 0);
         cout	  :	OUT STD_LOGIC;
         s		  :	OUT STD_LOGIC_VECTOR(n-1 downto 0));
	END component;
-----------Shifter component-----------------------------------
	component Shifter IS
	GENERIC (	n	: INTEGER := 8;
			k	: INTEGER := 3);
	PORT (X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  dir	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          cout	: OUT STD_LOGIC;
          res	: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	END component;
------------Logic component-------------------------------------
	component Logic IS
	  GENERIC (	n	: INTEGER := 8);
	  PORT (X,Y	: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			ALUout	: OUT STD_LOGIC_VECTOR(n-1 downto 0));
	END component;

---------Counter component----------
	component counter is 
	generic (m: integer :=16
					);
	Port ( 
	clk,en,rst : in std_logic;
	EQUY:in std_logic;
	count: out std_logic_vector(m-1 downto 0));
	end component ;
-----------------------PWM make component-----
	component PWMUNIT is 
	generic (m: integer :=16
				);
	Port ( 
	clk,en : in std_logic;
	x,y,cnt_in :in std_logic_vector(m-1 downto 0);
	ALUFN: in std_logic_vector(2 downto 0);
	PWMout,EQUY: out std_logic);
	end component ;

-----SDC ---------
component SDC is
generic (m: integer :=16
				);
	Port ( 
	clk,en,rst : in std_logic;
	x,y :in std_logic_vector(m-1 downto 0);
	ALUFN: in std_logic_vector(4 downto 0);
	PWMout: out std_logic);
	end component ;
	
component top is
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
end component;
component HEXdecode is 
generic (z : integer := 8;
		 k : integer := 7);
port ( 
input : in std_logic_vector(z-1 downto 0);
printHEX :out std_logic_vector(k-1 downto 0)
);
end component;

component GPIO is 
generic(
n : integer := 8 ;
m :integer := 16;
k :integer := 7 
);
port ( clk : in std_logic;
	   KEY0,KEY1,KEY2,KEY3 :IN std_logic;
	   SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9 : IN std_logic;
	   HEX5,HEX4,HEX3,HEX2,HEX1,HEX0 : out std_logic_vector(k-1 downto 0);
	   LEDs  	 : out std_logic_vector(9 downto 0);
	   PWMout    :OUT std_logic
);
end component;
component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END component;
end aux_package;