
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sin_cos_coprocessor_2 is
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
end entity;

architecture Structural of sin_cos_coprocessor_2 is
  component sin_cos_coprocessor_controller is
  port (
    start: in std_logic;
    clock: in std_logic;
    sc: in std_logic;
    reset: in std_logic;

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

  signal s_r1_write, s_r2_write, s_r3_write, s_r4_write: std_logic;
  signal s_sel_mux1, s_sel_mux2, s_sel_mux3, s_sel_mux4, s_sel_mux5, s_sel_mux6, s_sel_mux7, s_sel_mux8, s_sel_mux9, s_sel_mux10: std_logic_vector(1 downto 0);
  signal s_clock, s_ready, s_sc: std_logic;
  signal s_debug_state: std_logic_vector(3 downto 0);
  signal s_gen_debug_logic: std_logic;
  signal s_r1, s_r2, s_r3, s_r4, s_gen_debug, s_result: std_logic_vector(15 downto 0);
begin
  s_clock <= clock;
  done <= s_ready;
  r <= s_result;
  debug_state <= s_debug_state;
  datapath: sin_cos_coprocessor_datapath port map(
      x => x,
      reset => reset,
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
      debug_r1 => debug_r1,
      debug_r2 => debug_r2,
      debug_r3 => debug_r3,
      debug_r4 => debug_r4,
      result => s_result
  );

  controller: sin_cos_coprocessor_controller port map(
      start => start,
      clock => s_clock,
      sc => sc,
      reset => reset,
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
end architecture;
