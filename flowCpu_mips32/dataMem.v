`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: dataMem
// Project Name: flowCPU_mips
// Target Devices: 
// Tool Versions: 
// Description: this module is for storing the Inst and InstAddr and pass them on 
// at next clk
// 
// Dependencies: 
// 
// Revision: 0.1
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module dataMem(
    input wire clk,
    input wire ce,
    input wire we,
    input wire[`DataAddrBus] addr,
    input wire[`DataBus] data_i,
    output reg[`DataBus] data_o,
    input wire[3:0] sel
);

    reg[`ByteWidth] data_mem0[0:`DataNum-1];
    reg[`ByteWidth] data_mem1[0:`DataNum-1];
    reg[`ByteWidth] data_mem2[0:`DataNum-1];
    reg[`ByteWidth] data_mem3[0:`DataNum-1];

    //write
    always @(*) begin
        if(ce == `ChipDisable) begin
            data_o <= `ZEROWORD;
        end else if(we == `WRITEABLE) begin
            if(sel[3] == 1'b1) begin
                data_mem3[addr[`DataNumLog-1:2]] <= data_i[31:24];
            end
            if(sel[2] == 1'b1) begin
                data_mem2[addr[`DataNumLog-1:2]] <= data_i[23:16];
            end
            if(sel[1] == 1'b1) begin
                data_mem1[addr[`DataNumLog-1:2]] <= data_i[15:8];
            end
            if(sel[0] == 1'b1) begin
                data_mem0[addr[`DataNumLog-1:2]] <= data_i[7:0];
            end
        end
    end
    //read
    always @(*) begin
        if(ce == `ChipDisable) begin
            data_o <= `ZEROWORD;
        end else if(we == `UNWRITEABLE) begin
            data_o <= {data_mem3[addr[`DataNumLog-1:2]],data_mem2[addr[`DataNumLog-1:2]],
                    data_mem1[addr[`DataNumLog-1:2]],data_mem0[addr[`DataNumLog-1:2]]};
        end else begin
            data_o <= `ZEROWORD;
        end
    end
endmodule