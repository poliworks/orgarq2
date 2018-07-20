
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity sin_cos_coprocessor_controller_tb is
end entity;

architecture Behavioral of sin_cos_coprocessor_controller_tb is
    component sin_cos_coprocessor_controller is
    port (
      start: in std_logic;
      clock: in std_logic;
      sc: in std_logic;

      r1_write: out std_logic;
      r2_write: out std_logic;
      r3_write: out std_logic;
      r4_write: out std_logic;
      sel_mux1: out std_logic_vector(1 downto 0);
      sel_mux2: out std_logic_vector(1 downto 0);
      sel_mux3: out std_logic_vector(1 downto 0);
      sel_mux4: out std_logic_vector(1 downto 0);
      sel_mux5: out std_logic_vector(1 downto 0);
      sel_mux6: out std_logic_vector(1 downto 0);
      sel_mux7: out std_logic_vector(1 downto 0);
      sel_mux8: out std_logic_vector(1 downto 0);
      sel_mux9: out std_logic_vector(1 downto 0);
      sel_mux10: out std_logic_vector(1 downto 0);
      debug_state: out std_logic_vector(3 downto 0);
      ready: out std_logic
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_r1_write, s_r2_write, s_r3_write, s_r4_write: std_logic;
    signal s_sel_mux1, s_sel_mux2, s_sel_mux3, s_sel_mux4, s_sel_mux5, s_sel_mux6, s_sel_mux7, s_sel_mux8, s_sel_mux9, s_sel_mux10: std_logic_vector(1 downto 0);
    signal s_debug_state: std_logic_vector(3 downto 0);
    signal s_clock: std_logic := '0';
    signal s_ready, s_start, s_sc: std_logic;
begin
    s_clock <= not s_clock after half_period;

    controller: sin_cos_coprocessor_controller port map(
        start => s_start,
        clock => s_clock,
        sc => s_sc,
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
        debug_state => s_debug_state,
        ready => s_ready
    );
    process
    begin
        s_start <= '0';
        s_sc <= '0';
        wait for period;
        assert (s_debug_state = "0000");
        if (not (s_debug_state = "0000")) then
            report "Start on S0" severity error;
        end if;
        s_start <= '1';
        wait for period;
        s_start <= '0';
        s_sc <= '1';
        assert (s_debug_state = "0001");
        if (not (s_debug_state = "0001")) then
            report "Move to S1 on start" severity error;
        end if;
        wait for period;
        assert (s_debug_state = "0010");
        if (not (s_debug_state = "0010")) then
            report "Move to SSIN0 on sc" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "0011");
        if (not (s_debug_state = "0011")) then
            report "Move to SSIN1 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "0100");
        if (not (s_debug_state = "0100")) then
            report "Move to SSIN2 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "0101");
        if (not (s_debug_state = "0101")) then
            report "Move to SSIN3 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "0110");
        if (not (s_debug_state = "0110")) then
            report "Move to SSIN4 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "1011");
        if (not (s_debug_state = "1011")) then
            report "Move to S2 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "1100");
        if (not (s_debug_state = "1100")) then
            report "Move to S3 incondionally" severity error;
        end if;

        wait for period;
        assert (s_debug_state = "0000");
        if (not (s_debug_state = "0000")) then
            report "Move to S0 incondionally" severity error;
        end if;
        wait for halt;
    end process;
end architecture;
