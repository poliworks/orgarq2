----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.07.2018 14:26:10
-- Design Name: 
-- Module Name:  - 
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

entity decoder is --decoder despacho multiplo
port(
    instr1, instr2, instr3:                         in STD_LOGIC_VECTOR(31 downto 0);
    new_instructions:                               in STD_LOGIC;
    regS1_rob, regT1_rob, regD1_rob:                in ROB_ITEM;
    regS2_rob, regT2_rob, regD2_rob:                in ROB_ITEM;
    regS3_rob, regT3_rob, regD3_rob:                in ROB_ITEM;
    busy1, busy2, busy3:                            in STD_LOGIC;
    regS1, regT1, regD1:                            in REGISTER_ITEM;
    regS2, regT2, regD2:                            in REGISTER_ITEM;
    regS3, regT3, regD3:                            in REGISTER_ITEM;
    incoming_rob_data:                              in STD_LOGIC;
    incoming_rob1_data:                             in STD_LOGIC;
    incoming_rob2_data:                             in STD_LOGIC;
    incoming_rob3_data:                             in STD_LOGIC;
    tail:                                           in STD_LOGIC_VECTOR(4 downto 0);
    disp:                                           in STD_LOGIC_VECTOR(1 downto 0);
    incoming_reg_data:                              in STD_LOGIC;
    incoming_reg1_data:                             in STD_LOGIC;
    incoming_reg2_data:                             in STD_LOGIC;
    incoming_reg3_data:                             in STD_LOGIC;
    rob_saved1, rob_saved2, rob_saved3:             in STD_LOGIC;
    reg_saved1, reg_saved2, reg_saved3:             in STD_LOGIC;
    reg_save1, reg_save2, reg_save3:                out STD_LOGIC;
    rob_save1, rob_save2, rob_save3:                out STD_LOGIC;
    sent_reg1_data:                                 out STD_LOGIC;
    sent_reg2_data:                                 out STD_LOGIC;
    sent_reg3_data:                                 out STD_LOGIC;
    sent_rob1_data:                                 out STD_LOGIC;
    sent_rob2_data:                                 out STD_LOGIC;
    sent_rob3_data:                                 out STD_LOGIC;
    sent_r1_data:                                   out STD_LOGIC;
    sent_r2_data:                                   out STD_LOGIC;
    sent_r3_data:                                   out STD_LOGIC;
    regS2_out, regT2_out, regD2_out:                out REGISTER_ITEM;
    regS1_out, regT1_out, regD1_out:                out REGISTER_ITEM;
    reg3_r_out, reg2_r_out, reg1_r_out:             out RESERVATION_ITEM;
    regS3_rob_out, regT3_rob_out, regD3_rob_out:    out ROB_ITEM;
    regS2_rob_out, regT2_rob_out, regD2_rob_out:    out ROB_ITEM;
    regS1_rob_out, regT1_rob_out, regD1_rob_out:    out ROB_ITEM;
    regS3_out, regT3_out, regD3_out:                out REGISTER_ITEM);
end;

architecture behave of decoder is
signal tail1, tail2, tail3: STD_LOGIC_VECTOR(4 downto 0);
signal s_instr1, s_instr2, s_instr3: STD_LOGIC_VECTOR(31 downto 0);
signal s_regS1_rob, s_regT1_rob, s_regD1_rob, 
       s_regS2_rob, s_regT2_rob, s_regD2_rob, 
       s_regS3_rob, s_regT3_rob, s_regD3_rob: ROB_ITEM;
signal s_regS1, s_regT1, 
       s_regS2, s_regT2, 
       s_regS3, s_regT3: REGISTER_ITEM;
signal s_reg1_r, 
       s_reg2_r, 
       s_reg3_r: RESERVATION_ITEM;
signal can_sent1, 
       can_sent2, 
       can_sent3: STD_LOGIC := '0';
