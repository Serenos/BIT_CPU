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
    output wire[`RegBus]    rdata1,

    input wire              re2,
    input wire[`RegAddrBus] raddr2,
    output wire[`RegBus]    rdata2,

);
    reg[`RegBus] regs[0:`RegNum-1];

    always @ (posedge clk) begin
        if(rst ==`RESTUNABLE) begin
            if(we == `WRITEABLE && waddr != `InstMemNumLog2'h0) begin
                regs[waddr] <= wdata;
            end
        end
    end

    always @(*) begin
        if(rst == `RESTABLE) begin
            rdata1 <= `ZEROWORD;
        end else if(raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZEROWORD;
        end else if((raddr1 == waddr) && (we == `WRITEABLE) && (re1 == `ReadEnable)) begin
            radata1 <= wdata;
        end else if(re1 == `ReadEnable) begin
            
        end

        end


    end

endmodule