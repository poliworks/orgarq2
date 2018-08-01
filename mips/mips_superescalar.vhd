----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.07.2018 02:24:42
-- Design Name: 
-- Module Name: mips_superescalar - Behavioral
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
library WORK;
use WORK.TEST.all; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mips_superescalar is
    Port (  
            clk, reset: in STD_LOGIC;
            instr1, instr2, instr3: in STD_LOGIC_VECTOR(31 downto 0);
            store1, store2, store3: out STD_LOGIC);
end mips_superescalar;

architecture Behavioral of mips_superescalar is

    component datapath is  -- MIPS datapath
      port(clk, reset, need_robs:                           in STD_LOGIC;
           regS1_rob, regT1_rob, regD1_rob:                 in ROB_ITEM;
           regS2_rob, regT2_rob, regD2_rob:                 in ROB_ITEM;
           regS3_rob, regT3_rob, regD3_rob:                 in ROB_ITEM;
           reg_r1, reg_r2, reg_r3:                          in RESERVATION_ITEM;
           regS1, regT1, regD1:                             in REGISTER_ITEM;
           regS2, regT2, regD2:                             in REGISTER_ITEM;
           regS3, regT3, regD3:                             in REGISTER_ITEM;
           regS2_out, regT2_out:                            out REGISTER_ITEM;
           regS1_out, regT1_out:                            out REGISTER_ITEM;
           regS3_out, regT3_out:                            out REGISTER_ITEM;
           rob_reg_store1, rob_reg_store2, rob_reg_store3:  out STD_LOGIC;
           regS1_rob_out, regT1_rob_out, regD1_rob_out:     out ROB_ITEM;
           regS2_rob_out, regT2_rob_out, regD2_rob_out:     out ROB_ITEM;
           regS3_rob_out, regT3_rob_out, regD3_rob_out:     out ROB_ITEM;
           busy1, busy2, busy3:                             out STD_LOGIC);
    end component;

    component decoder is --decoder despacho multiplo
        port(
            instr1, instr2, instr3:                         in STD_LOGIC_VECTOR(31 downto 0);
            regS1_rob, regT1_rob, regD1_rob:                in ROB_ITEM;
            regS2_rob, regT2_rob, regD2_rob:                in ROB_ITEM;
            regS3_rob, regT3_rob, regD3_rob:                in ROB_ITEM;
            reg1_r, reg2_r, reg3_r:                         in STD_LOGIC;
            regS1, regT1, regD1:                            in REGISTER_ITEM;
            regS2, regT2, regD2:                            in REGISTER_ITEM;
            regS3, regT3, regD3:                            in REGISTER_ITEM;
            regS2_out, regT2_out:                           out REGISTER_ITEM;
            regS1_out, regT1_out:                           out REGISTER_ITEM;
            reg3_r_out, reg2_r_out, reg1_r_out:             out RESERVATION_ITEM;
            need_robs:                                      out STD_LOGIC;
            regS3_rob_out, regT3_rob_out, regD3_rob_out:    out ROB_ITEM;
            regS2_rob_out, regT2_rob_out, regD2_rob_out:    out ROB_ITEM;
            regS1_rob_out, regT1_rob_out, regD1_rob_out:    out ROB_ITEM;
            regS3_out, regT3_out:                           out REGISTER_ITEM);
    end component;
    signal regS1_rob, regT1_rob, regD1_rob: ROB_ITEM;
    signal regS2_rob, regT2_rob, regD2_rob: ROB_ITEM;
    signal regS3_rob, regT3_rob, regD3_rob: ROB_ITEM;
    signal reg1_r, reg2_r, reg3_r: STD_LOGIC;
    signal regS1, regT1, regD1: REGISTER_ITEM;
    signal regS2, regT2, regD2: REGISTER_ITEM;
    signal regS3, regT3, regD3: REGISTER_ITEM;
    signal regS2_out, regT2_out: REGISTER_ITEM;
    signal regS1_out, regT1_out: REGISTER_ITEM;
    signal reg3_r_out, reg2_r_out, reg1_r_out: RESERVATION_ITEM;
    signal need_robs: STD_LOGIC;
    signal regS3_rob_out, regT3_rob_out, regD3_rob_out: ROB_ITEM;
    signal regS2_rob_out, regT2_rob_out, regD2_rob_out: ROB_ITEM;
    signal regS1_rob_out, regT1_rob_out, regD1_rob_out: ROB_ITEM;
    signal regS3_out, regT3_out: REGISTER_ITEM;
begin
    
    controller: decoder port map (instr1, instr2, instr3, 
                                    regS1_rob, regT1_rob, regD1_rob, 
                                    regS2_rob, regT2_rob, regD2_rob, 
                                    regS3_rob, regT3_rob, regD3_rob, 
                                    reg1_r, reg2_r, reg3_r, 
                                    regS1, regT1, regD1, 
                                    regS2, regT2, regD2, 
                                    regS3, regT3, regD3, 
                                    regS2_out, regT2_out, 
                                    regS1_out, regT1_out, 
                                    reg3_r_out, reg2_r_out, reg1_r_out,
                                    need_robs, 
                                    regS3_rob_out, regT3_rob_out, regD3_rob_out,
                                    regS2_rob_out, regT2_rob_out, regD2_rob_out,
                                    regS1_rob_out, regT1_rob_out, regD1_rob_out,
                                    regS3_out, regT3_out);
         
     data: datapath port map (clk, reset, need_robs, 
                              regS1_rob_out, regT1_rob_out, regD1_rob_out, 
                              regS2_rob_out, regT2_rob_out, regD2_rob_out, 
                              regS3_rob_out, regT3_rob_out, regD3_rob_out, 
                              reg1_r_out, reg2_r_out, reg3_r_out, 
                              regS1, regT1, regD1, 
                              regS2, regT2, regD2, 
                              regS3, regT3, regD3, 
                              regS2_out, regT2_out, regS1_out, 
                              regT1_out, regS3_out, regT3_out, 
                              store1, store2, store3, 
                              regS1_rob, regT1_rob, regD1_rob, 
                              regS2_rob, regT2_rob, regD2_rob, 
                              regS3_rob, regT3_rob, regD3_rob, 
                              reg1_r, reg2_r, reg3_r);

end Behavioral;
