----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15.07.2018 17:16:35
-- Design Name:
-- Module Name: multiplication_1_tb - Behavioral
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

entity multiplication_1_tb is
end multiplication_1_tb;

architecture Behavioral of multiplication_1_tb is
    component multiplication_1 is
    port (
        x: in std_logic_vector(15 downto 0);
        y: in std_logic_vector(15 downto 0);
        r: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt: time := 1000ns;
    signal s_x: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_y: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_r: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_expected: std_logic_vector(15 downto 0);
begin
    mult_test: multiplication_1 port map(
        x => s_x,
        y => s_y,
        r => s_r
    );

    process
    begin

        -- Case 1: 2 * 0.5
        s_x <= "0010" & "000000000000";
        s_y <= "0000" & "100000000000";
        s_expected <= "0001" & "000000000000";
        wait for half_period;
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication 2*0.5 got wrong result" severity error;
        end if;

        wait for half_period;
        -- Case 2: 2 * 1.5
        s_x <= "0010" & "000000000000";
        s_y <= "0001" & "100000000000";
        s_expected <= "0011" & "000000000000";

        wait for half_period;
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication 2*1.5 got wrong result" severity error;
        end if;

        wait for half_period;
        -- Case 3: -2 * 1.5
        s_x <= "1110" & "000000000000"; -- -2
        s_y <= "0001" & "100000000000"; -- 1.5
        s_expected <= "1101" & "000000000000";

        wait for half_period;
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication -2*1.5 got wrong result" severity error;
        end if;
        wait for half_period;
        -- Case 4: -3.000244140625 * +2.223876953125
        s_x <= "1100" & "111111111111"; -- -3.000244140625
        s_y <= "0010" & "001110010101"; -- +2.223876953125
        s_expected <= "1001010100111110";

        wait for half_period;
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication -3.000244140625*2.223876953125 got wrong result" severity error;
        end if;

        wait for halt;
    end process;

end architecture;
