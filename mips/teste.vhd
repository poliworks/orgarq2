----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.07.2018 09:20:42
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package test is

    type rob_item is 
        record
            value: STD_LOGIC_VECTOR(31 downto 0);
            ready: STD_LOGIC;
            dest: STD_LOGIC_VECTOR(4 downto 0);
            instruction: STD_LOGIC_VECTOR(5 downto 0);
            busy: STD_LOGIC;
            valid: STD_LOGIC;
            tag: STD_LOGIC_VECTOR(4 downto 0);
        end record;
    
    type reservation_item is
        record
            valid: STD_LOGIC;
            Op: STD_LOGIC_VECTOR(2 downto 0);
            Qj: STD_LOGIC_VECTOR(4 downto 0);
            Qk: STD_LOGIC_VECTOR(4 downto 0);
            Vj: STD_LOGIC_VECTOR(31 downto 0);
            Vk: STD_LOGIC_VECTOR(31 downto 0);
            A: STD_LOGIC_VECTOR(15 downto 0);
            busy: STD_LOGIC;
            dest: STD_LOGIC_VECTOR(4 downto 0);
        end record;
        
    type register_item is
        record
            reg: STD_LOGIC_VECTOR(31 downto 0);
            addr: STD_LOGIC_VECTOR(4 downto 0);
            busy: STD_LOGIC;
            reorder: STD_LOGIC_VECTOR(4 downto 0);
        end record;
        
    type cdb_item is
        record
            alu_data: STD_LOGIC_VECTOR(31 downto 0);
            alu_addr: STD_LOGIC_VECTOR(4 downto 0);
            mem_data: STD_LOGIC_VECTOR(31 downto 0);
            mem_addr: STD_LOGIC_VECTOR(4 downto 0);
            owner: STD_LOGIC;
            alu_valid: STD_LOGIC;
            mem_valid: STD_LOGIC;
        end record;
end package test;
--decoder entity 1 instr             
        --    r_valid: in STD_LOGIC_VECTOR(1 downto 0);               --identificação da Estação de reserva disponivel
        --    rob_valid: in STD_LOGIC_VECTOR(1 downto 0);             --identificação do Rob disponivel
        --    addr_unit: in STD_LOGIC_VECTOR(1 downto 0);
        --    regS_busy: in STD_LOGIC;                                --Sinal do regfile que avisa se o rs ta ocupado
        --    regT_busy: in STD_LOGIC;                                --Sinal do regfile que avisa se o rt ta ocupado
        --    regS_reorder: in STD_LOGIC_VECTOR(31 downto 0);         --
        --    regT_reorder: in STD_LOGIC_VECTOR(31 downto 0);         --
        --    regS_rob_ready: in STD_LOGIC;                           --Sinal que avisa que o rs ta pronto
        --    regT_rob_ready: in STD_LOGIC;                           --Sinal que avisa que o rt ta pronto
        --    regS_req: out STD_LOGIC_VECTOR(4 downto 0);             --Sinal que solicita o rs
        --    regT_req: out STD_LOGIC_VECTOR(4 downto 0);             --Sinal que solicita o rt
        --    regS_rob_h: out STD_LOGIC_VECTOR(31 downto 0);          --Sinal que identifica a entrada inicial do rob
        --    regT_rob_h: out STD_LOGIC_VECTOR(31 downto 0);          --Sinal que identifica a entrada inicial do rob
        --    regS_rob_h_value: out STD_LOGIC;                        --Sinal pra liberar a entrada do rob
        --    regT_rob_h_value: out STD_LOGIC;                        --Sinal pra liberar a entrada do rob
        --    reg_r_vj: out STD_LOGIC;                                --Sinal pra liberar a captura do valor liberado pelo rob na estacao de reserva
        --    reg_r_vk: out STD_LOGIC;                                --Sinal pra liberar a captura do valor liberado pelo rob na estacao de reserva
        --    reg_r_qj: out STD_LOGIC_VECTOR(31 downto 0);            --Sinal pra liberar a captura do valor liberado pelo rob na estacao de reserva
        --    reg_r_qk: out STD_LOGIC_VECTOR(31 downto 0);            --Sinal pra liberar a captura do valor liberado pelo rob na estacao de reserva
        --    reg_r_busy: out STD_LOGIC;                              --Sinal pra setar o busy da estacao de reserva
        --    reg_r_dest: out STD_LOGIC_VECTOR(31 downto 0);          --Sinal pra setar o dest da estacao de reserva
        --    rob_instr: out STD_LOGIC_VECTOR(4 downto 0);            --Sinal para enviar instr pro ROB
        --    rob_dest: out STD_LOGIC_VECTOR(31 downto 0);            --Sinal para enviar o rd para o 
        --    rob_ready: out STD_LOGIC;
        --    regT_ative: out STD_LOGIC;
        --    regS_ative: out STD_LOGIC;
        --    reg_r_A: out STD_LOGIC_VECTOR(15 downto 0);
        --    regT_out_reorder: out STD_LOGIC_VECTOR(1 downto 0);
        --    regT_out_busy: out STD_LOGIC;

