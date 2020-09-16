`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: regfile
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

module regfile(
    input clk,
    input rst,

    input wire              we,
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus]     wdata,

    input wire              re1,
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus]    rdata1,

    input wire              re2,
    input wire[`RegAddrBus] raddr2,
    output reg[`RegBus]    rdata2

);
    reg[`RegBus] regs[0:`RegNum-1];

    always @ (posedge clk) begin
        if(rst ==`RESETUNABLE) begin
            if(we == `WRITEABLE && waddr != `InstMemNumLog2'h0) begin
                regs[waddr] <= wdata;
            end
        end
    end

    always @(*) begin
        if(rst == `RESETABLE) begin
            rdata1 <= `ZEROWORD;
        end else if(raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZEROWORD;
        end else if((raddr1 == waddr) && (we == `WRITEABLE) && (re1 == `READENABLE)) begin
            rdata1 <= wdata;
        end else if(re1 == `READENABLE) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZEROWORD;
        end
    end

    always @(*) begin
        if(rst == `RESETABLE) begin
            rdata2 <= `ZEROWORD;
        end else if(raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZEROWORD;
        end else if((raddr2 == waddr) && (we == `WRITEABLE) && (re2 == `READENABLE)) begin
            rdata2 <= wdata;
        end else if(re2 == `READENABLE) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZEROWORD;
        end
    end


endmodule