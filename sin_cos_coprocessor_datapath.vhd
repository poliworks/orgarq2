----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15.07.2018 23:47:31
-- Design Name:
-- Module Name: sin_cos_coprocessor_fd_1 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sin_cos_coprocessor_datapath is
port (
    x: in std_logic_vector(15 downto 0);
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
end entity;

architecture Behavioral of sin_cos_coprocessor_datapath is
    component multiplication_1 is
    port (
        x: in std_logic_vector(15 downto 0);
        y: in std_logic_vector(15 downto 0);
        r: out std_logic_vector(15 downto 0)
    );
    end component;

    component reg16 is
    port (
        new_value: in std_logic_vector(15 downto 0);
        write: in std_logic;
        clock: in std_logic;
        value: out std_logic_vector(15 downto 0)
    );
    end component;

    component mux_4to1 is
    port (
        SEL : in STD_LOGIC_VECTOR (1 downto 0);
        V1 : in STD_LOGIC_VECTOR (15 downto 0);
        V2 : in STD_LOGIC_VECTOR (15 downto 0);
        V3 : in STD_LOGIC_VECTOR (15 downto 0);
        V4 : in STD_LOGIC_VECTOR (15 downto 0);
        X : out STD_LOGIC_VECTOR (15 downto 0)
    );
    end component;

    component sum_1 is
    port (
        x: in std_logic_vector(15 downto 0);
        y: in std_logic_vector(15 downto 0);
        z: in std_logic_vector(15 downto 0);
        w: in std_logic_vector(15 downto 0);
        r: out std_logic_vector(15 downto 0)
    );
    end component;

    constant csin1: std_logic_vector (15 downto 0) := "0001" & "000000000000";
    constant csin2: std_logic_vector (15 downto 0) := "1111" & "110101010110";
    constant csin3: std_logic_vector (15 downto 0) := "0000" & "000000100010";
    constant csin4: std_logic_vector (15 downto 0) := "1111" & "111111111111";

    constant ccos1: std_logic_vector (15 downto 0) := "0001" & "000000000000";
    constant ccos2: std_logic_vector (15 downto 0) := "1111" & "100000000000";
    constant ccos3: std_logic_vector (15 downto 0) := "0000" & "000010101010";
    constant ccos4: std_logic_vector (15 downto 0) := "1111" & "111111111011";

    constant gnd: std_logic_vector (15 downto 0) := "0000" & "000000000000";

    signal s_r1_new_value, s_r2_new_value, s_r3_new_value, s_r4_new_value: std_logic_vector(15 downto 0);
    signal s_r1, s_r2, s_r3, s_r4: std_logic_vector(15 downto 0);
    signal s_out_mult1, s_out_mult2, s_out_sum: std_logic_vector(15 downto 0);
    signal s_out_mux1, s_out_mux2, s_out_mux3, s_out_mux4, s_out_mux5, s_out_mux6, s_out_mux7, s_out_mux8, s_out_mux9, s_out_mux10: std_logic_vector(15 downto 0);
    signal connect_r1, connect_r2, connect_r3, connect_r4: std_logic_vector(15 downto 0);
    signal s_clock: std_logic;
begin
    s_clock <= clock;
    connect_r1 <= s_r1_new_value;
    connect_r2 <= s_r2_new_value;
    connect_r3 <= s_r3_new_value;
    connect_r4 <= s_r4_new_value;
    connect_r1 <= s_out_mux1;
    connect_r2 <= s_out_mux2;
    connect_r3 <= s_out_mux3;
    connect_r4 <= s_out_mux4;
    gen_debug <= s_out_mux8;
    gen_debug2 <= s_out_mux9;
    debug_r1 <= s_r1;
    debug_r2 <= s_r2;
    debug_r3 <= s_r3;
    debug_r4 <= s_r4;
    gen_debug_logic <= r4_write;
    result <= s_r4 when (ready = '1') else "0000000000000000";

    -- REGISTERS
    r1: reg16 port map(
        new_value => s_out_mux1,
        write => r1_write,
        clock => s_clock,
        value => s_r1
    );
    r2: reg16 port map(
        new_value => s_out_mux2,
        write => r2_write,
        clock => s_clock,
        value => s_r2
    );
    r3: reg16 port map(
        new_value => s_out_mux3,
        write => r3_write,
        clock => s_clock,
        value => s_r3
    );
    r4: reg16 port map(
        new_value => s_out_mux4,
        write => r4_write,
        clock => s_clock,
        value => s_r4
    );


    -- MUXES
    mux1: mux_4to1 port map(
        SEL => sel_mux1,
        V1 => s_out_mult2,
        V2 => s_out_mult1,
        V3 => gnd,
        V4 => gnd,
        X => s_out_mux1
    );
    mux2: mux_4to1 port map(
        SEL => sel_mux2,
        V1 => s_out_mult1,
        V2 => s_out_mult2,
        V3 => ccos1,
        V4 => gnd,
        X => s_out_mux2
    );
    mux3: mux_4to1 port map(
        SEL => sel_mux3,
        V1 => s_out_mult1,
        V2 => s_out_mult2,
        V3 => gnd,
        V4 => gnd,
        X => s_out_mux3
    );
    mux4: mux_4to1 port map(
        SEL => sel_mux4,
        V1 => s_out_mult1,
        V2 => x,
        V3 => s_out_sum,
        V4 => s_out_mult2,
        X => s_out_mux4
    );
    mux5: mux_4to1 port map(
        SEL => sel_mux5,
        V1 => ccos2,
        V2 => ccos4,
        V3 => csin2,
        V4 => csin4,
        X => s_out_mux5
    );
    mux6: mux_4to1 port map(
        SEL => sel_mux6,
        V1 => s_out_mux5,
        V2 => gnd,
        V3 => gnd,
        V4 => s_r3,
        X => s_out_mux6
    );
    mux7: mux_4to1 port map(
        SEL => sel_mux7,
        V1 => s_r1,
        V2 => s_r3,
        V3 => s_r2,
        V4 => gnd,
        X => s_out_mux7
    );
    mux8: mux_4to1 port map(
        SEL => sel_mux8,
        V1 => s_r1,
        V2 => s_r2,
        V3 => s_r4,
        V4 => gnd,
        X => s_out_mux8
    );
    mux9: mux_4to1 port map(
        SEL => sel_mux9,
        V1 => s_r3,
        V2 => s_r4,
        V3 => s_out_mux10,
        V4 => gnd,
        X => s_out_mux9
    );
    mux10: mux_4to1 port map(
        SEL => sel_mux10,
        V1 => csin1,
        V2 => csin3,
        V3 => ccos3,
        V4 => gnd,
        X => s_out_mux10
    );

    -- MULTIPLICATIONS
    mult1: multiplication_1 port map(
        x => s_out_mux6,
        y => s_out_mux7,
        r => s_out_mult1
    );
    mult2: multiplication_1 port map(
        x => s_out_mux8,
        y => s_out_mux9,
        r => s_out_mult2
    );

    -- SUM4x1
    sum: sum_1 port map(
        x => s_r1,
        y => s_r2,
        z => s_r3,
        w => s_r4,
        r => s_out_sum
    );
end architecture;
