----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2018 11:17:39
-- Design Name: 
-- Module Name: alu - 
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
use IEEE.NUMERIC_STD_UNSIGNED.all;
library WORK;
use WORK.TEST.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is 
  port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
       addr:       in  STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
       result:     out CDB_ITEM;
       zero:       out STD_LOGIC);
end;

architecture behave of alu is
  signal cdb_alu: CDB_ITEM;
  signal condinvb, sum: STD_LOGIC_VECTOR(31 downto 0);
begin
  condinvb <= not b when alucontrol(2) else b;
  sum <= a + condinvb + alucontrol(2);
  
  cdb_alu.alu_data <= (others => '0');
  cdb_alu.alu_addr <= addr;
  cdb_alu.mem_data <= (others => '0');
  cdb_alu.mem_addr <= (others => '0');
  cdb_alu.owner <= '0';
  cdb_alu.alu_valid <= '1';
  cdb_alu.mem_valid <= '0';
  
  process(all) begin
    case alucontrol(1 downto 0) is
      when "00"   => cdb_alu.alu_data <= a and b; 
      when "01"   => cdb_alu.alu_data <= a or b; 
      when "10"   => cdb_alu.alu_data <= sum; 
      when "11"   => cdb_alu.alu_data <= (0 => sum(31), others => '0'); 
      when others => cdb_alu.alu_data <= (others => 'X'); 
    end case;
  end process;
  
  zero <= '1' when cdb_alu.alu_data = X"00000000" else '0';
  
  result <= cdb_alu;
end;
