----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2018 12:51:15
-- Design Name: 
-- Module Name: reservation_station - behave
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
use IEEE.STD_LOGIC_ARITH.all;
library WORK;
use WORK.TEST.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reservation_station is --reservation station
  port(
       reset: in STD_LOGIC;
       reg_r: in RESERVATION_ITEM;
       incoming_r_data: in STD_LOGIC;
       cdb_inpt1, cdb_inpt2, cdb_inpt3: in CDB_ITEM;
       rs, rt, rd: out STD_LOGIC_VECTOR(31 downto 0);
       op: out STD_LOGIC_VECTOR(2 downto 0);
       busy: out STD_LOGIC);
end;

architecture behave of reservation_station is
signal r_station: RESERVATION_ITEM;
begin
    process (reset, incoming_r_data) is
    begin
        if reset = '1' then
            busy <= '0';
        end if;
        if(incoming_r_data = '1') then
            r_station <= reg_r;
        end if;
    end process;
    
    process (r_station) is
    begin
        busy <= r_station.busy;
    end process;
    
    process (r_station) is
    begin
        if(r_station.Op = "000000") and (r_station.Qj = "000000") and (r_station.Qk = "000000") then
            rs <= r_station.Vj;
            rt <= r_station.Vk;
            rd <= r_station.dest;
            op <= r_station.Op;
            busy <= '0';
            r_station.busy <= '0';
        elsif(r_station.Op = "100011") and (r_station.Qj = "000000") then
            rs <= r_station.Vj;
            rt <= r_station.A;
            rd <= r_station.dest;
            op <= r_station.Op;
            busy <= '0';
            r_station.busy <= '0';
        elsif(r_station.Op = "101011") and (r_station.Qj = "000000") and (r_station.Qk = "000000") then
            rs <= r_station.Vj;
            rt <= r_station.Vk;
            rd <= r_station.dest;
            op <= r_station.Op;
            busy <= '0';
            r_station.busy <= '0';
        end if;
    end process;
    
    process (cdb_inpt1, cdb_inpt2, cdb_inpt3) is
    begin
        if(cdb_inpt1.alu_valid = '1') then                      -- Verificação resultado primeira estação
            if(r_station.Qj = cdb_inpt1.alu_addr) then
                r_station.Vj <= cdb_inpt1.alu_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt1.alu_addr) then
                r_station.Vk <= cdb_inpt1.alu_data;
                r_station.Qk <= (others => '0');
            end if;
        elsif(cdb_inpt1.mem_valid = '1') then
            if(r_station.Qj = cdb_inpt1.mem_addr) then
                r_station.Vj <= cdb_inpt1.mem_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt1.mem_addr) then
                r_station.Vk <= cdb_inpt1.mem_data;
                r_station.Qk <= (others => '0');
            end if;
        elsif(cdb_inpt2.alu_valid = '1') then                   -- Verificação resultado segunda estação
            if(r_station.Qj = cdb_inpt2.alu_addr) then
                r_station.Vj <= cdb_inpt2.alu_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt2.alu_addr) then
                r_station.Vk <= cdb_inpt2.alu_data;
                r_station.Qk <= (others => '0');
            end if;
        elsif(cdb_inpt2.mem_valid = '1') then
            if(r_station.Qj = cdb_inpt2.mem_addr) then
                r_station.Vj <= cdb_inpt2.mem_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt2.mem_addr) then
                r_station.Vk <= cdb_inpt2.mem_data;
                r_station.Qk <= (others => '0');
            end if;
        elsif(cdb_inpt3.alu_valid = '1') then                   -- Verificação resultado terceira estação
            if(r_station.Qj = cdb_inpt3.alu_addr) then
                r_station.Vj <= cdb_inpt3.alu_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt3.alu_addr) then
                r_station.Vk <= cdb_inpt3.alu_data;
                r_station.Qk <= (others => '0');
            end if;
        elsif(cdb_inpt3.mem_valid = '1') then
            if(r_station.Qj = cdb_inpt3.mem_addr) then
                r_station.Vj <= cdb_inpt3.mem_data;
                r_station.Qj <= (others => '0');
            end if;
            if(r_station.Qk = cdb_inpt3.mem_addr) then
                r_station.Vk <= cdb_inpt3.mem_data;
                r_station.Qk <= (others => '0');
            end if;
        end if;
    end process;
end;
  
