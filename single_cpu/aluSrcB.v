`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: aluSrcB
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

module aluSrcB(

    input aluSrc,

    input [`DATALENGTH] writeData,
    input [`DATALENGTH] signImm,

    output [`DATALENGTH]srcB
);

    assign srcB = (aluSrc == 1'b0) ? writeData : signImm;

endmodule