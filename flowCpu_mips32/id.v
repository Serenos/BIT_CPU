`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: id
// Project Name: flowCPU_mips
// Target Devices: 
// Tool Versions: 
// Description: this module is for storing the Inst and InstAddr and pass them on 
// at next clk
// 
// Dependencies: 
// 
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module id(
    input rst,
    input clk,

    input wire[`InstAddrBus]    pc_i,
    input wire[`InstBus]        inst_i,

    input wire[`RegBus]         reg_data1_i,
    input wire[`RegBus]         reg_data2_i,

    output reg                  en_reg_read1_o,
    output reg                  en_reg_read2_o,
    output reg[`RegAddrBus]     reg_addr1_o,
    output reg[`RegAddrBus]     reg_addr2_o,

    output reg[`AluOpBus]       aluop_o,
    output reg[`AluSelBus]      alusel_o,
    output reg[`RegBus]         reg1_o,
    output reg[`RegBus]         reg2_o,
    output reg[`RegAddrBus]     wd_o,
    output reg                  wreg_o,

    //处于执行阶段指令的运算结果
    input wire ex_wreg_i,
    input wire[`RegBus] ex_wdata_i,
    input wire[`RegAddrBus] ex_wd_i,
    //处于访存阶段指令的晕眩结果
    input wire mem_wreg_i,
    input wire[`RegBus] mem_wdata_i,
    input wire[`RegAddrBus] mem_wd_i,

    input wire is_in_delayslot_i,//当前处于译码阶段的指令是否位延迟槽指令

    output reg next_inst_delayslot_o,//下一条进入译码阶段的指令是否位于延迟槽
    output reg branch_flag_o,//是否转移
    output reg[`RegBus] branch_target_addr_o,
    output reg[`RegBus] link_addr_o,//转移指令要保存的返回地址
    output reg is_in_delayslot_o,


    output wire[`RegBus] inst_o
);

    assign inst_o = inst_i;

    wire[5:0] op = inst_i[31:26];
    wire[5:0] funcode = inst_i[5:0];
    wire[4:0] sa = inst_i[10:6];
    wire[4:0] rt = inst_i[20:16];
    wire[4:0] rd = inst_o[15:11];

    reg[`RegBus] imm;
    reg instValid;

    wire[`RegBus] pc8;
    wire[`RegBus] pc4;
    wire[`RegBus] imm_sll2_signext;//offset左移两位并且符号扩展32位
    assign pc8 = pc_i + 8;//当前指令后第2条指令的地址
    assign pc4 = pc_i + 4;//当前指令后第1条指令的地址
    assign imm_sll2_signext = {{14{inst_i[15]}}, inst_i[15:0], 2'b00};



    always @(*) begin
        if(rst == `RESETABLE) begin
            aluop_o  <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= `NOPRegAddr;
            wreg_o <= `UNWRITEABLE;
            en_reg_read1_o <= 1'b0;
            en_reg_read2_o <= 1'b0;
            reg_addr1_o <= `NOPRegAddr;
            reg_addr2_o <= `NOPRegAddr;
            imm <= 32'h0;
            instValid <= `InstValid;

            link_addr_o <= `ZEROWORD;
            branch_target_addr_o <= `ZEROWORD;
            next_inst_delayslot_o <= `NotInDelaySlot;
            branch_flag_o <= `NOTBRANCH;

        end else begin
            aluop_o  <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            wd_o <= inst_i[15:11];
            wreg_o <= `UNWRITEABLE;
            en_reg_read1_o <= 1'b0;
            en_reg_read2_o <= 1'b0;
            reg_addr1_o <= inst_i[25:21];
            reg_addr2_o <= inst_i[20:16];
            imm <= 32'h0;
            instValid <= `InstValid;
            
            link_addr_o <= `ZEROWORD;
            branch_target_addr_o <= `ZEROWORD;
            next_inst_delayslot_o <= `NotInDelaySlot;
            branch_flag_o <= `NOTBRANCH;

             case(op)
                `EXE_SPECIAL_INST: begin
                    case(sa)
                        5'b00000: begin
                            case(funcode)
                                `EXE_OR: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_OR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;
                                end
                                `EXE_AND: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_AND_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;
                                end
                                `EXE_XOR: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_XOR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                    
                                end
                                `EXE_NOR: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_NOR_OP;
                                    alusel_o <= `EXE_RES_LOGIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                    
                                end
                                `EXE_SLLV:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SLL_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                    
                                end
                                `EXE_SRLV: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SRL_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                     
                                end
                                `EXE_SRAV: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SRA_OP;
                                    alusel_o <= `EXE_RES_SHIFT;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                     
                                end
                                `EXE_SYNC: begin
                                    wreg_o <= `UNWRITEABLE;
                                    aluop_o <= `EXE_NOP_OP;
                                    alusel_o <= `EXE_RES_NOP;
                                    en_reg_read1_o <= 1'b0;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                     
                                end
                                `EXE_SLT: begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SLT_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;
                                end
                                `EXE_SLTU:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SLTU_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;
                                    
                                end
                                `EXE_ADD:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_ADD_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;
                                end
                                `EXE_ADDU:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_ADDU_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                   
                                end
                                `EXE_SUB:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SUB_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                 
                                end
                                `EXE_SUBU:begin
                                    wreg_o <= `WRITEABLE;
                                    aluop_o <= `EXE_SUBU_OP;
                                    alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                    
                                end
                                `EXE_MULT:begin
                                    wreg_o <= `UNWRITEABLE;
                                    aluop_o <= `EXE_MULT_OP;
                                    //alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                      
                                end
                                `EXE_MULTU:begin
                                    wreg_o <= `UNWRITEABLE;
                                    aluop_o <= `EXE_MULTU_OP;
                                    //alusel_o <= `EXE_RES_ARITHMETIC;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    instValid <= `InstValid;                                     
                                end
                                `EXE_JR:begin
                                    wreg_o <= `UNWRITEABLE;
                                    aluop_o <= `EXE_JR_OP;
                                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b0;
                                    link_addr_o <= `ZEROWORD;
                                    branch_target_addr_o <= reg1_o;
                                    branch_flag_o <= `BRANCH;
                                    next_inst_delayslot_o <= `InDelaySlot;
                                    instValid <= `InstValid;
                                end
                                `EXE_JALR:begin
                                    wreg_o <= `WRITEABLE;
                                    wd_o <= rd;
                                    aluop_o <= `EXE_JALR_OP;
                                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b0;
                                    link_addr_o <= pc8;
                                    branch_target_addr_o <= reg1_o;
                                    branch_flag_o <= `BRANCH;
                                    next_inst_delayslot_o <= `InDelaySlot;
                                    instValid <= `InstValid;                                   
                                end
                                `EXE_MOVN: begin
                                    aluop_o <= `EXE_MOVN_OP;
                                    alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    if(reg2_o != `ZEROWORD) begin
                                        wreg_o <= `WRITEABLE;
                                    end else begin
                                        wreg_o <= `UNWRITEABLE;
                                    end
                                    instValid <= `InstValid;  
                                end             
                                `EXE_MOVZ: begin
                                    aluop_o <= `EXE_MOVZ_OP;
                                    alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b1;
                                    if(reg2_o == `ZEROWORD) begin
                                        wreg_o <= `WRITEABLE;
                                    end else begin
                                        wreg_o <= `UNWRITEABLE;
                                    end
                                    instValid <= `InstValid;  
                                end
                                `EXE_MFHI: begin
                                    aluop_o <= `EXE_MFHI_OP;
                                    alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b0;
                                    en_reg_read2_o <= 1'b0;
                                    wreg_o <= `WRITEABLE;
                                    instValid <= `InstValid;  
                                end
                                `EXE_MTHI: begin
                                    aluop_o <= `EXE_MTHI_OP;
                                    //alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b0;
                                    wreg_o <= `UNWRITEABLE;
                                    instValid <= `InstValid;  
                                end
                                `EXE_MFLO: begin
                                    aluop_o <= `EXE_MFLO_OP;
                                    alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b0;
                                    en_reg_read2_o <= 1'b0;
                                    wreg_o <= `WRITEABLE;
                                    instValid <= `InstValid; 
                                end
                                `EXE_MTLO: begin
                                    aluop_o <= `EXE_MTLO_OP;
                                    //alusel_o <= `EXE_RES_MOVE;
                                    en_reg_read1_o <= 1'b1;
                                    en_reg_read2_o <= 1'b0;
                                    wreg_o <= `UNWRITEABLE;
                                    instValid <= `InstValid; 
                                end
                                default: begin
                                end
                            endcase
                        end
                        default: begin
                        end
                    endcase  
                end

                `EXE_ORI: begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                `EXE_ANDI: begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_AND_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                `EXE_XORI: begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_XOR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {16'h0, inst_i[15:0]};
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                `EXE_LUI: begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= { inst_i[15:0], 16'h0};
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end   
                `EXE_PREF:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_NOP_OP;
                    alusel_o <= `EXE_RES_NOP;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b0;
                    instValid <= `InstValid;
                end    
                `EXE_SLTI:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_SLT_OP;
                    alusel_o <= `EXE_RES_ARITHMETIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= rt;
                    instValid <= `InstValid; 
                end
                `EXE_SLTIU:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_SLTU_OP;
                    alusel_o <= `EXE_RES_ARITHMETIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= rt;
                    instValid <= `InstValid; 
                end
                `EXE_ADDI:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_ADDI_OP;
                    alusel_o <= `EXE_RES_ARITHMETIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= rt;
                    instValid <= `InstValid; 
                end
                `EXE_ADDIU:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_ADDIU_OP;
                    alusel_o <= `EXE_RES_ARITHMETIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= {{16{inst_i[15]}}, inst_i[15:0]};
                    wd_o <= rt;
                    instValid <= `InstValid; 
                end
                `EXE_SPECIAL2_INST:begin
                    case(funcode)
                        `EXE_CLZ:begin
                            wreg_o <= `WRITEABLE;
                            aluop_o <= `EXE_CLZ_OP;
                            alusel_o <= `EXE_RES_ARITHMETIC;
                            en_reg_read1_o <= 1'b1;
                            en_reg_read2_o <= 1'b0;
                            instValid <= `InstValid;
                        end
                        `EXE_CLO:begin
                            wreg_o <= `WRITEABLE;
                            aluop_o <= `EXE_CLO_OP;
                            alusel_o <= `EXE_RES_ARITHMETIC;
                            en_reg_read1_o <= 1'b1;
                            en_reg_read2_o <= 1'b0;
                            instValid <= `InstValid;                            
                        end
                        `EXE_MUL:begin
                            wreg_o <= `WRITEABLE;
                            aluop_o <= `EXE_MUL_OP;
                            alusel_o <= `EXE_RES_MUL;
                            en_reg_read1_o <= 1'b1;
                            en_reg_read2_o <= 1'b1;
                            instValid <= `InstValid;                            
                        end
                        default:begin
                            
                        end
                    endcase //special_inst2 endcase
                end
                `EXE_J:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_J_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b0;
                    link_addr_o <= `ZEROWORD;
                    branch_target_addr_o <= {pc4[31:28], inst_i[25:0], 2'b00};
                    branch_flag_o <= `BRANCH;
                    next_inst_delayslot_o <= `InDelaySlot;
                    instValid <= `InstValid;                    
                end
                `EXE_JAL:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_JAL_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b0;
                    link_addr_o <= pc8;
                    branch_target_addr_o <= {pc4[31:28], inst_i[25:0], 2'b00};
                    branch_flag_o <= `BRANCH;
                    next_inst_delayslot_o <= `InDelaySlot;
                    instValid <= `InstValid;                     
                end
                `EXE_BEQ:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_BEQ_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b1;
                    if(reg1_o == reg2_o) begin
                        branch_target_addr_o <= pc4 + imm_sll2_signext;
                        branch_flag_o <= `BRANCH;
                        next_inst_delayslot_o <= `InDelaySlot;
                    end
                    link_addr_o <= `ZEROWORD;
                    instValid <= `InstValid;                    
                end
                `EXE_BGTZ:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_BGTZ_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    if((reg1_o[31] == 1'b0) && (reg1_o != `ZEROWORD)) begin
                        branch_target_addr_o <= pc4 + imm_sll2_signext;
                        branch_flag_o <= `BRANCH;
                        next_inst_delayslot_o <= `InDelaySlot;
                    end
                    link_addr_o <= `ZEROWORD;
                    instValid <= `InstValid;                     
                end
                `EXE_BLEZ:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_BLEZ_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    if((reg1_o[31] == 1'b1) || (reg1_o == `ZEROWORD)) begin
                        branch_target_addr_o <= pc4 + imm_sll2_signext;
                        branch_flag_o <= `BRANCH;
                        next_inst_delayslot_o <= `InDelaySlot;
                    end
                    link_addr_o <= `ZEROWORD;
                    instValid <= `InstValid;                       
                end
                `EXE_BNE:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_BNE_OP;
                    alusel_o <= `EXE_RES_JUMP_BRANCH;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b1;
                    if(reg1_o != reg2_o) begin
                        branch_target_addr_o <= pc4 + imm_sll2_signext;
                        branch_flag_o <= `BRANCH;
                        next_inst_delayslot_o <= `InDelaySlot;
                    end
                    link_addr_o <= `ZEROWORD;
                    instValid <= `InstValid;                      
                end
                `EXE_REGIMM_INST:begin
                    case(rt)
                    `EXE_BGEZ:begin
                        wreg_o <= `UNWRITEABLE;
                        aluop_o <= `EXE_BGEZ_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        en_reg_read1_o <= 1'b1;
                        en_reg_read2_o <= 1'b0;
                        if(reg1_o[31] == 1'b0) begin
                            branch_target_addr_o <= pc4 + imm_sll2_signext;
                            branch_flag_o <= `BRANCH;
                            next_inst_delayslot_o <= `InDelaySlot;
                        end
                        link_addr_o <= `ZEROWORD;
                        instValid <= `InstValid;                          
                    end
                    `EXE_BGEZAL:begin
                        wreg_o <= `WRITEABLE;
                        aluop_o <= `EXE_BGEZAL_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        en_reg_read1_o <= 1'b1;
                        en_reg_read2_o <= 1'b0;
                        if(reg1_o[31] == 1'b0) begin
                            branch_target_addr_o <= pc4 + imm_sll2_signext;
                            branch_flag_o <= `BRANCH;
                            next_inst_delayslot_o <= `InDelaySlot;
                        end
                        link_addr_o <= pc8;
                        instValid <= `InstValid;  
                        wd_o <= 5'b11111;                      
                    end
                    `EXE_BLTZ:begin
                        wreg_o <= `UNWRITEABLE;
                        aluop_o <= `EXE_BGEZAL_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        en_reg_read1_o <= 1'b1;
                        en_reg_read2_o <= 1'b0;
                        if(reg1_o[31] == 1'b1) begin
                            branch_target_addr_o <= pc4 + imm_sll2_signext;
                            branch_flag_o <= `BRANCH;
                            next_inst_delayslot_o <= `InDelaySlot;
                        end
                        link_addr_o <= `ZEROWORD;
                        instValid <= `InstValid;                         
                    end
                    `EXE_BLTZAL:begin
                        wreg_o <= `WRITEABLE;
                        aluop_o <= `EXE_BGEZAL_OP;
                        alusel_o <= `EXE_RES_JUMP_BRANCH;
                        en_reg_read1_o <= 1'b1;
                        en_reg_read2_o <= 1'b0;
                        if(reg1_o[31] == 1'b1) begin
                            branch_target_addr_o <= pc4 + imm_sll2_signext;
                            branch_flag_o <= `BRANCH;
                            next_inst_delayslot_o <= `InDelaySlot;
                        end
                        link_addr_o <= pc8;
                        instValid <= `InstValid;  
                        wd_o <= 5'b11111;                          
                    end
                    endcase
                end
                `EXE_LB:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_LB_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                `EXE_LBU:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_LBU_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;                    
                end
                `EXE_LH:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_LH_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;                    
                end
                `EXE_LHU:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_LHU_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                `EXE_LW:begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_LW_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;                    
                end
                `EXE_LWL:begin
                    //todo
                end
                `EXE_LWR:begin
                    //todo
                end
                `EXE_SB:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_SB_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b1;
                    instValid <= `InstValid;                    
                end
                `EXE_SH:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_SH_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b1;
                    instValid <= `InstValid;                    
                end
                `EXE_SW:begin
                    wreg_o <= `UNWRITEABLE;
                    aluop_o <= `EXE_SW_OP;
                    alusel_o <= `EXE_RES_LOAD_STORE;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b1;
                    instValid <= `InstValid;                     
                end
                `EXE_SWL:begin
                    //todo
                end
                `EXE_SWR:begin
                    //todo
                end
                default: begin
                end
             endcase //case op
            if(inst_i[31:21] == 11'b00000000000) begin
                if(funcode == `EXE_SLL) begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_SLL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b1;
                    imm[4:0] <= inst_i[10:6];
                    wd_o <= inst_i[15:11];
                    instValid <= `InstValid;

                end else if(funcode == `EXE_SRL) begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_SRL_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b1;
                    imm[4:0] <= inst_i[10:6];
                    wd_o <= inst_i[15:11];
                    instValid <= `InstValid;
                end else if(funcode == `EXE_SRA) begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_SRA_OP;
                    alusel_o <= `EXE_RES_SHIFT;
                    en_reg_read1_o <= 1'b0;
                    en_reg_read2_o <= 1'b1;
                    imm[4:0] <= inst_i[10:6];
                    wd_o <= inst_i[15:11];
                    instValid <= `InstValid;
                end

            end
        end
    end

    always @(*) begin
        if(rst == `RESETABLE) begin
            reg1_o <= `ZEROWORD;
        //执行阶段数据前推
        end else if(en_reg_read1_o == 1'b1 && ex_wreg_i == 1'b1 && ex_wd_i == reg_addr1_o) begin
            reg1_o <= ex_wdata_i;
        //访存阶段数据前推
        end else if(en_reg_read1_o == 1'b1 && mem_wreg_i == 1'b1 && mem_wd_i == reg_addr1_o) begin
            reg1_o <= mem_wdata_i;
        end else if(en_reg_read1_o == 1'b1) begin
            reg1_o <= reg_data1_i;
        end else if(en_reg_read1_o == 1'b0) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZEROWORD;
        end
    end

    always @(*) begin
        if(rst == `RESETABLE) begin
            reg2_o <= `ZEROWORD;
        //执行阶段数据前推
        end else if(en_reg_read2_o == 1'b1 && ex_wreg_i == 1'b1 && ex_wd_i == reg_addr2_o) begin
            reg2_o <= ex_wdata_i;
        //访存阶段数据前推
        end else if(en_reg_read2_o == 1'b1 && mem_wreg_i == 1'b1 && mem_wd_i == reg_addr2_o) begin
            reg2_o <= mem_wdata_i;
        end else if(en_reg_read2_o == 1'b1) begin
            reg2_o <= reg_data2_i;
        end else if(en_reg_read2_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZEROWORD;
        end
    end
    
    always @(*) begin
        if(rst == `RESETABLE) begin
            is_in_delayslot_o <= `NotInDelaySlot;
        end else begin
            is_in_delayslot_o <= is_in_delayslot_i;
        end
    end

endmodule