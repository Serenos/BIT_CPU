`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: alu
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

module alu(
    input [`ALUCONTROL_SIZE] aluControl,

    input [`DATALENGTH] srcA,
    input [`DATALENGTH] srcB,

    //output ZERO,\
    output equal,
    output [`DATALENGTH]aluOut

);
    assign aluOut = (aluControl == `ALU_ADD) ? (srcA + srcB) 
                :(aluControl == `ALU_SUB) ? (srcA - srcB) 
                :(aluControl == `ALU_NONE) ? srcB : `ZEROWORD;
                
    assign equal = (aluOut == 0) ? 1'b1 : 1'b0;

endmodule