//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: mem
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

module mem(
    input rst,
    input clk,

    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,
    input wire[`RegBus] wdata_i,

    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,
    input wire enhilo_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o

    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o,
    output reg enhilo_o
);

    always @(*) begin
        if(rst == `RESETABLE) begin
            wd_o <= `NOPRegAddr;
            wreg_o <= `UNWRITEABLE;
            wdata_o <= `ZEROWORD;

            hi_o <= `ZEROWORD;
            lo_o <= `ZEROWORD;
            enhilo_o <= `UNWRITEABLE;

        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;

            hi_o <= hi_i;
            lo_o <= lo_i;
            enhilo_o <= enhilo_i;

        end
    end
endmodule