begin
                   
   process (all) is
   variable h1, i1, h2, i2, h3, i3: STD_LOGIC_VECTOR(4 downto 0);
   begin
        if (new_instructions = '1') then
            regS1_out.addr <= instr1(25 downto 21);
            regT1_out.addr <= instr1(20 downto 16);
            sent_reg1_data <= '1';
            
            regS2_out.addr <= instr2(25 downto 21);
            regT2_out.addr <= instr2(20 downto 16);
            sent_reg2_data <= '1';
            
            regS3_out.addr <= instr3(25 downto 21); 
            regT3_out.addr <= instr3(20 downto 16);
            sent_reg3_data <= '1';
        end if;
   
        if incoming_reg1_data = '1' then
           s_regS1 <= regS1;
           regS1_rob_out.tag <= regS1.reorder;
           s_regT1 <= regT1;
           regT1_rob_out.tag <= regT1.reorder;
           sent_rob1_data <= '1';
           sent_reg1_data <= '0';
        end if;
        
        if incoming_reg2_data = '1' then
           s_regS2 <= regS2;
           regS2_rob_out.tag <= regS2.reorder;
           s_regT2 <= regT2;
           regT2_rob_out.tag <= regT2.reorder;
           sent_rob2_data <= '1';
           sent_reg2_data <= '0';
        end if;
        
        if incoming_reg3_data = '1' then
           s_regS3 <= regS3;
           regS3_rob_out.tag <= regS3.reorder;
           s_regT3 <= regT3;
           regT3_rob_out.tag <= regT3.reorder;
           sent_rob3_data <= '1';
           sent_reg3_data <= '0';
        end if;
        
        if incoming_rob1_data = '1' then
          s_regS1_rob <= regS1_rob;
          s_regT1_rob <= regT1_rob;
          sent_rob1_data <= '0';
          can_sent1 <= '1';
        end if;
        
        if incoming_rob2_data = '1' then
          s_regS2_rob <= regS2_rob;
          s_regT2_rob <= regT2_rob;
          sent_rob2_data <= '0';
          can_sent2 <= '1';
        end if;
      
        if incoming_rob3_data = '1' then
          s_regS3_rob <= regS3_rob;
          s_regT3_rob <= regT3_rob;
          sent_rob3_data <= '0';
          can_sent3 <= '1';
        end if;
      
        if incoming_rob_data = '1' then
            if(disp = "11") then
                tail1 <= tail;
                tail2 <= tail + 1;
                tail3 <= tail + 2;
            elsif(disp = "10") then
                tail1 <= tail;
                tail2 <= tail + 1;
            elsif(disp = "01") then
                tail1 <= tail;
            else
            end if;
        end if;
        
        if can_sent1 = '1' and busy1 = '0' then
            if(regS1.busy = '1') then
                h1 := regS1.reorder;
                if(regS1_rob.ready = '1') then 
                    reg1_r_out.Vj <= regS1_rob.value;
                    reg1_r_out.Qj <= (others => '0');
                else
                    reg1_r_out.Qj <= h1;
                end if;
            else
                reg1_r_out.Vj <= regS1.reg;
                reg1_r_out.Qj <= (others => '0');
            end if;
            reg1_r_out.busy <= '1';
            reg1_r_out.dest <= tail1;
            regD1_rob_out.instruction <= instr1(31 downto 26);
            regD1_rob_out.dest <= instr1(15 downto 11);
            regD1_rob_out.ready <= '0';
            regD1_rob_out.tag <= tail1;
            if(instr1(31 downto 26) = "000000") then
                if(regT1.busy = '1') then
                    i1 := regT1.reorder;
                    if(regT1_rob.ready = '1') then 
                        reg1_r_out.Vk <= regT1_rob.value;
                        reg1_r_out.Qk <= (others => '0');
                    else
                        reg1_r_out.Qk <= i1;
                    end if;
                else
                    reg1_r_out.Vk <= regT1.reg;
                    reg1_r_out.Qk <= (others => '0');
                end if;
                regD1_out.reorder <= tail1;
                regD1_out.busy <= '1';
                regD1_rob_out.dest <= instr1(15 downto 11);
            elsif(instr1(31 downto 26) = "100011") then
                reg1_r_out.A <= instr1(15 downto 0);
                regT1_out.reorder <= tail1;
                regT1_out.busy <= '1';
                regD1_rob_out.dest <= instr1(20 downto 16);
            elsif(instr1(31 downto 26) = "101011") then 
                reg1_r_out.A <= instr1(15 downto 0);
            end if;
            
            if(instr1(31 downto 26) = "001000") then
                reg1_r_out.Op <= "010";
            elsif(instr1(31 downto 26) = "000000") then
                if(instr1(5 downto 0) = "100000") then
                    reg1_r_out.Op <= "010";
                elsif(instr1(5 downto 0) = "100010") then
                    reg1_r_out.Op <= "110";
                elsif(instr1(5 downto 0) = "100100") then
                    reg1_r_out.Op <= "000";
                elsif(instr1(5 downto 0) = "100101") then
                    reg1_r_out.Op <= "001";
                elsif(instr1(5 downto 0) = "101010") then
                    reg1_r_out.Op <= "111";
                end if;
            end if;
            
            rob_save1 <= '1';
            reg_save1 <= '1';
            sent_r1_data <= '1';
            can_sent1 <= '0';
        end if;
        
        if can_sent2 = '1' and busy2 = '0' then
            reg2_r_out.busy <= '1';
            reg2_r_out.dest <= tail2;
            regD2_rob_out.instruction <= instr2(31 downto 26);
            regD2_rob_out.dest <= instr2(15 downto 11);
            regD2_rob_out.ready <= '0';
            regD2_rob_out.tag <= tail2;
            if instr1(31 downto 26) = "000000" then
                if(instr2(25 downto 21) = instr1(15 downto 11)) then reg2_r_out.Qj <= tail1;
                else 
                    if(regS2.busy = '1') then
                        h2 := regS2.reorder;
                        if(regS2_rob.ready = '1') then 
                            reg2_r_out.Vj <= regS2_rob.value;
                            reg2_r_out.Qj <= (others => '0');
                        else
                            reg2_r_out.Qj <= h2;
                        end if;
                    else
                        reg2_r_out.Vj <= regS2.reg;
                        reg2_r_out.Qj <= (others => '0');
                    end if;
                end if;
                if instr2(31 downto 26) = "000000" then
                    if instr2(20 downto 16) = instr1(15 downto 11) then reg2_r_out.Qk <= tail1;
                    elsif(regT2.busy = '1') then
                        i2 := regT2.reorder;
                        if(regT2_rob.ready = '1') then 
                            reg2_r_out.Vk <= regT2_rob.value;
                            reg2_r_out.Qk <= (others => '0');
                        else
                            reg2_r_out.Qk <= i2;
                        end if;
                    else
                        reg2_r_out.Vk <= regT2.reg;
                        reg2_r_out.Qk <= (others => '0');
                    end if;
                end if;
                regT2_out.reorder <= tail2;
                regT2_out.busy <= '1';
                regD2_rob_out.dest <= instr2(15 downto 11);
            elsif instr1(31 downto 26) /= "000000" then
                if(instr2(25 downto 21) = instr1(20 downto 16)) then reg2_r_out.Qj <= tail1;
                else 
                    if(regS2.busy = '1') then
                        h2 := regS2.reorder;
                        if(regS2_rob.ready = '1') then 
                            reg2_r_out.Vj <= regS2_rob.value;
                            reg2_r_out.Qj <= (others => '0');
                        else
                            reg2_r_out.Qj <= h2;
                        end if;
                    else
                        reg2_r_out.Vj <= regS2.reg;
                        reg2_r_out.Qj <= (others => '0');
                    end if;
                end if;
                if(instr2(31 downto 26) = "000000") then
                    if(instr2(20 downto 16) = instr1(20 downto 16)) then reg2_r_out.Qk <= tail1;
                    elsif(regT2.busy = '1') then
                        i2 := regT2.reorder;
                        if(regT2_rob.ready = '1') then 
                            reg2_r_out.Vk <= regT2_rob.value;
                            reg2_r_out.Qk <= (others => '0');
                        else
                            reg2_r_out.Qk <= i2;
                        end if;
                    else
                        reg2_r_out.Vk <= regT2.reg;
                        reg2_r_out.Qk <= (others => '0');
                    end if;
                    regT2_out.reorder <= tail2;
                    regT2_out.busy <= '1';
                    regD2_rob_out.dest <= instr2(15 downto 11);
                end if;
            end if;
            if(instr2(31 downto 26) = "100011") then
                reg2_r_out.A <= instr2(15 downto 0);
                regT2_out.reorder <= tail2;
                regT2_out.busy <= '1';
                regD2_rob_out.dest <= instr2(20 downto 16);
            elsif(instr2(31 downto 26) = "101011") then
                reg2_r_out.A <= instr2(15 downto 0);
            end if;
                        
            if(instr2(31 downto 26) = "001000") then
                reg2_r_out.Op <= "010";
            elsif(instr2(31 downto 26) = "000000") then
                if(instr2(5 downto 0) = "100000") then
                    reg2_r_out.Op <= "010";
                elsif(instr2(5 downto 0) = "100010") then
                    reg2_r_out.Op <= "110";
                elsif(instr2(5 downto 0) = "100100") then
                    reg2_r_out.Op <= "000";
                elsif(instr2(5 downto 0) = "100101") then
                    reg2_r_out.Op <= "001";
                elsif(instr2(5 downto 0) = "101010") then
                    reg2_r_out.Op <= "111";
                end if;
            end if;
                                
            rob_save2 <= '1';
            reg_save2 <= '1';
            sent_r2_data <= '1';
            can_sent2 <= '0';
        end if;
        
        if can_sent3 = '1' and busy3 = '0' then
            reg3_r_out.busy <= '1';
            reg3_r_out.dest <= tail3;
            regD3_rob_out.instruction <= instr3(31 downto 26);
            regD3_rob_out.dest <= instr3(15 downto 11);
            regD3_rob_out.ready <= '0';
            regD3_rob_out.tag <= tail3;
            
            
            if instr1(31 downto 26) = "000000" then
                if(instr3(25 downto 21) = instr1(15 downto 11)) then reg3_r_out.Qj <= tail1;
                elsif(regS3.busy = '1') then
                    h3 := regS3.reorder;
                    if(regS3_rob.ready = '1') then 
                        reg3_r_out.Vj <= regS3_rob.value;
                        reg3_r_out.Qj <= (others => '0');
                    else
                        reg3_r_out.Qj <= h3;
                    end if;
                else
                    reg3_r_out.Vj <= regS3.reg;
                    reg3_r_out.Qj <= (others => '0');
                end if;
                
                if(instr3(31 downto 26) = "000000") then
                    if(instr3(20 downto 16) = instr1(15 downto 11)) then reg3_r_out.Qk <= tail1;
                    elsif(regT3.busy = '1') then
                        i3 := regT3.reorder;
                        if(regT3_rob.ready = '1') then 
                            reg3_r_out.Vk <= regT3_rob.value;
                            reg3_r_out.Qk <= (others => '0');
                        else
                            reg3_r_out.Qk <= i3;
                        end if;
                    else
                        reg3_r_out.Vk <= regT3.reg;
                        reg3_r_out.Qk <= (others => '0');
                    end if;
                    regT3_out.reorder <= tail3;
                    regT3_out.busy <= '1';
                    regD3_rob_out.dest <= instr3(15 downto 11);
                end if;
            elsif instr1(31 downto 26) /= "000000" then
                if(instr3(25 downto 21) = instr1(20 downto 16)) then reg3_r_out.Qj <= tail1;
                elsif(regS3.busy = '1') then
                    h3 := regS3.reorder;
                    if(regS3_rob.ready = '1') then 
                        reg3_r_out.Vj <= regS3_rob.value;
                        reg3_r_out.Qj <= (others => '0');
                    else
                        reg3_r_out.Qj <= h3;
                    end if;
                else
                    reg3_r_out.Vj <= regS3.reg;
                    reg3_r_out.Qj <= (others => '0');
                end if;
                
                if(instr3(31 downto 26) = "000000") then 
                    if(instr3(20 downto 16) = instr1(20 downto 16)) then reg3_r_out.Qk <= tail1;
                    elsif(regT3.busy = '1') then
                        i3 := regT3.reorder;
                        if(regT3_rob.ready = '1') then 
                            reg3_r_out.Vk <= regT3_rob.value;
                            reg3_r_out.Qk <= (others => '0');
                        else
                            reg3_r_out.Qk <= i3;
                        end if;
                    else
                        reg3_r_out.Vk <= regT3.reg;
                        reg3_r_out.Qk <= (others => '0');
                    end if;
                    regT3_out.reorder <= tail3;
                    regT3_out.busy <= '1';
                    regD3_rob_out.dest <= instr3(15 downto 11);
                end if;
            end if;
            if instr2(31 downto 26) = "000000" then
                if(instr3(25 downto 21) = instr2(15 downto 11)) then reg3_r_out.Qj <= tail2;
                elsif(regS3.busy = '1') then
                    h3 := regS3.reorder;
                    if(regS3_rob.ready = '1') then 
                        reg3_r_out.Vj <= regS3_rob.value;
                        reg3_r_out.Qj <= (others => '0');
                    else
                        reg3_r_out.Qj <= h3;
                    end if;
                else
                    reg3_r_out.Vj <= regS3.reg;
                    reg3_r_out.Qj <= (others => '0');
                end if;
                
                if(instr3(31 downto 26) = "000000") then 
                    if(instr3(20 downto 16) = instr2(15 downto 11)) then reg3_r_out.Qk <= tail2;
                    elsif(regT3.busy = '1') then
                        i3 := regT3.reorder;
                        if(regT3_rob.ready = '1') then 
                            reg3_r_out.Vk <= regT3_rob.value;
                            reg3_r_out.Qk <= (others => '0');
                        else
                            reg3_r_out.Qk <= i3;
                        end if;
                    else
                        reg3_r_out.Vk <= regT3.reg;
                        reg3_r_out.Qk <= (others => '0');
                    end if;
                    regT3_out.reorder <= tail3;
                    regT3_out.busy <= '1';
                    regD3_rob_out.dest <= instr3(15 downto 11);
                end if;
            elsif instr2(31 downto 26) /= "000000" then
                if(instr3(25 downto 21) = instr2(20 downto 16)) then reg3_r_out.Qj <= tail2;
                elsif(regS3.busy = '1') then
                    h3 := regS3.reorder;
                    if(regS3_rob.ready = '1') then 
                        reg3_r_out.Vj <= regS3_rob.value;
                        reg3_r_out.Qj <= (others => '0');
                    else
                        reg3_r_out.Qj <= h3;
                    end if;
                else
                    reg3_r_out.Vj <= regS3.reg;
                    reg3_r_out.Qj <= (others => '0');
                end if;
                
                if(instr3(31 downto 26) = "000000") then 
                    if(instr3(20 downto 16) = instr2(20 downto 16)) then reg3_r_out.Qk <= tail2;
                    elsif(regT3.busy = '1') then
                        i3 := regT3.reorder;
                        if(regT3_rob.ready = '1') then 
                            reg3_r_out.Vk <= regT3_rob.value;
                            reg3_r_out.Qk <= (others => '0');
                        else
                            reg3_r_out.Qk <= i3;
                        end if;
                    else
                        reg3_r_out.Vk <= regT3.reg;
                        reg3_r_out.Qk <= (others => '0');
                    end if;
                    regT3_out.reorder <= tail3;
                    regT3_out.busy <= '1';
                    regD3_rob_out.dest <= instr3(15 downto 11);
                end if;
            end if;
            
            if(instr3(31 downto 26) = "100011") then
                reg3_r_out.A <= instr3(15 downto 0);
                regT3_out.reorder <= tail3;
                regT3_out.busy <= '1';
                regD3_rob_out.dest <= instr3(20 downto 16);
            elsif(instr3(31 downto 26) = "101011") then
                reg3_r_out.A <= instr3(15 downto 0);
            end if;
            
            
                        
            if(instr3(31 downto 26) = "001000") then
                reg3_r_out.Op <= "010";
            elsif(instr3(31 downto 26) = "000000") then
                if(instr3(5 downto 0) = "100000") then
                    reg3_r_out.Op <= "010";
                elsif(instr3(5 downto 0) = "100010") then
                    reg3_r_out.Op <= "110";
                elsif(instr3(5 downto 0) = "100100") then
                    reg3_r_out.Op <= "000";
                elsif(instr3(5 downto 0) = "100101") then
                    reg3_r_out.Op <= "001";
                elsif(instr3(5 downto 0) = "101010") then
                    reg3_r_out.Op <= "111";
                end if;
            end if;
            
                        
            rob_save3 <= '1';
            reg_save3 <= '1';
            sent_r3_data <= '1';
            can_sent3 <= '0';
        end if;
        
        if(rob_saved1 = '1') then
            s_regD1_rob <= regD1_rob;
            rob_save1 <= '0';
        end if;
        
        if(rob_saved2 = '1') then
            s_regD2_rob <= regD2_rob;
            rob_save2 <= '0';
        end if;
        
        if(rob_saved3 = '1') then
            s_regD3_rob <= regD3_rob;
            rob_save3 <= '0';
        end if;
        
        if(reg_saved1 = '1') then
            reg_save1 <= '0';
        end if;
        
        if(reg_saved2 = '1') then
            reg_save2 <= '0';
        end if;
        
        if(reg_saved3 = '1') then
            reg_save3 <= '0';
        end if;
        
        if(busy1 = '1') then
            sent_r1_data <= '0';
        end if;
        
        if(busy2 = '1') then
            sent_r2_data <= '0';
        end if;
        
        if(busy3 = '1') then
            sent_r3_data <= '0';
        end if;
    end process;
    
end;
