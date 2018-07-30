----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 14.07.2018 23:41:16
-- Design Name:
-- Module Name: sin_cos_coprocessor_1_tb - Behavioral
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

entity sin_cos_coprocessor_1_tb is
end entity;

architecture Behavioral of sin_cos_coprocessor_1_tb is
    component sin_cos_coprocessor_1 is
    port(	x: in std_logic_vector(15 downto 0);
            sc: in std_logic;
            start: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            done: out std_logic;
            r: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 10000ns;
    signal s_x : std_logic_vector(15 downto 0) := "0000000000000000";
    signal s_r : std_logic_vector(15 downto 0);
    signal s_clk : std_logic := '0';
    signal s_reset, s_done, s_sc, s_start : std_logic;
begin
    s_clk <= not s_clk after half_period;
    -- x <= "0000000000000000";
    sin_cos: sin_cos_coprocessor_1 port map(
        x => s_x,
        sc => s_sc,
        start => s_start,
        clock => s_clk,
        reset => s_reset,
        done => s_done,
        r => s_r
    );

    process
    begin
        --sin
        s_reset <= '0';
        s_sc <= '1';
        s_x <= "0000100001100000"; -- 0.5234375 ~ pi/6

        -- start pulse
        wait for period;
        s_start <= '1';
        wait for period;
        s_start <= '0';

        wait for period*10;
        assert (s_r = "0000011111111111");
        if (not (s_r = "0000011111111111")) then
            report "Could not calc sin(pi/6)" severity error;
        end if;

--        wait for halt;
        --reset
        wait for period*10;
        s_reset <= '1';
        wait for half_period;
        s_reset <= '0';
        s_start <= '0';
        wait for half_period;

        wait for period*2;
        --cos
        s_sc <= '0';
        s_x <= "0001000011000001"; -- pi/3
        --s_x <= "0000100001100000"; -- 0.5234375 ~ pi/6

        -- start pulse
        wait for period;
        s_start <= '1';
        wait for period;
        s_start <= '0';

        wait for period;
        assert (s_r = "0000011111111111");
        if (not (s_r = "0000011111111111")) then
            report "Could not calc cos(pi/3)" severity error;
        end if;
        wait for halt;
    end process;


end architecture;
