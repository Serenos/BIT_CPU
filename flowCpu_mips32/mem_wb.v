`timescale 1ns / 1ps
`include "defines.vh"//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: mem_wb
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
module mem_wb(
    input clk,
    input rst,
    input wire[`RegAddrBus] mem_wd,
    input wire mem_wreg,
    input wire[`RegBus] mem_wdata,

    input wire[`RegBus] mem_hi,
    input wire[`RegBus] mem_lo,
    input wire mem_enhilo,

    output reg[`RegAddrBus] wb_wd,
    output reg wb_wreg,
    output reg[`RegBus] wb_wdata,

    output reg[`RegBus] wb_hi,
    output reg[`RegBus] wb_lo,
    output reg wb_enhilo
);
    always @(posedge clk) begin
        if(rst == `RESETABLE) begin
            wb_wd <= `NOPRegAddr;
            wb_wreg <= `UNWRITEABLE;
            wb_wdata <= `ZEROWORD;
            wb_hi <= `ZEROWORD;
            wb_lo <= `ZEROWORD;
            wb_enhilo <= `UNWRITEABLE;
        end else begin
            wb_wd <= mem_wd;
            wb_wreg <= mem_wreg;
            wb_wdata <= mem_wdata;
            wb_hi <= mem_hi;
            wb_lo <= mem_lo;
            wb_enhilo <= mem_enhilo;
        end
    end
endmodule