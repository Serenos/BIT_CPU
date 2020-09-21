`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: hilo
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

module hilo(
    input clk,
    input rst,

    input wire we,
    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,

    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o
);

    always @(posedge clk) begin
        if(rst == `RESETABLE) begin
            hi_o <= `ZEROWORD;
            lo_o <= `ZEROWORD;
        end else if(we == `WRITEABLE) begin
            hi_o <= hi_i;
            lo_o <= lo_i;
        end
    end
    
endmodule