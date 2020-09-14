`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: if_id
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

module if_id(
    input clk,
    input rst,

    input wire[`InstAddrBus] if_pc,
    input wire[`InstAddr]    if_inst,

    output reg[`InstAddrBus] id_pc,
    output reg[`InstAddr]    id_inst

);

    always @ (posedge clk) begin
        if(rst == `RESETABLE) begin
            id_pc   <= `ZEROWORD;
            id_inst <= `ZEROWORD;
        end else begin
            id_pc   <= if_pc;
            id_inst <= if_inst;
        end
    end

endmodule