----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16.07.2018 01:34:58
-- Design Name:
-- Module Name: sum_1 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sum_1 is
port (
    x: in std_logic_vector(15 downto 0);
    y: in std_logic_vector(15 downto 0);
    z: in std_logic_vector(15 downto 0);
    w: in std_logic_vector(15 downto 0);
    r: out std_logic_vector(15 downto 0)
);
end sum_1;

architecture Behavioral of sum_1 is
    signal s_int_x: integer;
    signal s_int_y: integer;
    signal s_int_z: integer;
    signal s_int_w: integer;
    signal s_int_r: integer;
begin
    r <= std_logic_vector(to_signed(s_int_r, 16));
    s_int_x <= to_integer(signed(x));
    s_int_y <= to_integer(signed(y));
    s_int_z <= to_integer(signed(z));
    s_int_w <= to_integer(signed(w));
    s_int_r <= s_int_x + s_int_y + s_int_z + s_int_w;
end architecture;
