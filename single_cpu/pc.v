`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: Lixiang
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pc(
    input clk,
    input rst,
    input [`PCSIZE] PC4,

    //for beq
    input [`DATALENGTH]signImm,
    input equal, 
    input branch,
    //for jump
    input jump,
    input [`INSTR_INDEX] instrIndex,

    output reg[`PCSIZE] PC
    
);  

    wire [`PCSIZE] PC_;

    assign PC_ = (rst == `RESETABLE)?`ZEROWORD
                : (equal==1'b1 && branch==1'b1) ? (PC4 + {signImm[29:0],2'b00}) //pc <= pc+4+(signExt)imm<<2
                : (jump == 1'b1) ? {PC4[31:28], instrIndex, 2'b00} //pc <= (pc+4)[31:28] || instrIndex || 2'b00
                :PC4;

    always @(posedge clk) begin
        if(rst == 1'b1) begin
            PC <= `ZEROWORD;
        end
        else begin
            PC <= PC_;
        end
    end

endmodule