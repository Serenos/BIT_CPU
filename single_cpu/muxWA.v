`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: muxWA
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

module muxWA(
    input waControl, //choose the writing address

    input [`R_SIZE] rt,
    input [`R_SIZE] rd,

    output [`R_SIZE] writingAddress
);

    assign writingAddress = (waControl == 1'b0) ? rt:rd;

endmodule