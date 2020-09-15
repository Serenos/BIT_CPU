//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: id_ex
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

module id_ex(
    input clk,
    input rst,

    input wire[`AluOpBus] id_aluop,
    input wire[`AluSelBus] id_alusel,
    input wire[`RegBus] id_reg1,
    input wire[`RegBus] id_reg2,
    input wire[`RegAddrBus] id_wd,
    input wire id_wreg,

    output wire[`AluOpBus] ex_aluop,
    output wire[`AluSelBus] ex_alusel,
    output wire[`RegBus] ex_reg1,
    output wire[`RegBus] ex_reg2,
    output wire[`RegAddrBus] ex_wd,
    output wire ex_wreg

);
    always @(posedge clk) begin
        if(rst == `RESETABLE) begin
            ex_aluop <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1 <= `ZEROWORD;
            ex_reg2 <= `ZEROWORD;
            ex_wd <= `NOPRegAddr;
            ex_wreg <= `WRITEABLE;
            
        end else begin
            ex_aluop <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1 <= id_reg1;
            ex_reg2 <= id_reg2;
            ex_wd <= id_wd;
            ex_wreg <= id_wreg;
        end

    end

endmodule