library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_top222 is
end tb_top222;

architecture behavior of tb_top222 is

    component top is
        generic (
            n : integer := 16;
            m : integer := 8
        );
        port(
            clk, en, rst : in std_logic;
            y, x : in std_logic_vector(n-1 downto 0);
            ALUFN_i : in std_logic_vector(4 downto 0);
            ALUout_o : out std_logic_vector(m-1 downto 0);
            Nflag_o, Cflag_o, Zflag_o, Vflag_o : out std_logic;
            PWMout : out std_logic
        );
    end component;

    signal clk, en, rst : std_logic := '0';
    signal x, y : std_logic_vector(15 downto 0) := (others => '0');
    signal ALUFN_i : std_logic_vector(4 downto 0) := (others => '0');
    signal ALUout_o : std_logic_vector(7 downto 0);
    signal Nflag_o, Cflag_o, Zflag_o, Vflag_o, PWMout : std_logic;

    constant clk_period : time := 10 ns;

begin

    uut: top
        port map (
            clk => clk,
            en => en,
            rst => rst,
            x => x,
            y => y,
            ALUFN_i => ALUFN_i,
            ALUout_o => ALUout_o,
            Nflag_o => Nflag_o,
            Cflag_o => Cflag_o,
            Zflag_o => Zflag_o,
            Vflag_o => Vflag_o,
            PWMout => PWMout
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        rst <= '1';
        en <= '0';
        wait for 2*clk_period;
        rst <= '0';
        en <= '1';

        -- Default values
        x <= x"0003";
        y <= x"000C";

        for i in 0 to 30 loop
            ALUFN_i <= std_logic_vector(to_unsigned(i, 5));
            wait for clk_period*10;
        end loop;

        wait;
    end process;

end behavior;