--decoder dispach 1 instr                
        --        if r_valid /= "00" and rob_valid /= "00" then
        --            reg_r_busy <= '1';
        --            reg_r_dest <= rob_valid;
        --            if(regS_busy = '1') then 
        --                h := regS_reorder;
        --                if regS_rob_ready = '1' then 
        --                    reg_r_vj <= regS_rob_h_value;
        --                else
        --                    reg_r_qj <= h;
        --                end if;
        --            --pegar valor do regfile e colocar na estacao de reserva
        --            else
        --                regS_ative <= '1';
        --            end if;
                    
        --            if instr(31 downto 26) = "00000" then
        --                if(regT_busy = '1') then 
        --                    i := regT_reorder;
        --                    if regt_rob_ready = '1' then 
        --                        reg_r_vk <= regT_rob_h_value;
        --                    else
        --                        reg_r_qk <= i;
        --                    end if;
        --                --pegar valor do regfile e colocar na estacao de reserva
        --                else
        --                    regS_ative <= '1';
        --                end if;
        --            elsif instr = "100011" then -- LW
        --                reg_r_A <= instr(15 downto 0);
        --                regT_out_reorder <= rob_valid;
        --                regT_out_busy <= '1';
                        
        --            elsif instr = "101011" then -- SW
        --                reg_r_A <= instr(15 downto 0);
        --            end if;
        --       end if;
        
        --library IEEE;
        --use IEEE.STD_LOGIC_1164.all;
        
        --package test is
        
        --    type rob_item is 
        --        record
        --            value: STD_LOGIC_VECTOR(31 downto 0);
        --            ready: STD_LOGIC;
        --            dest: STD_LOGIC_VECTOR(31 downto 0);
        --            instruction: STD_LOGIC_VECTOR(31 downto 0);
        --            addr: STD_LOGIC_VECTOR(31 downto 0);
        --            clear: STD_LOGIC;
        --            busy: STD_LOGIC;
        --            valid: STD_LOGIC_VECTOR(31 downto 0);
        --        end record;
            
        --    type reservation_item is
        --        record
        --            Op: STD_LOGIC_VECTOR(4 downto 0);
        --            Qj: STD_LOGIC_VECTOR(3 downto 0);
        --            Qk: STD_LOGIC_VECTOR(3 downto 0);
        --            Vj: STD_LOGIC_VECTOR(31 downto 0);
        --            Vk: STD_LOGIC_VECTOR(31 downto 0);
        --            A: STD_LOGIC_VECTOR(31 downto 0);
        --            busy: STD_LOGIC;
        --            dest: STD_LOGIC;
        --        end record;
                
        --    type register_item is
        --        record
        --            result: STD_LOGIC_VECTOR(31 downto 0);
        --            busy: STD_LOGIC;
        --            reorder: STD_LOGIC_VECTOR(31 downto 0);
        --        end record;
        --end package test;
        
--         case op is
--        when "000000" => controls <= "110000010"; -- RTYPE
--              when "100011" => controls <= "101001000"; -- LW
--              when "101011" => controls <= "001010000"; -- SW
--              when "000100" => controls <= "000100001"; -- BEQ
--              when "001000" => controls <= "101000000"; -- ADDI
--              when "000010" => controls <= "000000100"; -- J
--              when others   => controls <= "---------"; -- illegal op
--        when "00" => alucontrol <= "010"; -- add (for lw/sw/addi)
--              when "01" => alucontrol <= "110"; -- sub (for beq)
--              when others => case funct is      -- R-type instructions
--                                 when "100000" => alucontrol <= "010"; -- add 
--                                 when "100010" => alucontrol <= "110"; -- sub
--                                 when "100100" => alucontrol <= "000"; -- and
--                                 when "100101" => alucontrol <= "001"; -- or
--                                 when "101010" => alucontrol <= "111"; -- slt
--                                 when others   => alucontrol <= "---"; -- ???
--                             end case;