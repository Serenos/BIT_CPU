`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: decode
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

module decode(
    input [`INSTRSIZE] insData,

    output [`R_SIZE] rs,
    output [`R_SIZE] rt,
    output [`R_SIZE] rd,
    output [`IMI_SIZE] im,

    output [`OP_SIZE] opcode,
    output [`OP_SIZE] funcode,
    
    output [`INSTRSIZE] instrIndex

);

    assign rs = insData[25:21];
    assign rt = insData[20:16];
    assign rd = insData[15:11];
    assign im = insData[15:0];
    assign opcode = insData[31:26];
    assign funcode = insData[5:0];
    assign instrIndex = insData[25:0];

endmodule