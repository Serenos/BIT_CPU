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

module mips_sopc(
    input wire clk,
    input wire rst
);
    wire[`InstAddrBus] inst_addr;
    wire[`InstBus] inst;
    wire rom_ce;

    wire ram_ce;
    wire ram_we;
    wire[`DataBus] ram_data_i;
    wire[`DataAddrBus] ram_addr_o;
    wire[`DataBus] ram_data_o;
    wire[3:0] ram_sel;

    mips mips0(
        .clk(clk),
        .rst(rst),
        .rom_data_i(inst),
        .rom_addr_o(inst_addr),
        .rom_ce_o(rom_ce),

        .ram_data_i(ram_data_i),
        .ram_addr_o(ram_addr_o),
        .ram_we_o(ram_we),
        .ram_sel_o(ram_sel),
        .ram_data_o(ram_data_o),
        .ram_ce_o(ram_ce)
        
    );

    insMem insMem0(
        .ce(rom_ce),
        .addr(inst_addr),
        .inst(inst)
    );

    dataMem dataMem0(
        .clk(clk),
        .ce(ram_ce),
        .we(ram_we),
        .addr(ram_addr_o),
        .data_i(ram_data_o),
        .data_o(ram_data_i),
        .sel(ram_sel)
    );

endmodule