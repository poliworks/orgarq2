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
        clock: in std_logic;
        r: out std_logic_vector(15 downto 0);
        debug: out std_logic_vector(31 downto 0);
        dbgi1: out integer;
        dbgi2: out integer;
        dbgi3: out integer;
        overflow: out std_logic
    );
    end component;
    
    constant half_period : time := 10ns;
    constant period : time := 20ns;
    
    signal s_x: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_y: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_r: std_logic_vector(15 downto 0) := "1111111111111111";
    signal s_overflow: std_logic;
    signal s_clock : std_logic := '0';
    signal s_debug : std_logic_vector(31 downto 0);
    signal s_expected: std_logic_vector(15 downto 0);
    signal dbg_int1, dbg_int2, dbg_int3: integer;
begin
    s_clock <= not s_clock after half_period;
    mult_test: multiplication_1 port map(
        x => s_x,
        y => s_y,
        clock => s_clock,
        r => s_r,
        debug => s_debug,
        dbgi1 => dbg_int1,
        dbgi2 => dbg_int2,
        dbgi3 => dbg_int3, 
        overflow => s_overflow
    );
    
    process
    begin
        -- Case 1: 2 * 0.5
        s_x <= "0010" & "000000000000";
        s_y <= "0000" & "100000000000";
        --wait for period;
        s_expected <= "0001" & "000000000000";
        
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication 2*0.5 got wrong result" severity error;
        end if;
        
        wait for period;
        -- Case 2: 2 * 1.5
        s_x <= "0010" & "000000000000";
        s_y <= "0001" & "100000000000";
        --wait for period;
        s_expected <= "0011" & "000000000000";
        
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication 2*1.5 got wrong result" severity error;
        end if;
        
        wait for period;
        -- Case 3: -2 * 1.5
        s_x <= "1010" & "000000000000";
        s_y <= "0001" & "100000000000";
        --wait for period;
        s_expected <= "1011" & "000000000000";
        
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication -2*1.5 got wrong result" severity error;
        end if;
        
        wait for period;
        -- Case 4: -2 * 1.5
        
        s_x <= "1011" & "000000000001"; -- -3.000244140625
        s_y <= "0010" & "001110010101"; -- +2.223876953125
        --wait for period;
        s_expected <= "1110" & "101011000001";
        
        assert (s_r = s_expected);
        if (not (s_r = s_expected)) then
            report "Multiplication -3.000244140625*2.223876953125 got wrong result" severity error;
        end if;
        
        wait for period;
        wait for period;
    end process;

end architecture;
