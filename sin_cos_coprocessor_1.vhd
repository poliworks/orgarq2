----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 14.07.2018 22:02:23
-- Design Name:
-- Module Name: sin_cos_coprocessor_1 - Behavioral
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

entity sin_cos_coprocessor_1 is
port(	x: in std_logic_vector(15 downto 0);
	    sc: in std_logic;
	    start: in std_logic;
	    clock: in std_logic;
	    reset: in std_logic;
	    done: out std_logic;
	    r: out std_logic_vector(15 downto 0)
);
end sin_cos_coprocessor_1;

architecture Behavioral of sin_cos_coprocessor_1 is
    constant CSIN1: real := 1.0;
    constant CSIN2: real := -1.0/6.0;
    constant CSIN3: real := 1.0/120.0;
    constant CSIN4: real := -1.0/5040.0;

    signal real_x: real;
    signal real_x2: real;
    signal real_x3: real;
    signal real_x4: real;
    signal real_x5: real;
    signal real_x6: real;
    signal real_x7: real;
    signal factor0, factor1, factor2, factor3: real;
    signal result: real;
begin
    process(clock)
    begin
        if (clock'event and clock = '1') then
            if (start = '1') then
                real_x <= real(to_integer(signed(x))) / 4096.0;
                real_x2 <= real_x*real_x;

                if (sc = '1') then
                --sin
                    real_x3 <= real_x2*real_x;
                    real_x5 <= real_x3*real_x2;
                    real_x7 <= real_x5*real_x2;
                    factor0 <= real_x*CSIN1;
                    factor1 <= real_x3*CSIN2;
                    factor2 <= real_x5*CSIN3;
                    factor3 <= real_x7*CSIN4;

                    result <= factor0 + factor1 + factor2 + factor3;
                    r <= std_logic_vector(to_unsigned(integer(result*4096.0), 16));
                else
                --cos
                end if;

            end if;

        end if;

    end process;
end Behavioral;
