-- adapted from https://startingelectronics.org/software/VHDL-CPLD-course/tut4-multiplexers/

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4to1 is
port (
    SEL : in STD_LOGIC_VECTOR (1 downto 0);
    V1 : in STD_LOGIC_VECTOR (15 downto 0);
    V2 : in STD_LOGIC_VECTOR (15 downto 0);
    V3 : in STD_LOGIC_VECTOR (15 downto 0);
    V4 : in STD_LOGIC_VECTOR (15 downto 0);
    X : out STD_LOGIC_VECTOR (15 downto 0)
);
end entity;

architecture Behavioral of mux_4to1 is
begin
with SEL select
    X <= V1 when "00",
         V2 when "01",
         V3 when "10",
         V4 when "11",
         "0000000000000000"  when others;
end architecture;
