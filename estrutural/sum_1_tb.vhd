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

entity sum_1_tb is
end sum_1_tb;

architecture Behavioral of sum_1_tb is
    component sum_1 is
    port (
        x: in std_logic_vector(15 downto 0);
        y: in std_logic_vector(15 downto 0);
        z: in std_logic_vector(15 downto 0);
        w: in std_logic_vector(15 downto 0);
        r: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_x, s_y, s_z, s_w, s_r: std_logic_vector(15 downto 0);
    signal s_expected: std_logic_vector(15 downto 0);
begin
    sum_tb: sum_1 port map(
        x => s_x,
        y => s_y,
        z => s_z,
        w => s_w,
        r => s_r
    );
    process
    begin
        -- Case 1: 2 + 0.5
        s_x <= "0010" & "000000000000";
        s_y <= "0000" & "100000000000";
        s_w <= "0000" & "000000000000";
        s_z <= "0000" & "000000000000";
        s_expected <= "0010" & "100000000000";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Sum 2 + 0.5 got wrong result" severity error;
        end if;
        wait for period;

        -- Case 2: 2 + (-0.5)
        s_x <= "0010" & "000000000000"; -- 2
        s_y <= "1111" & "100000000000"; -- -0.5
        s_w <= "0000" & "000000000000";
        s_z <= "0000" & "000000000000";
        s_expected <= "0001" & "100000000000";

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Sum 2 + (-0.5) got wrong result" severity error;
        end if;
        wait for period;

        -- Case 3: -2 + 0.5
        s_x <= "1110" & "000000000000"; -- 2
        s_y <= "0000" & "100000000000"; -- -0.5
        s_w <= "0000" & "000000000000";
        s_z <= "0000" & "000000000000";
        s_expected <= "1110" & "100000000000"; -- -1.5

        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Sum -2 + 0.5 got wrong result" severity error;
        end if;
        wait for period;


        wait for halt;
    end process;
end architecture;
