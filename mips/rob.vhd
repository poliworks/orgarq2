----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2018 12:51:15
-- Design Name: 
-- Module Name: rob - behave
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
use IEEE.STD_LOGIC_UNSIGNED.all;
use WORK.TEST.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity rob is --reorder buffer
port(
    clock, reset: in STD_LOGIC;
    decode_save: in STD_LOGIC;
    regS1_rob, regT1_rob, regD1_rob: in ROB_ITEM;
    regS2_rob, regT2_rob, regD2_rob: in ROB_ITEM;
    regS3_rob, regT3_rob, regD3_rob: in ROB_ITEM;
    cdb1_inp, cdb2_inp, cdb3_inp: in CDB_ITEM;
    incoming_rob1_data:                             in STD_LOGIC;
    incoming_rob2_data:                             in STD_LOGIC;
    incoming_rob3_data:                             in STD_LOGIC;
    cdb1_out, cdb2_out, cdb3_out: out CDB_ITEM;
    regfile_addr1, regfile_addr2, regfile_addr3: out STD_LOGIC_VECTOR(4 downto 0);
    regfile_data1, regfile_data2, regfile_data3: out STD_LOGIC_VECTOR(31 downto 0);
    sent_rob_data:                              out STD_LOGIC;
    sent_rob1_data:                             out STD_LOGIC;
    sent_rob2_data:                             out STD_LOGIC;
    sent_rob3_data:                             out STD_LOGIC;
    rob_reg_transmit1, rob_reg_transmit2, rob_reg_transmit3: out STD_LOGIC;
    rob_reg_store1, rob_reg_store2, rob_reg_store3: out STD_LOGIC;
    regS1_rob_out, regT1_rob_out, regD1_rob_out: out ROB_ITEM;
    regS2_rob_out, regT2_rob_out, regD2_rob_out: out ROB_ITEM;
    regS3_rob_out, regT3_rob_out, regD3_rob_out: out ROB_ITEM;
    tail_out: out STD_LOGIC_VECTOR(4 downto 0);
    disp: out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of rob is
type rob_table is array (0 to 31) of ROB_ITEM;
signal head: STD_LOGIC_VECTOR(4 downto 0) := "11111";
signal tail: STD_LOGIC_VECTOR(4 downto 0) := "00000";
signal checkHead: STD_LOGIC_VECTOR(4 downto 0);
signal rob_full: STD_LOGIC;
signal rob : rob_table;
signal regD1_tag_out, regD2_tag_out, regD3_tag_out: STD_LOGIC_VECTOR(4 downto 0);
begin
    checkHead <= head + 1;

    process (clock, reset, regD1_rob, regD2_rob, regD3_rob, cdb1_inp, cdb2_inp, cdb3_inp) is
    variable tmp: STD_LOGIC_VECTOR(4 downto 0);
    variable chead: STD_LOGIC_VECTOR(4 downto 0);
    variable qnt: INTEGER := 0;
        variable offset: INTEGER;
        variable tmp_tail: STD_LOGIC_VECTOR(4 downto 0);
    begin
        if reset = '1' then
            tail <= "00000";
            head <= "11111";
            tail_out <= tail;
            disp <= "11";
            sent_rob_data <= '1';
            for i in 0 to 31 loop
                rob(i).valid <= '0';
                rob(i).tag <= conv_std_logic_vector(i, 5);
                rob(i).ready <= '0';
                rob(i).busy <= '0';
            end loop;
        elsif(rising_edge(clock)) then
            if(tail > head) then
                tmp := tail - "11111";
                tmp := tmp + head;
                tmp := tmp + '1';
            elsif(tail < head)then
                tmp := head - tail;
                tmp := tmp + '1';
            elsif(tail = head)then tmp := "00001";
            end if;
            if(tmp > 3) then
                disp <= "11";
            else
                disp <= tmp(1 downto 0);
            end if;
            
            tmp := head + 1;
            
            if(rob(conv_integer(tmp)).ready = '1') then
                regfile_addr1 <= rob(conv_integer(tmp)).dest;
                regfile_data1 <= rob(conv_integer(tmp)).value;
                if(rob(conv_integer(tmp)).instruction = "101011") then
                    rob_reg_store1 <= '1';
                else 
                    rob_reg_transmit1 <= '1';
                end if;
                rob(conv_integer(tmp)).value <= (others => '0');
                rob(conv_integer(tmp)).ready <= '0';
                rob(conv_integer(tmp)).dest <= (others => '0');
                rob(conv_integer(tmp)).instruction <= (others => '0');
                rob(conv_integer(tmp)).busy <= '0';
                rob(conv_integer(tmp)).valid <= '0';
                rob(conv_integer(tmp)).tag <= (others => '0');
                tmp := tmp + 1;
            else
                rob_reg_store1 <= '0';
                rob_reg_transmit1 <= '0';
            end if;
            
            if(rob(conv_integer(tmp)).ready = '1') then
                regfile_addr2 <= rob(conv_integer(tmp)).dest;
                regfile_data2 <= rob(conv_integer(tmp)).value;
                if(rob(conv_integer(tmp)).instruction = "101011") then
                    rob_reg_store2 <= '1';
                else 
                    rob_reg_transmit2 <= '1';
                end if;
                rob(conv_integer(tmp)).value <= (others => '0');
                rob(conv_integer(tmp)).ready <= '0';
                rob(conv_integer(tmp)).dest <= (others => '0');
                rob(conv_integer(tmp)).instruction <= (others => '0');
                rob(conv_integer(tmp)).busy <= '0';
                rob(conv_integer(tmp)).valid <= '0';
                rob(conv_integer(tmp)).tag <= (others => '0');
                tmp := tmp + 1; 
                
            else
                rob_reg_store2 <= '0';
                rob_reg_transmit2 <= '0';
            end if;
            
            if(rob(conv_integer(tmp)).ready = '1') then
                regfile_addr3 <= rob(conv_integer(tmp)).dest;
                regfile_data3 <= rob(conv_integer(tmp)).value;
                if(rob(conv_integer(tmp)).instruction = "101011") then
                    rob_reg_store3 <= '1';
                else 
                    rob_reg_transmit3 <= '1';
                end if;
                rob(conv_integer(tmp)).value <= (others => '0');
                rob(conv_integer(tmp)).ready <= '0';
                rob(conv_integer(tmp)).dest <= (others => '0');
                rob(conv_integer(tmp)).instruction <= (others => '0');
                rob(conv_integer(tmp)).busy <= '0';
                rob(conv_integer(tmp)).valid <= '0';
                rob(conv_integer(tmp)).tag <= (others => '0');
                tmp := tmp + 1;
                
            else
                rob_reg_store3 <= '0';
                rob_reg_transmit3 <= '0';
            end if;
            
            head <= tmp;
        end if;
        
        if(decode_save = '1') then
            offset := 0;
            tmp_tail := tail;
            for i in 0 to 31 loop
                if(conv_integer(regD1_rob.tag) = i) then
                    rob(i) <= regD1_rob;
                    offset := offset + 1;
                end if;
                if(conv_integer(regD2_rob.tag) = i) then
                    rob(i) <= regD2_rob;
                    offset := offset + 1;
                end if;
                if(conv_integer(regD3_rob.tag) = i) then
                    rob(i) <= regD3_rob;
                    offset := offset + 1;
                end if;
            end loop;
            tail <= tmp_tail + offset;
        end if;
            
        if(cdb1_inp.alu_valid = '1') then
            rob(conv_integer(cdb1_inp.alu_addr)).value <= cdb1_inp.alu_data;
            rob(conv_integer(cdb1_inp.alu_addr)).ready <= '1';
        elsif(cdb1_inp.mem_valid = '1') then
            rob(conv_integer(cdb1_inp.mem_addr)).value <= cdb1_inp.mem_data;
            rob(conv_integer(cdb1_inp.mem_addr)).ready <= '1';
        elsif(cdb2_inp.alu_valid = '1') then
            rob(conv_integer(cdb2_inp.alu_addr)).value <= cdb1_inp.alu_data;
            rob(conv_integer(cdb2_inp.alu_addr)).ready <= '1';
        elsif(cdb2_inp.mem_valid = '1') then
            rob(conv_integer(cdb2_inp.mem_addr)).value <= cdb1_inp.mem_data;
            rob(conv_integer(cdb2_inp.mem_addr)).ready <= '1';
        elsif(cdb3_inp.alu_valid = '1') then
            rob(conv_integer(cdb3_inp.alu_addr)).value <= cdb1_inp.alu_data;
            rob(conv_integer(cdb3_inp.alu_addr)).ready <= '1';
        elsif(cdb3_inp.mem_valid = '1') then
            rob(conv_integer(cdb3_inp.mem_addr)).value <= cdb1_inp.mem_data;
            rob(conv_integer(cdb3_inp.mem_addr)).ready <= '1';
        end if;
    end process;
    
    process (head, tail, rob) is
    begin
        if(head = tail) and (rob(conv_integer(head)).valid = '1') then
            rob_full <= '1';
        else
            rob_full <= '0';
        end if;
    end process;
    
    process (regS1_rob, regT1_rob, regS2_rob, regT2_rob, regS3_rob, regT3_rob) is
    begin
        regS1_rob_out <= rob(conv_integer(regS1_rob.tag));
        regT1_rob_out <= rob(conv_integer(regT1_rob.tag));
        regS2_rob_out <= rob(conv_integer(regS2_rob.tag));
        regT2_rob_out <= rob(conv_integer(regT2_rob.tag));
        regS3_rob_out <= rob(conv_integer(regS3_rob.tag));
        regT3_rob_out <= rob(conv_integer(regT3_rob.tag));
    end process;
end;
