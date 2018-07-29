library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg16_tb is
end reg16_tb;

architecture Behavioral of reg16_tb is
    component reg16 is
    port (
        new_value: in std_logic_vector(15 downto 0);
        reset: in std_logic;
        write: in std_logic;
        clock: in std_logic;
        value: out std_logic_vector(15 downto 0)
    );
    end component;

    constant half_period : time := 10ns;
    constant period : time := 20ns;
    constant halt : time := 1000ns;

    signal s_clock: std_logic := '0';
    signal s_new_value, s_value, s_expected: std_logic_vector(15 downto 0) := "0000000000000000";
    signal s_write, s_reset: std_logic := '0';
begin
    s_clock <= not s_clock after half_period;
    r1: reg16 port map(
        new_value => s_new_value,
        reset => s_reset,
        write => s_write,
        clock => s_clock,
        value => s_value
    );
    process
    begin
        s_expected <= "0000000000000000";
        wait for period;

        assert (s_value = s_expected);
        if (not (s_value = s_expected)) then
            report "Register must start with zeros" severity error;
        end if;

        s_write <= '1';
        s_new_value <= "0101010101010101";
        s_expected <= "0101010101010101";
        wait for period;

        assert (s_value = s_expected);
        if (not (s_value = s_expected)) then
            report "Register must write values" severity error;
        end if;

        s_write <= '0';
        s_new_value <= "0000000000000000";

        assert (s_value = s_expected);
        if (not (s_value = s_expected)) then
            report "Register must keep values" severity error;
        end if;
        wait for period;

        s_reset <= '1';
        s_expected <= "0000000000000000";

        assert (s_value = s_expected);
        if (not (s_value = s_expected)) then
            report "Register must reset" severity error;
        end if;
        wait for period;

        wait for halt;
    end process;
end Behavioral;
