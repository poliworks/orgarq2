----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 19.07.2018 00:14:41
-- Design Name:
-- Module Name: reg16 - Behavioral
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

entity reg16 is
port (
    new_value: in std_logic_vector(15 downto 0);
    reset: in std_logic;
    write: in std_logic;
    clock: in std_logic;
    value: out std_logic_vector(15 downto 0)
);
end entity;

architecture Behavioral of reg16 is
    signal s_value: std_logic_vector(15 downto 0) := "0000000000000000";
begin
    value <= s_value;
    process(clock, reset)
    begin
        if (reset = '1') then
            s_value <= "0000000000000000";
        else
            if (clock'event and clock = '1') then
                if(write = '1') then
                    s_value <= new_value;
                end if;
            end if;
        end if;
    end process;
end architecture;
