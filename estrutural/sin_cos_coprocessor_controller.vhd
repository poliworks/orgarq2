
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sin_cos_coprocessor_controller is
port (
    start: in std_logic;
    clock: in std_logic;
    sc: in std_logic;
    reset: in std_logic;
    r1_write: out std_logic;
    r2_write: out std_logic;
    r3_write: out std_logic;
    r4_write: out std_logic;
    sel_mux1: out std_logic_vector(1 downto 0);
    sel_mux2: out std_logic_vector(1 downto 0);
    sel_mux3: out std_logic_vector(1 downto 0);
    sel_mux4: out std_logic_vector(1 downto 0);
    sel_mux5: out std_logic_vector(1 downto 0);
    sel_mux6: out std_logic_vector(1 downto 0);
    sel_mux7: out std_logic_vector(1 downto 0);
    sel_mux8: out std_logic_vector(1 downto 0);
    sel_mux9: out std_logic_vector(1 downto 0);
    sel_mux10: out std_logic_vector(1 downto 0);
    debug_state: out std_logic_vector(3 downto 0);
    ready: out std_logic
);
end entity;

architecture Behavioral of sin_cos_coprocessor_controller is
    signal state: std_logic_vector(3 downto 0) := "0000";
begin
  debug_state <= state;
  process(clock, reset)
  begin
    if (reset = '1') then
        state <= "0000";
    else
        if (clock'event and clock = '1') then
          case state is
            when "0000" =>
              if (start = '1') then
                state <= "0001";
              end if;
            when "0001" =>
              if (sc = '1') then
                state <= "0010";
              else
                state <= "0111";
              end if;
            when "0010" =>
              state <= "0011";
            when "0011" =>
              state <= "0100";
            when "0100" =>
              state <= "0101";
            when "0101" =>
              state <= "0110";
            when "0110" =>
              state <= "1011";
            when "0111" =>
              state <= "1000";
            when "1000" =>
              state <= "1001";
            when "1001" =>
              state <= "1010";
            when "1010" =>
              state <= "1011";
            when "1011" =>
              state <= "1100";
            when "1100" => -- done
              state <= "0000";
            when others =>
              state <= "0000";
          end case;
        end if;
    end if;
  end process;
  process(state)
  begin
      case state is
      when "0000" => -- S0
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '1'; --
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "01"; --
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "0001" => -- S1
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '1'; --
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "01"; --
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "10"; --
          sel_mux9 <= "01"; --
          sel_mux10 <= "00";
          ready <= '0';
      when "0010" => -- SSIN0
          r1_write <= '0';
          r2_write <= '1'; --
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "01"; --
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "10"; --
          sel_mux9 <= "00"; --
          sel_mux10 <= "00";
          ready <= '0';
      when "0011" => -- SSIN1
          r1_write <= '1'; --
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "01"; --
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "11"; --
          sel_mux7 <= "10"; --
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "0100" => -- SSIN2
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '1'; --
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00"; --
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "11"; --
          sel_mux7 <= "01"; --
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "0101" => -- SSIN3
          r1_write <= '1'; --
          r2_write <= '1'; --
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "01"; --
          sel_mux2 <= "01"; --
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "10"; --
          sel_mux6 <= "00"; --
          sel_mux7 <= "10"; --
          sel_mux8 <= "10"; --
          sel_mux9 <= "10"; --
          sel_mux10 <= "00"; --
          ready <= '0';
      when "0110" => -- SSIN4
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '1'; --
          r4_write <= '1'; --
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "01"; --
          sel_mux4 <= "00"; --
          sel_mux5 <= "11"; --
          sel_mux6 <= "00"; --
          sel_mux7 <= "01"; --
          sel_mux8 <= "00"; --
          sel_mux9 <= "10"; --
          sel_mux10 <= "01"; --
          ready <= '0';
      when "0111" => -- SCOS1: V2 = V1*V1
          r1_write <= '0';
          r2_write <= '1'; --
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "00"; --
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "11"; --
          sel_mux7 <= "01"; --
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "1000" => -- SCOS2: V3 = V2*V1
          r1_write <= '1'; --
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "01"; --
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "11"; --
          sel_mux7 <= "10"; --
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "1001" => -- SCOS3: V5 = CCOS1 && V6 = V1*CCOS2
          r1_write <= '1'; --
          r2_write <= '1'; --
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "01"; --
          sel_mux2 <= "10"; --
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00"; --
          sel_mux6 <= "00"; --
          sel_mux7 <= "01"; --
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "1010" => -- SCOS4: V7 = V2*CCOS3 && V8 = V3*CCOS4
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '1';
          r4_write <= '1';
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "01"; --
          sel_mux6 <= "00"; --
          sel_mux7 <= "00"; --
          sel_mux8 <= "01"; --
          sel_mux9 <= "10"; --
          sel_mux10 <= "10"; --
          ready <= '0';
      when "1011" => -- S2
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '1'; --
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "10"; --
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      when "1100" => -- S3
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '1';
      when others =>
          r1_write <= '0';
          r2_write <= '0';
          r3_write <= '0';
          r4_write <= '0';
          sel_mux1 <= "00";
          sel_mux2 <= "00";
          sel_mux3 <= "00";
          sel_mux4 <= "00";
          sel_mux5 <= "00";
          sel_mux6 <= "00";
          sel_mux7 <= "00";
          sel_mux8 <= "00";
          sel_mux9 <= "00";
          sel_mux10 <= "00";
          ready <= '0';
      end case;
  end process;
end architecture;
