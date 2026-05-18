LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PWMUNIT is 
	generic (m: integer :=16
				);
	Port ( 
	clk,en : in std_logic;
	x,y,cnt_in :in std_logic_vector(m-1 downto 0);
	ALUFN: in std_logic_vector(2 downto 0);
	PWMout,EQUY: out std_logic);
	end PWMUNIT ;
architecture dtf_pwm of PWMUNIT is
    signal PWM1, PWM2 : std_logic := '0';
begin
    lp3: process(clk)
    begin
        if rising_edge(clk) then
			if (cnt_in=(y-1) or cnt_in>y) then 
				EQUY<= '1';
				else 
						 EQUY<='0';
			end if;
			
            if en = '1' then

                -- PWM1 logic
                if cnt_in = x-1 then
                    PWM1 <= '1';
                elsif cnt_in = y-1 then
                    PWM1 <= '0';
                end if;

                -- PWM2 logic
                if cnt_in = x-1 then
                        PWM2 <=not PWM2;
                end if;

                -- ALUFN case logic

            end if;
        end if;
    end process;
	process(ALUFN,PWM1,PWM2)
	begin
		case ALUFN is
                    when "000" =>
                        PWMout <= PWM1;
                    when "001" =>
                        PWMout <= not PWM1;
                    when "010" =>
                        PWMout <= PWM2;
                    when others =>
                       PWMout<='0';
		end case;
	end process;

end dtf_pwm;
