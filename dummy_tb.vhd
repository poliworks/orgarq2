
----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 12.07.2018 22:14:21
-- Design Name:
-- Module Name: dummy_test_sim - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dummy_tb is
end entity;

architecture dummy_tb_arch of dummy_tb is
    constant half_period : time := 10ns;
    component dummy is
    port(	x: in std_logic;
            y: in std_logic;
            F: out std_logic
    );
    end component;

    signal inX, inY, outF : std_logic;
    signal notused : std_logic := '0';
    signal vec1, vec2,vec3 : std_logic_vector(3 downto 0);
    signal bvec1 : std_logic_vector (7 downto 0);
    signal t1, t2, t3, t4 : std_logic_vector (15 downto 0);
    signal d1: std_logic_vector(31 downto 0);
    signal r1, r2, r3 : real;
    signal i1, i2, i3, i4: integer;
begin
    dummy_name: dummy port map(inX, inY, outF);
    notused <= not notused after half_period;
    process
    begin
        r1 <= 0.01;
        vec1 <= "0010";
        vec2 <= "1100";
        t1 <= "0010100000000000";
        r1 <= real(to_integer(signed(t1))) / 4096.0;
        i1 <= to_integer(unsigned(vec1(2 downto 0)));
        i2 <= to_integer(unsigned(vec2(2 downto 0)));
        i3 <= 2;
        i4 <= 2*i2;
        t3 <= std_logic_vector(to_unsigned(i4, 16));
        t2 <= std_logic_vector(to_unsigned(integer(r1*4096.0), 16));
        inX <= '0';
        inY <= '0';
        wait for 10 ns;
        vec3 <=  std_logic_vector(unsigned(vec1) + unsigned(vec2));
        assert (outF = '0');
        if (not (outF = '0')) then
            report "Failed Case1!" severity error;
        end if;
        inX <= '1';
        wait for 1 ns;
        inY <= '1';
        wait for 10 ns;
    end process;
end architecture;
-- https://stackoverflow.com/questions/17904514/vhdl-how-should-i-create-a-clock-in-a-testbench
-- http://esd.cs.ucr.edu/labs/tutorial/tb_ckt.vhd
-- https://electronics.stackexchange.com/questions/271078/what-is-the-standard-way-to-represent-fixed-point-numbers-in-vhdl
-- https://stackoverflow.com/questions/4042832/error-adding-std-logic-vectors
-- https://electronics.stackexchange.com/questions/11774/vhdl-integers-for-synthesis
-- https://www.thecodingforums.com/threads/convert-from-std_logic_vector-to-real.23908/
-- https://stackoverflow.com/questions/10411869/integer-to-real-conversion-function
-- https://electronics.stackexchange.com/questions/4482/vhdl-converting-from-an-integer-type-to-a-std-logic-vector
-- https://www.ics.uci.edu/~jmoorkan/vhdlref/ifs.html
