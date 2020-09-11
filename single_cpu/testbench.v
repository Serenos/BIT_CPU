`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: Lixiang
// Module Name: testbench
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

module testbench();

    reg clk;
    reg rst;
    initial begin
        clk=0;
        rst=1;
        #10
        rst=1;
        #10
        rst=0;
    $display("running...");
    end
    always #10 clk=~clk;

    top_cpu top_cpu0(
        .clk(clk),
        .rst(rst)
    );
endmodule
