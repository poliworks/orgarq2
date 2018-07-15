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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplication_1 is
port (
    x: in std_logic_vector(15 downto 0);
    y: in std_logic_vector(15 downto 0);
    clock: in std_logic;
    r: out std_logic_vector(15 downto 0);
    debug: out std_logic_vector(31 downto 0);
    dbgi1: out integer;
    dbgi2: out integer;
    dbgi3: out integer;
    overflow: out std_logic
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
    sign_x <= x(15);
    sign_y <= y(15);
    sign_r <= sign_x xor sign_y;
    r <= sign_r & s_r32(26 downto 12);
    s_int_x <= to_integer(unsigned(x(14 downto 0)));
    s_int_y <= to_integer(unsigned(y(14 downto 0)));
    s_int_r <= s_int_x*s_int_y;
    s_r32 <= std_logic_vector(to_unsigned(s_int_r, 32));
    overflow <= s_r32(31) or s_r32(30) or s_r32(29) or s_r32(28) or s_r32(27);
    debug <= s_r32;
    dbgi1 <= s_int_x;
    dbgi2 <= s_int_y;
    dbgi3 <= s_int_r;
end architecture;
