----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2018 11:15:48
-- Design Name: 
-- Module Name: datapath - 
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

entity datapath is  -- MIPS datapath
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
       busy1, busy2, busy3:                             out STD_LOGIC;
       tail_out:                                        out STD_LOGIC_VECTOR(4 downto 0);
       disp:                                            out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture struct of datapath is
  component alu
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
         addr:       in  STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
         result:     out CDB_ITEM;
         zero:       out STD_LOGIC);
  end component;
  
  
  component regfile is -- three-port register file
    port(clk:                  in  STD_LOGIC;
        we1:                 in  STD_LOGIC;
        rs1, rt1:            in REGISTER_ITEM; 
        wa1:                 in  STD_LOGIC_VECTOR(4 downto 0);
        wd1:                 in  STD_LOGIC_VECTOR(31 downto 0);
        rd1:                 in REGISTER_ITEM;
        rs1_out, rt1_out:    out REGISTER_ITEM;
        we2:                 in  STD_LOGIC;
        rs2, rt2:            in REGISTER_ITEM;
        wa2:                 in  STD_LOGIC_VECTOR(4 downto 0);
        wd2:                 in  STD_LOGIC_VECTOR(31 downto 0);
        rd2:                 in REGISTER_ITEM;
        rs2_out, rt2_out:    out REGISTER_ITEM;
        we3:                 in  STD_LOGIC;
        rs3, rt3:            in REGISTER_ITEM;
        wa3:                 in  STD_LOGIC_VECTOR(4 downto 0);
        wd3:                 in  STD_LOGIC_VECTOR(31 downto 0);
        rd3:                 in REGISTER_ITEM;
        rs3_out, rt3_out:    out REGISTER_ITEM);
  end component;
  
  
  component adder
    port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
         y:    out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component sl2
    port(a: in  STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component signext
    port(a: in  STD_LOGIC_VECTOR(15 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component flopr generic(width: integer);
    port(clk, reset: in  STD_LOGIC;
         d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
         q:          out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  component mux2 generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  
  component cdb is --COMMOM DATA BUS
  port(
      alu_cdb: in CDB_ITEM;
      mem_cdb: in CDB_ITEM;
      alu_cdb_out: out CDB_ITEM;
      mem_cdb_out: out CDB_ITEM);
  end component;
  
  component rob is --reorder buffer
      port(
          clock, reset: in STD_LOGIC;
          need_robs: in STD_LOGIC;
          regS1_rob, regT1_rob, regD1_rob: in ROB_ITEM;
          regS2_rob, regT2_rob, regD2_rob: in ROB_ITEM;
          regS3_rob, regT3_rob, regD3_rob: in ROB_ITEM;
          cdb1_inp, cdb2_inp, cdb3_inp: in CDB_ITEM;
          cdb1_out, cdb2_out, cdb3_out: out CDB_ITEM;
          regfile_addr1, regfile_addr2, regfile_addr3: out STD_LOGIC_VECTOR(4 downto 0);
          regfile_data1, regfile_data2, regfile_data3: out STD_LOGIC_VECTOR(31 downto 0);
          rob_reg_transmit1, rob_reg_transmit2, rob_reg_transmit3: out STD_LOGIC;
          rob_reg_store1, rob_reg_store2, rob_reg_store3: out STD_LOGIC;
          regS1_rob_out, regT1_rob_out, regD1_rob_out: out ROB_ITEM;
          regS2_rob_out, regT2_rob_out, regD2_rob_out: out ROB_ITEM;
          regS3_rob_out, regT3_rob_out, regD3_rob_out: out ROB_ITEM;
          tail_out: out STD_LOGIC_VECTOR(4 downto 0);
          disp: out STD_LOGIC_VECTOR(1 downto 0));
  end component;
  
  component reservation_station is --reservation station
    port(
        reset:      in STD_LOGIC;
        reg_r:      in RESERVATION_ITEM;
        cdb_inpt1, cdb_inpt2, cdb_inpt3: in CDB_ITEM;
        rs, rt, rd: out STD_LOGIC_VECTOR(31 downto 0);
        op:         out STD_LOGIC_VECTOR(2 downto 0);
        busy:       out STD_LOGIC);
  end component;
  
  signal writereg:           STD_LOGIC_VECTOR(4 downto 0);
  signal pcjump, pcnext, 
         pcnextbr, pcplus4, 
         pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal srca, srcb, result: STD_LOGIC_VECTOR(31 downto 0);
  
  signal cdb_input1, cdb_input2, cdb_input3: CDB_ITEM;
  signal cdb1_out, cdb2_out, cdb3_out: CDB_ITEM;
  signal a1, b1, c1: STD_LOGIC_VECTOR(31 downto 0);
  signal a2, b2, c2: STD_LOGIC_VECTOR(31 downto 0);
  signal a3, b3, c3: STD_LOGIC_VECTOR(31 downto 0);
  signal op1, op2, op3: STD_LOGIC_VECTOR(2 downto 0);
  
  signal we1: STD_LOGIC;
  signal wa1: STD_LOGIC_VECTOR(4 downto 0);
  signal wd1: STD_LOGIC_VECTOR(31 downto 0);
  signal rs1_out, rt1_out: REGISTER_ITEM;
  signal we2: STD_LOGIC;
  signal wa2: STD_LOGIC_VECTOR(4 downto 0);
  signal wd2: STD_LOGIC_VECTOR(31 downto 0);
  signal rs2_out, rt2_out: REGISTER_ITEM;
  signal we3: STD_LOGIC;
  signal wa3: STD_LOGIC_VECTOR(4 downto 0);
  signal wd3: STD_LOGIC_VECTOR(31 downto 0);
  signal rs3_out, rt3_out: REGISTER_ITEM;
  
begin
  -- next PC logic
--  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00";
--  pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc);
--  pcadd1: adder port map(pc, X"00000004", pcplus4);
--  immsh: sl2 port map(signimm, signimmsh);
--  pcadd2: adder port map(pcplus4, signimmsh, pcbranch);
--  pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, 
--                                         pcsrc, pcnextbr);
--  pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext);
  
  --reoder buffer
  reorder: rob port map(clk, reset, need_robs, 
                        regS1_rob, regT1_rob, regD1_rob, 
                        regS2_rob, regT2_rob, regD2_rob, 
                        regS3_rob, regT3_rob, regD3_rob, 
                        cdb_input1, cdb_input2, cdb_input3, 
                        cdb1_out, cdb2_out, cdb3_out, 
                        wa1, wa2, wa3, 
                        wd1, wd2, wd3, 
                        we1, we2, we3,
                        rob_reg_store1, rob_reg_store2, rob_reg_store3, 
                        regS1_rob_out, regT1_rob_out, regD1_rob_out, 
                        regS2_rob_out, regT2_rob_out, regD2_rob_out, 
                        regS3_rob_out, regT3_rob_out, regD3_rob_out,
                        tail_out, disp);

  -- register file logic
  rf: regfile port map(clk, we1, regS1, regT1, wa1, wd1, regD1, rs1_out, rt1_out,
                            we2, regS2, regT2, wa2, wd2, regD2, rs2_out, rt2_out,
                            we3, regS3, regT3, wa3, wd3, regD3, rs3_out, rt3_out);
                                        
                                        
                                        
--  se: signext port map(instr(15 downto 0), signimm);

    --FIRST Alu Logic RESERVATION STATION
    first: reservation_station port map (reset, reg_r1, cdb_input1, cdb_input2, cdb_input3, a1, b1, c1, op1, busy1);
    firstalu: alu port map(a1, b1, c1, op1, cdb_input1, open);

    --SECOND Alu Logic RESERVATION STATION
    second: reservation_station port map (reset, reg_r2, cdb_input1, cdb_input2, cdb_input3, a2, b2, c2, op2, busy2);
    secondalu: alu port map(a2, b2, c2, op2, cdb_input2, open);

    --THIRD Alu Logic RESERVATION STATION
    third: reservation_station port map (reset, reg_r3, cdb_input1, cdb_input2, cdb_input3, a3, b3, c3, op3, busy3);
    thirdalu: alu port map(a3, b3, c3, op3, cdb_input3, open);
end;
