----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 15.07.2018 17:11:03
-- Design Name:
-- Module Name: multiplication_1 - Behavioral
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

use IEEE.NUMERIC_STD.ALL;

entity multiplication_1 is
port (
    x: in std_logic_vector(15 downto 0);
    y: in std_logic_vector(15 downto 0);
    r: out std_logic_vector(15 downto 0)
);
end entity;

architecture Behavioral of multiplication_1 is
    signal s_int_x: integer;
    signal s_int_y: integer;
    signal s_int_r: integer;
    signal sign_x: std_logic;
    signal sign_y: std_logic;
    signal sign_r: std_logic;
    signal s_r32: std_logic_vector(31 downto 0) := "00000000" & "00000000" & "00000000" & "00000000";
begin
    s_int_x <= to_integer(signed(x));
    s_int_y <= to_integer(signed(y));
    s_int_r <= s_int_x*s_int_y;

    s_r32 <= std_logic_vector(to_signed(s_int_r, 32));
    r <= s_r32(27 downto 12);
end architecture;
