`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: signExt
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

module signExt(
    input [`EXTENDSIGNAL_SIZE] signExtSignal,
    input [`IMI_SIZE] im,

    output [`DATALENGTH] signImm
);

    assign signImm = (signExtSignal == 2'b01) ? {{16{im[15]}},im} :
                     (signExtSignal == 2'b00) ? {16'h0000,im} : 
                     (signExtSignal == 2'b10) ? {im,16'h0000} :
                     `ZEROWORD;

endmodule