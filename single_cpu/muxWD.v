`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: controlUnit
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


module muxWD(

    input wdControl,

    input [`DATALENGTH] readData,
    input [`DATALENGTH] aluOut,

    output [`DATALENGTH] wdData

);
    assign wdData = wdControl ? readData : aluOut;

endmodule