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


module insMem(
        input  clk,
        input  rst,
        input [`PCSIZE] insAddr,
        output [`INSTRSIZE] insData
        
    );

    reg [7:0] rom[128:0];
    initial begin
        $readmemb("/home/lixiang/Desktop/vivado_ws/single_cpu/rom.txt", rom);
       
    end
    
    wire [7:0] addr = insAddr[7:0];
    assign insData = {rom[addr],rom[addr+1],rom[addr+2],rom[addr+3]};
    
    initial begin
         $display("iaddr: %d inst: %b", insAddr, insData);
    end

endmodule
