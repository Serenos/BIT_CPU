`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: insMem
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

module dataMem(
    input clk,
    input rst,
    
    input memWrite,
    input [`ADDRLENGTH] addr,
    input [`DATALENGTH] writeData,

    output [`DATALENGTH] readData
);

    reg[`DATALENGTH] dataMemory[0:`DATA_MEM_NUM-1];
    initial begin
        $readmemh("/home/lixiang/Desktop/vivado_ws/single_cpu/dataMem.txt", dataMemory);
       
    end

    always @(posedge clk) begin
        if(rst != `RESETABLE && memWrite == 1'b1) begin
            dataMemory[addr[16:0]] <= writeData;
        end
    end

    assign readData = (rst == `RESETABLE) ? `ZEROWORD : dataMemory[addr[16:0]];


endmodule