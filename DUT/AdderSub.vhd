LIBRARY ieee;
USE ieee.std_logic_1164.all;
---- entity start ------
entity AdderSub is 
	generic (n: integer :=8);
	Port ( 
	y,x :in std_logic_vector(n-1 downto 0);
	sub_cont: in std_logic_vector(2 downto 0);
	s	: out std_logic_vector(n-1 downto 0);
	cout:OUT std_logic);
	end AdderSub;
------ start architecture----
architecture dft_Addersub OF AdderSub is
component FA PORT (xi, yi, cin: IN std_logic;
					s, cout: OUT std_logic);
END component;
SIGNAL sumi : std_logic_vector(n-1 DOWNTO 0);
	SIGNAL x_a, y_a: std_logic_vector(n-1 DOWNTO 0);
	SIGNAL c_0 : std_logic;
begin
c_0 <= '0' when sub_cont= "000" else
		'1' when sub_cont ="001"-- when we r on sub we need the carry bit to make the neg num (mashlim le 2)
		else '1' when (sub_cont="011" or sub_cont= "010")-- when we make neg(X) need the carry for (mashlim le 2)
		else '0';
lp2 : 	 -- we describe the x for the specifc action 
		x_a<= x when sub_cont ="000" else
				not(x)	when sub_cont ="001"--make the sub with the ripple adder
				else (NOT x) when (sub_cont = "010")-- make a neg num by doing not bitwises 
				else (others =>'0') when  (sub_cont="011")-- when we need do Y+1 the x is not relevant 
				else (others =>'1') when (sub_cont ="100")--- make a Y-1 is equal to add (-1) so we make '111111111' 
				else "0000"&y(n-1 DOWNTO (n/2)) when (sub_cont="101")
				else (others =>'0');-- if we not getting the right input we getting zero on the outpot
		
		y_a <=(others =>'0') when sub_cont="010" -- in case of neg X the y is not relavnt 
				else y when (sub_cont="000" or sub_cont="001" or sub_cont="011" or sub_cont="100" )-- in evert other case need to get the Y 
				else y((n/2)-1 DOWNTO 0)&"0000" when sub_cont = "101" ---swapp action 
				else (others =>'0');
				
	ad : FA port map(xi => x_a(0),yi => y_a(0),cin => c_0,s => s(0),cout => sumi(0));-- the first opration of the loop 
-- Make the rest of the FA operations
	fin: for i in 1 to n-1 generate
	     lp3: FA port map(xi => x_a(i),yi => y_a(i),cin => sumi(i-1),s => s(i),cout => sumi(i));--- in every opration of the adder add the i bit  
	end generate;
	-- Get carry of the last FA
	cout <= sumi(n-1) ;--- because the sumi is getting the carry that comes in every iteration 
	end dft_Addersub;