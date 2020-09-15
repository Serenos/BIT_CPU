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
    input rst;
    input clk;

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
    output reg                  wreg_o

);
    wire[5:0] op = inst_i[31:26];
    wire[5:0] funcode = inst_i[5:0];
    wire[4:0] sa = inst_i[10:6];
    wire[4:0] rt = inst_i[20:16];

    reg[`RegBus] imm;
    reg instValid;

    always @(*) begin
        if(rst == `RESTABLE) begin
            aluop_o  <= `EXE_NOP_OP;
            alusel_o <= `EXE_RES_NOP;
            en_reg_read1_o <= 1'b0;
            en_reg_read2_o <= 1'b0;
            reg_addr1_o <= `NOPRegAddr;
            reg_addr2_o <= `NOPRegAddr;
            imm <= 32'h0;
            instValid <= `InstValid;
        end else begin
            

             case(op)
                `EXE_ORI: begin
                    wreg_o <= `WRITEABLE;
                    aluop_o <= `EXE_OR_OP;
                    alusel_o <= `EXE_RES_LOGIC;
                    en_reg_read1_o <= 1'b1;
                    en_reg_read2_o <= 1'b0;
                    imm <= (16'h0, inst_i[15:0]);
                    wd_o <= inst_i[20:16];
                    instValid <= `InstValid;
                end
                default: begin
                end
             endcase 
        end
    end

    always @(*) begin
        if(rst == `RESETABLE) begin
            reg1_o <= `ZEROWORD;
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
        end else if(en_reg_read2_o == 1'b1) begin
            reg2_o <= reg_data1_i;
        end else if(en_reg_read2_o == 1'b0) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZEROWORD;
        end
    end
    
endmodule