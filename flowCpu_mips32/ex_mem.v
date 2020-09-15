//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: ex_mem
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

module exe_mem(
    input clk,
    input rst,

    input wire[`RegAddrBus] ex_wd,
    input wire ex_wreg,
    input wire[`RegBus] ex_wdata,

    output reg[`RegAddrBus] mem_wd,
    output reg mem_wreg,
    output reg[`RegBus] mem_wdata,


);
        always @(posedge clk) begin
        if(rst == `RESETABLE) begin
            mem_wd <= `NOPRegAddr;
            mem_wreg <= `UNWRITEABLE;
            mem_wdata <= `ZEROWORD;
        end else begin
            mem_wd <= ex_wd;
            mem_wreg <= ex_wreg;
            mem_wdata <= ex_wdata;
        end
    end
endmodule