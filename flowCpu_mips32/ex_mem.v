`timescale 1ns / 1ps
`include "defines.vh"//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: ex_mem
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

module ex_mem(
    input clk,
    input rst,

    input wire[`RegAddrBus] ex_wd,
    input wire ex_wreg,
    input wire[`RegBus] ex_wdata,

    input wire ex_enhilo,
    input wire[`RegBus] ex_hi,
    input wire[`RegBus] ex_lo,


    output reg[`RegAddrBus] mem_wd,
    output reg mem_wreg,
    output reg[`RegBus] mem_wdata,

    output reg mem_enhilo,
    output reg[`RegBus] mem_hi,
    output reg[`RegBus] mem_lo,

    input wire[`AluOpBus] ex_aluop,
    input wire[`RegBus] ex_mem_addr,
    input wire[`RegBus] ex_reg2,
    output reg[`AluOpBus] mem_aluop,
    output reg[`RegBus] mem_mem_addr,
    output reg[`RegBus] mem_reg2

);
        always @(posedge clk) begin
        if(rst == `RESETABLE) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `UNWRITEABLE;
            mem_wdata <= `ZEROWORD;
            mem_enhilo <= `UNWRITEABLE;
            mem_hi <= `ZEROWORD;
            mem_lo <= `ZEROWORD;
            mem_aluop <= `EXE_NOP_OP;
            mem_mem_addr <= `ZEROWORD;
            mem_reg2 <= `ZEROWORD;
        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
            mem_enhilo <= ex_enhilo;
            mem_hi <= ex_hi;
            mem_lo <= ex_lo;
            mem_aluop <= ex_aluop;
            mem_mem_addr <= ex_mem_addr;
            mem_reg2 <= ex_reg2;
        end
    end
endmodule