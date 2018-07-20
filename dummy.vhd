----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 12.07.2018 22:01:32
-- Design Name:
-- Module Name: dummy_test - Dummy
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

entity dummy is
port(	x: in std_logic;
	    y: in std_logic;
	    F: out std_logic
);
end entity;

architecture dummy_arch of dummy is
begin
    process(x, y)
    begin
        -- compare to truth table
        if ((x='0') and (y='0')) then
	    F <= '0';
	else
	    F <= '1';
	end if;
    end process;
end architecture;
