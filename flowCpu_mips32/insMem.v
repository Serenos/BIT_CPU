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
       
        input wire ce,
        input wire[`InstAddrBus] addr,
        output reg[`InstBus] inst
        
    );

    reg [`InstBus] inst_mem[0:`InstMemNum-1];
    initial begin
        $readmemh("/home/lixiang/Desktop/BIT_CPU/flowCpu_mips32/test/InstRom7.data", inst_mem);
       
    end
    
    always @(*) begin
        if(ce == `ChipDisable) begin
            inst <= `ZEROWORD;
        end else begin
            inst <= inst_mem[addr>>2];
        end
    end

endmodule
