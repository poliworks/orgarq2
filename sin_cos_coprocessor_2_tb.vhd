
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sin_cos_coprocessor_2_tb is
end entity;

architecture Behavioral of sin_cos_coprocessor_2_tb is
    component sin_cos_coprocessor_2 is
    port(	x: in std_logic_vector(15 downto 0);
            sc: in std_logic;
            start: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            gen_debug_logic: out std_logic;
            gen_debug: out std_logic_vector(15 downto 0);
            debug_r1: out std_logic_vector(15 downto 0);
            debug_r2: out std_logic_vector(15 downto 0);
            debug_r3: out std_logic_vector(15 downto 0);
            debug_r4: out std_logic_vector(15 downto 0);
            debug_state: out std_logic_vector(3 downto 0);
            done: out std_logic;
            r: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_x : std_logic_vector(15 downto 0) := "0000000000000000";
    signal s_r : std_logic_vector(15 downto 0);
    signal s_clk : std_logic := '0';
    signal s_reset, s_done, s_sc, s_start : std_logic;
    signal s_gen_debug_logic: std_logic;

    signal s_debug_state: std_logic_vector(3 downto 0);
    signal s_r1, s_r2, s_r3, s_r4, s_gen_debug, s_result: std_logic_vector(15 downto 0);
begin
    s_clk <= not s_clk after half_period;
    -- x <= "0000000000000000";
    sin_cos: sin_cos_coprocessor_2 port map(
        x => s_x,
        sc => s_sc,
        start => s_start,
        clock => s_clk,
        reset => s_reset,
        gen_debug_logic => s_gen_debug_logic,
        gen_debug => s_gen_debug,
        debug_r1 => s_r1,
        debug_r2 => s_r2,
        debug_r3 => s_r3,
        debug_r4 => s_r4,
        debug_state => s_debug_state,
        done => s_done,
        r => s_r
    );

    process
    begin
        s_start <= '0';
        s_reset <= '0';
        s_sc <= '1';
        --s_x <= "0000100001100000"; -- 0.5234375 ~ pi/6
        --s_x <= "0000010100000111"; -- sin pi/10 -> 0.309016994374  should be 1266
        s_x <= "0000110010010000"; -- pi/4
        --s_x <= "0001000011000001"; -- pi/3
        -- start pulse
        wait for period;
        s_start <= '1';
        wait for period;
        s_start <= '0';

        wait for period;
        assert (s_r = "0000011111111111");
        if (not (s_r = "0000011111111111")) then
            report "Could not calc sin(pi/6)" severity error;
        end if;

        wait for halt;
    end process;


end architecture;
