
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity sin_cos_coprocessor_datapath_tb is
end entity;

architecture Behavioral of sin_cos_coprocessor_datapath_tb is
    component sin_cos_coprocessor_datapath is
    port (
        x: in std_logic_vector(15 downto 0);
        reset: in std_logic;
        r1_write: in std_logic;
        r2_write: in std_logic;
        r3_write: in std_logic;
        r4_write: in std_logic;
        sel_mux1: in std_logic_vector(1 downto 0);
        sel_mux2: in std_logic_vector(1 downto 0);
        sel_mux3: in std_logic_vector(1 downto 0);
        sel_mux4: in std_logic_vector(1 downto 0);
        sel_mux5: in std_logic_vector(1 downto 0);
        sel_mux6: in std_logic_vector(1 downto 0);
        sel_mux7: in std_logic_vector(1 downto 0);
        sel_mux8: in std_logic_vector(1 downto 0);
        sel_mux9: in std_logic_vector(1 downto 0);
        sel_mux10: in std_logic_vector(1 downto 0);
        ready: in std_logic;
        clock: in std_logic;
        gen_debug_logic: out std_logic;
        gen_debug: out std_logic_vector(15 downto 0);
        gen_debug2: out std_logic_vector(15 downto 0);
        debug_r1: out std_logic_vector(15 downto 0);
        debug_r2: out std_logic_vector(15 downto 0);
        debug_r3: out std_logic_vector(15 downto 0);
        debug_r4: out std_logic_vector(15 downto 0);
        result: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_r1_write, s_r2_write, s_r3_write, s_r4_write: std_logic;
    signal s_sel_mux1, s_sel_mux2, s_sel_mux3, s_sel_mux4, s_sel_mux5, s_sel_mux6, s_sel_mux7, s_sel_mux8, s_sel_mux9, s_sel_mux10: std_logic_vector(1 downto 0);
    signal s_x, s_result: std_logic_vector(15 downto 0);
    signal s_r1, s_r2, s_r3, s_r4, gen_debug, gen_debug2: std_logic_vector(15 downto 0);
    signal s_clock: std_logic := '0';
    signal s_reset: std_logic := '0';
    signal s_ready, gen_debug_logic: std_logic;
begin
    s_clock <= not s_clock after half_period;

    datapath: sin_cos_coprocessor_datapath port map(
        x => s_x,
        reset => s_reset,
        r1_write => s_r1_write,
        r2_write => s_r2_write,
        r3_write => s_r3_write,
        r4_write => s_r4_write,
        sel_mux1 => s_sel_mux1,
        sel_mux2 => s_sel_mux2,
        sel_mux3 => s_sel_mux3,
        sel_mux4 => s_sel_mux4,
        sel_mux5 => s_sel_mux5,
        sel_mux6 => s_sel_mux6,
        sel_mux7 => s_sel_mux7,
        sel_mux8 => s_sel_mux8,
        sel_mux9 => s_sel_mux9,
        sel_mux10 => s_sel_mux10,
        ready => s_ready,
        clock => s_clock,
        gen_debug_logic => gen_debug_logic,
        gen_debug => gen_debug,
        gen_debug2 => gen_debug2,
        debug_r1 => s_r1,
        debug_r2 => s_r2,
        debug_r3 => s_r3,
        debug_r4 => s_r4,
        result => s_result
    );
    process
    begin
        -- We are going to try to mock UC to run sin(pi/6) = 0.5
       -- s_x <= "0000100001100000"; -- 0.5234375 ~ pi/6
        s_x <= "0001000011000001"; -- pi/3
        --s_x <= "0000010100000111"; -- sin pi/10 -> 0.309016994374  should be 1266
        s_ready <= '0';
        s_r1_write <= '0';
        s_r2_write <= '0';
        s_r3_write <= '0';
        s_r4_write <= '0';
        s_sel_mux1 <= "00";
        s_sel_mux2 <= "00";
        s_sel_mux3 <= "00";
        s_sel_mux4 <= "00";
        s_sel_mux5 <= "00";
        s_sel_mux6 <= "00";
        s_sel_mux7 <= "00";
        s_sel_mux8 <= "00";
        s_sel_mux9 <= "00";
        s_sel_mux10 <= "00";

        -- V0 = x
        wait for period;
        -- clean
        -- work
        s_sel_mux4 <= "01";
        s_r4_write <= '1';

        -- V1 = V0*V0
        wait for period;
        -- clean
        s_sel_mux4 <= "00";
        s_r4_write <= '0';
        -- work
        s_sel_mux3 <= "01";
        s_sel_mux8 <= "10";
        s_sel_mux9 <= "01";
        s_r3_write <= '1';

        -- V2 = V1*V0
        wait for period;
        -- clean
        s_sel_mux3 <= "00";
        s_r3_write <= '0';
        -- work
        s_sel_mux2 <= "01";
        s_sel_mux8 <= "10";
        s_sel_mux9 <= "00";
        s_r2_write <= '1';

        -- V3 = V2*V1
        wait for period;
        -- clean
        s_sel_mux2 <= "00";
        s_sel_mux8 <= "00";
        s_sel_mux9 <= "00";
        s_r2_write <= '0';
        -- work
        s_sel_mux1 <= "01";
        s_sel_mux6 <= "11";
        s_sel_mux7 <= "10";
        s_r1_write <= '1';

        -- V4 = V3*V1
        wait for period;
        -- clean
        s_sel_mux1 <= "00";
        s_r1_write <= '0';
        -- work
        s_sel_mux3 <= "00";
        s_sel_mux6 <= "11";
        s_sel_mux7 <= "01";
        s_r3_write <= '1';

        -- V5 = V0*CSIN1 && V6 = V2*CSIN2
        wait for period;
        -- clean
        s_sel_mux3 <= "00";
        s_r3_write <= '0';
        -- work
        s_sel_mux1 <= "01";
        s_sel_mux5 <= "10";
        s_sel_mux6 <= "00";
        s_sel_mux7 <= "10";
        s_r1_write <= '1';

        s_sel_mux2 <= "01";
        s_sel_mux8 <= "10";
        s_sel_mux9 <= "10";
        s_sel_mux10 <= "00";
        s_r2_write <= '1';

        -- V7 = V3*CSIN3 && V8 = V4*CSIN4
        wait for period;
        -- clean
        s_sel_mux1 <= "00";
        s_r1_write <= '0';

        s_sel_mux2 <= "00";
        s_r2_write <= '0';
        -- work
        s_sel_mux3 <= "01";
        s_sel_mux8 <= "00";
        s_sel_mux9 <= "10";
        s_sel_mux10 <= "01";
        s_r3_write <= '1';

        s_sel_mux4 <= "00";
        s_sel_mux5 <= "11";
        s_sel_mux6 <= "00";
        s_sel_mux7 <= "01";
        s_r4_write <= '1';

        -- V9 = V5 + V6 + V7 + v8
        wait for period;
        -- clean
        s_sel_mux3 <= "00";
        s_sel_mux8 <= "00";
        s_sel_mux9 <= "00";
        s_sel_mux10 <= "00";
        s_r3_write <= '0';
        s_sel_mux5 <= "00";
        s_sel_mux6 <= "00";
        s_sel_mux7 <= "00";

        --work
        s_sel_mux4 <= "10";
        s_r4_write <= '1';

        -- Ready
        wait for period;
        -- clean
        s_sel_mux4 <= "00";
        s_r4_write <= '0';

        --work
        s_ready <= '1';

        wait for period;
        --Async reset
        s_reset <= '1';


        wait for halt;
    end process;
end architecture;
