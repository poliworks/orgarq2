----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16.07.2018 01:43:34
-- Design Name:
-- Module Name: sum_1_tb - Behavioral
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

entity mux_4to1_tb is
end mux_4to1_tb;

architecture Behavioral of mux_4to1_tb is
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

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_sel: std_logic_vector(1 downto 0);
    signal s_x, s_y, s_z, s_w, s_r: std_logic_vector(15 downto 0);
    signal s_expected: std_logic_vector(15 downto 0);
begin
    mux0: mux_4to1 port map(
        SEL => s_sel,
        V1 => s_x,
        V2 => s_y,
        V3 => s_z,
        V4 => s_w,
        X => s_r
    );
    process
    begin

        s_x <= "1111" & "111111111111"; -- 00
        s_y <= "0000" & "000000000000"; -- 01
        s_z <= "0000" & "111100001111"; -- 10
        s_w <= "1111" & "000011110000"; -- 11


        -- Case 1: sel 00
        s_sel <= "00";
        s_expected <= "1111" & "111111111111";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "sel 00 got wrong result" severity error;
        end if;
        wait for period;

        -- Case 2: sel 01
        s_sel <= "01";
        s_expected <= "0000" & "000000000000";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "sel 01 got wrong result" severity error;
        end if;
        wait for period;

        -- Case 3: sel 10
        s_sel <= "10";
        s_expected <= "0000" & "111100001111";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "sel 10 got wrong result" severity error;
        end if;
        wait for period;

        -- Case 4: sel 11
        s_sel <= "11";
        s_expected <= "1111" & "000011110000";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "sel 11 got wrong result" severity error;
        end if;
        wait for period;

        wait for halt;
    end process;
end architecture;
