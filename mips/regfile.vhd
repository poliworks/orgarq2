----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2018 11:16:04
-- Design Name: 
-- Module Name: regfile - 
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

entity regfile is -- three-port register file
  port(clk:                  in  STD_LOGIC;
      we1:                 in  STD_LOGIC;
      rs1, rt1:            in REGISTER_ITEM; 
      wa1:                 in  STD_LOGIC_VECTOR(4 downto 0);
      wd1:                 in  STD_LOGIC_VECTOR(31 downto 0);
      rd1:                 in REGISTER_ITEM;
      incoming_rob1_data:  in STD_LOGIC;
      rs1_out, rt1_out:    out REGISTER_ITEM;
      sent_reg1_data:      out STD_LOGIC;
      we2:                 in  STD_LOGIC;
      rs2, rt2:            in REGISTER_ITEM;
      wa2:                 in  STD_LOGIC_VECTOR(4 downto 0);
      wd2:                 in  STD_LOGIC_VECTOR(31 downto 0);
      rd2:                 in REGISTER_ITEM;
      incoming_rob2_data:  in STD_LOGIC;
      rs2_out, rt2_out:    out REGISTER_ITEM;
      sent_reg2_data:      out STD_LOGIC;
      we3:                 in  STD_LOGIC;
      rs3, rt3:            in REGISTER_ITEM;
      wa3:                 in  STD_LOGIC_VECTOR(4 downto 0);
      wd3:                 in  STD_LOGIC_VECTOR(31 downto 0);
      rd3:                 in REGISTER_ITEM;
      incoming_rob3_data:  in STD_LOGIC;
      rs3_out, rt3_out:    out REGISTER_ITEM;
      sent_reg3_data:      out STD_LOGIC);
end;

architecture behave of regfile is
  type regstat is array (31 downto 0) of REGISTER_ITEM;
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype;
  signal stats: regstat;
begin
  -- three-ported register file
  -- read two ports combinationally
  -- write third port on rising edge of clock
  -- register 0 hardwired to 0
  -- note: for pipelined processor, write third port
  -- on falling edge of clk
  process(clk) begin
    if rising_edge(clk) then
        if we1 = '1' then 
            mem(to_integer(wa1)) <= wd1;
        end if;
        if we2 = '1' then 
            mem(to_integer(wa2)) <= wd2;
        end if;
        if we3 = '1' then 
            mem(to_integer(wa3)) <= wd3;
        end if;
    end if;
  end process;
  process(all) begin
    if(incoming_rob1_data = '1') then
        if(stats(to_integer(rs1.addr)).busy = '1') then
            rs1_out <= stats(to_integer(rs1.addr));
        elsif (to_integer(rs1.addr) = 0) then 
            rs1_out.reg <= X"00000000"; -- register 0 holds 0
        else 
            rs1_out.reg <= mem(to_integer(rs1.addr));
            stats(to_integer(rs1.addr)).busy <= '1';
        end if;
    
    
        if(stats(to_integer(rt1.addr)).busy = '1') then
            rt1_out <= stats(to_integer(rt1.addr));
        elsif (to_integer(rt1.addr) = 0) then 
            rt1_out.reg <= X"00000000";  -- register 0 holds 0
        else 
            rt1_out.reg <= mem(to_integer(rt1.addr));
            stats(to_integer(rt1.addr)).busy <= '1';
        end if;
        
        if(rd1.busy = '1') and (stats(to_integer(rd1.addr)).busy = '0') then
            stats(to_integer(rd1.addr)).busy <= '1';
            stats(to_integer(rt1.addr)).reorder <= rd1.reorder;
        end if;
        
        sent_reg1_data <= '1';
    else sent_reg1_data <= '0';
    end if;
    
    
    if(incoming_rob2_data = '1') then
        if(stats(to_integer(rs2.addr)).busy = '1') then
            rs2_out <= stats(to_integer(rs2.addr));
        elsif (to_integer(rs2.addr) = 0) then 
            rs2_out.reg <= X"00000000";
        else 
            rs2_out.reg <= mem(to_integer(rs2.addr));
            stats(to_integer(rs2.addr)).busy <= '1';
        end if;
        
        
        if(stats(to_integer(rt2.addr)).busy = '1') then
            rt2_out <= stats(to_integer(rt2.addr));
        elsif (to_integer(rt2.addr) = 0) then 
            rt2_out.reg <= X"00000000"; 
        else 
            rt2_out.reg <= mem(to_integer(rt2.addr));
            stats(to_integer(rt2.addr)).busy <= '1';
        end if;
        
        if(rd2.busy = '1') and (stats(to_integer(rd2.addr)).busy = '0') then
            stats(to_integer(rd2.addr)).busy <= '1';
            stats(to_integer(rt2.addr)).reorder <= rd2.reorder;
        end if;
                    
        sent_reg2_data <= '1';
    else sent_reg2_data <= '0';
    end if;
    
    if(incoming_rob3_data = '1') then
        if(stats(to_integer(rs3.addr)).busy = '1') then
            rs3_out <= stats(to_integer(rs3.addr));
        elsif (to_integer(rs3.addr) = 0) then 
            rs3_out.reg <= X"00000000"; -- register 0 holds 0
        else 
            rs3_out.reg <= mem(to_integer(rs3.addr));
            stats(to_integer(rs3.addr)).busy <= '1';
        end if;
        
        
        if(stats(to_integer(rt3.addr)).busy = '1') then
            rt3_out <= stats(to_integer(rt3.addr));
        elsif (to_integer(rt3.addr) = 0) then 
            rt3_out.reg <= X"00000000"; 
        else 
            rt3_out.reg <= mem(to_integer(rt3.addr));
            stats(to_integer(rt3.addr)).busy <= '1';
        end if;
        
        if(rd3.busy = '1') and (stats(to_integer(rd3.addr)).busy = '0') then
            stats(to_integer(rd3.addr)).busy <= '1';
            stats(to_integer(rt3.addr)).reorder <= rd3.reorder;
        end if;
                    
        sent_reg3_data <= '1';
    else sent_reg3_data <= '1';
    end if;
  end process;
  
end;