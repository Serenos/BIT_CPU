`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: Lixiang
// Module Name: regFile
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

module regFile(

    input wire clk,
    input wire rst,

    input wire regWrite,

    input wire[`R_SIZE] RA1,
    input wire[`R_SIZE] RA2,
    input wire[`R_SIZE] WA,
    input wire[`DATALENGTH] WD,

    output wire[`DATALENGTH] RD1,
    output wire[`DATALENGTH] RD2
);

    reg[`DATALENGTH] register[`REGNUM-1:0];

    initial begin
        $readmemh("/home/lixiang/Desktop/vivado_ws/single_cpu/reg.txt", register);
       
    end

    //write
    always @(posedge clk) begin
        if((regWrite == 1'b1)&&(WA != 5'b00000)) begin
            register[WA] <= WD;
        end
    end

    //read
    assign RD1 = (rst == `RESETABLE || RA1 == 5'b00000) ? `ZEROWORD : register[RA1];
    assign RD2 = (rst == `RESETABLE || RA2 == 5'b00000) ? `ZEROWORD : register[RA2];

endmodule
