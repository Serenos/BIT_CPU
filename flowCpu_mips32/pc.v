`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: pc
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

module pc(
    input clk,
    input rst,
    input wire branch_flag_i,
    input wire[`RegBus] branch_target_addr_i,


    output reg[`InstAddrBus] pc,
    output reg               ce
    
);  



    always @(posedge clk) begin
        if(rst == 1'b1) begin
            ce <= `ChipDisable;
        end
        else begin
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk) begin
        if(ce == `ChipDisable) begin
            pc <= 32'h00000000;
        end else begin
            if(branch_flag_i == `BRANCH) begin
                pc <= branch_target_addr_i;
            end else begin
                pc <= pc + 4'h4;
            end    
        end
    end

endmodule