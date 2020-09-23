`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: mips
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

module mips(
    input clk,
    input rst,

    input wire[`InstBus] rom_data_i,
    output wire[`InstAddrBus] rom_addr_o,
    output wire rom_ce_o,

    input wire[`DataBus] ram_data_i,
    output wire[`DataAddrBus] ram_addr_o,
    output wire ram_we_o,
    output wire [3:0] ram_sel_o,
    output wire[`DataBus] ram_data_o,
    output wire ram_ce_o

);

//if_id <-> id

    wire[`InstAddrBus] pc;
    wire[`InstAddrBus] id_pc_i;
    wire[`InstBus] id_inst_i;

//id <-> id_ex
    wire[`AluOpBus] id_aluop_o;
    wire[`AluSelBus] id_alusel_o;
    wire[`RegBus] id_reg1_o;
    wire[`RegBus] id_reg2_o;
    wire id_wreg_o;
    wire[`RegAddrBus] id_wd_o;
    wire id_is_in_delayslot_o;
    wire[`RegBus] id_link_addr_o;
    wire id_next_inst_in_delayslot_o;
    wire[`RegBus] id_branch_target_o;
    wire id_branch_flag_o;
    wire[`RegBus] id_inst_o;

//id_ex <-> ex
    wire[`AluOpBus] ex_aluop_i;
    wire[`AluSelBus] ex_alusel_i;
    wire[`RegBus] ex_reg1_i;
    wire[`RegBus] ex_reg2_i;
    wire ex_wreg_i;
    wire[`RegAddrBus] ex_wd_i;
    wire ex_is_in_delayslot_o;
    wire ex_link_addr_o;
    wire is_in_delayslot_o;
    wire[`RegBus]ex_inst_i;

//ex <-> ex_mem

    wire ex_wreg_o;
    wire[`RegAddrBus] ex_wd_o;
    wire[`RegBus] ex_wdata_o;

    wire ex_enhilo_o;
    wire[`RegBus] ex_hi_o;
    wire[`RegBus] ex_lo_o;
    wire[`AluOpBus] ex_aluop_o;
    wire[`RegBus] ex_mem_addr_o;
    wire[`RegBus] ex_reg2_o;

//ex_mem <-> mem

    wire mem_wreg_i;
    wire[`RegAddrBus] mem_wd_i;
    wire[`RegBus] mem_wdata_i;

    wire[`AluOpBus] mem_aluop_i;
    wire[`RegBus] mem_mem_addr_i;
    wire[`RegBus] mem_reg2_i;

    wire[`RegBus]mem_hi_i;
    wire[`RegBus]mem_lo_i;
    wire mem_enhilo_i;

//mem <-> mem_wb

    wire mem_wreg_o;
    wire[`RegAddrBus] mem_wd_o;
    wire[`RegBus] mem_wdata_o;

    wire[`RegBus]mem_hi_o;
    wire[`RegBus]mem_lo_o;
    wire mem_enhilo_o;



//mem_wb <-> hilo

    wire wb_wreg_i;
    wire[`RegAddrBus] wb_wd_i;
    wire[`RegBus] wb_wdata_i;

    wire[`RegBus]wb_hi_i;
    wire[`RegBus]wb_lo_i;
    wire wb_enhilo_i;

    wire[`RegBus]hilo_hi_o;
    wire[`RegBus]hilo_lo_o;

//id <-> regfile
    wire reg1_read;
    wire reg2_read;
    wire[`RegBus] reg1_data;
    wire[`RegBus] reg2_data;
    wire[`RegAddrBus] reg1_addr;
    wire[`RegAddrBus] reg2_addr;

    pc pc0(
        .clk(clk),
        .rst(rst),
        .branch_flag_i(id_branch_flag_o),
        .branch_target_addr_i(id_branch_target_o),

        .pc(pc),
        .ce(rom_ce_o)

    );

    assign rom_addr_o = pc;

    if_id if_id0(
        .clk(clk),
        .rst(rst),
        .if_pc(pc),
        .if_inst(rom_data_i),
        .id_pc(id_pc_i),
        .id_inst(id_inst_i)

    );

    id id0(
        .rst(rst),
        .clk(clk),
        .pc_i(id_pc_i),
        .inst_i(id_inst_i),
        .reg_data1_i(reg1_data),
        .reg_data2_i(reg2_data),
        .en_reg_read1_o(reg1_read),
        .reg_addr1_o(reg1_addr),
        .reg_addr2_o(reg2_addr),
        .en_reg_read2_o(reg2_read),
        
        .aluop_o(id_aluop_o),
        .alusel_o(id_alusel_o),
        .reg1_o(id_reg1_o),
        .reg2_o(id_reg2_o),
        .wd_o(id_wd_o),
        .wreg_o(id_wreg_o),

        .ex_wreg_i(ex_wreg_o),
        .ex_wdata_i(ex_wdata_o),
        .ex_wd_i(ex_wd_o),
        .mem_wreg_i(mem_wreg_o),
        .mem_wdata_i(mem_wdata_o),
        .mem_wd_i(mem_wd_o),

        .is_in_delayslot_i(is_in_delayslot_o),
        .branch_flag_o(id_branch_flag_o),
        .branch_target_addr_o(id_branch_target_o),
        .link_addr_o(id_link_addr_o),
        .is_in_delayslot_o(id_is_in_delayslot_o),
        .next_inst_delayslot_o(id_next_inst_in_delayslot_o),
        
        .inst_o(id_inst_o)


    );

    regfile regfile0(
        .clk(clk),
        .rst(rst),
        .we(wb_wreg_i),
        .waddr(wb_wd_i),
        .wdata(wb_wdata_i),
        .re1(reg1_read),
        .raddr1(reg1_addr),
        .rdata1(reg1_data),
        .re2(reg2_read),
        .raddr2(reg2_addr),
        .rdata2(reg2_data)

    );

    id_ex id_ex0(
        .clk(clk),
        .rst(rst),
        .id_aluop(id_aluop_o),
        .id_alusel(id_alusel_o),
        .id_reg1(id_reg1_o),
        .id_reg2(id_reg2_o),
        .id_wd(id_wd_o),
        .id_wreg(id_wreg_o),
        .id_link_addr(id_link_addr_o),
        .id_is_in_delayslot(id_is_in_delayslot_o),
        .next_inst_in_delayslot_i(id_next_inst_in_delayslot_o),

        .ex_aluop(ex_aluop_i),
        .ex_alusel(ex_alusel_i),
        .ex_reg1(ex_reg1_i),
        .ex_reg2(ex_reg2_i),
        .ex_wd(ex_wd_i),
        .ex_wreg(ex_wreg_i),
        .ex_is_in_delayslot(ex_is_in_delayslot_o),
        .ex_link_addr(ex_link_addr_o),
        .is_in_delayslot_o(is_in_delayslot_o),

        .id_inst(id_inst_o),
        .ex_inst(ex_inst_i)

    );

    ex ex0(
        .rst(rst),
        .aluop_i(ex_aluop_i),
        .alusel_i(ex_alusel_i),
        .reg1_i(ex_reg1_i),
        .reg2_i(ex_reg2_i),
        .wd_i(ex_wd_i),
        .wreg_i(ex_wreg_i),
        .wd_o(ex_wd_o),
        .wreg_o(ex_wreg_o),
        .wdata_o(ex_wdata_o),
        .is_in_delayslot_i(ex_is_in_delayslot_o),
        .link_addr_i(ex_link_addr_o),

        .hi_i(hilo_hi_o),
        .lo_i(hilo_lo_o),

        .wb_hi_i(wb_hi_i),
        .wb_lo_i(wb_lo_i),
        .wb_enhilo_i(wb_enhilo_i),
        .mem_hi_i(mem_hi_o),
        .mem_lo_i(mem_lo_o),
        .mem_enhilo_i(mem_enhilo_o),

        .hi_o(ex_hi_o),
        .lo_o(ex_lo_o),
        .enhilo_o(ex_enhilo_o),

        .inst_i(ex_inst_i),
        .aluop_o(ex_aluop_o),
        .mem_addr_o(ex_mem_addr_o),
        .reg2_o(ex_reg2_o)
        
    );

    ex_mem ex_mem0(
        .clk(clk),
        .rst(rst),
        .ex_wd(ex_wd_o),
        .ex_wreg(ex_wreg_o),
        .ex_wdata(ex_wdata_o),
        .mem_wd(mem_wd_i),
        .mem_wreg(mem_wreg_i),
        .mem_wdata(mem_wdata_i),

        .ex_enhilo(ex_enhilo_o),
        .ex_hi(ex_hi_o),
        .ex_lo(ex_lo_o),
        .mem_enhilo(mem_enhilo_i),
        .mem_hi(mem_hi_i),
        .mem_lo(mem_lo_i),

        .ex_aluop(ex_aluop_o),
        .ex_mem_addr(ex_mem_addr_o),
        .ex_reg2(ex_reg2_o),
        .mem_aluop(mem_aluop_i),
        .mem_mem_addr(mem_mem_addr_i),
        .mem_reg2(mem_reg2_i)
    );

    mem mem0(
        .rst(rst),
        .clk(clk),

        .wd_i(mem_wd_i),
        .wreg_i(mem_wreg_i),
        .wdata_i(mem_wdata_i),

        .hi_i(mem_hi_i),
        .lo_i(mem_lo_i),
        .enhilo_i(mem_enhilo_i),

        .wd_o(mem_wd_o),
        .wreg_o(mem_wreg_o),
        .wdata_o(mem_wdata_o),

        .hi_o(mem_hi_o),
        .lo_o(mem_lo_o),
        .enhilo_o(mem_enhilo_o),


        .aluop_i(mem_aluop_i),
        .mem_addr_i(mem_mem_addr_i),
        .reg2_i(mem_reg2_i),
        .mem_data_i(ram_data_i), //data from dataMem
        .mem_addr_o(ram_addr_o),
        .mem_we_o(ram_we_o),
        .mem_sel_o(ram_sel_o),
        .mem_data_o(ram_data_o),
        .mem_ce_o(ram_ce_o)
    );

    mem_wb mem_wb0(
        .clk(clk),
        .rst(rst),
        .mem_wd(mem_wd_o),
        .mem_wreg(mem_wreg_o),
        .mem_wdata(mem_wdata_o),
        .wb_wd(wb_wd_i),
        .wb_wreg(wb_wreg_i),
        .wb_wdata(wb_wdata_i),

        .mem_hi(mem_hi_o),
        .mem_lo(mem_lo_o),
        .mem_enhilo(mem_enhilo_o),
        .wb_hi(wb_hi_i),
        .wb_lo(wb_lo_i),
        .wb_enhilo(wb_enhilo_i)
    );

    hilo hilo0(
        .clk(clk),
        .rst(rst),
        .we(wb_enhilo_i),
        .hi_i(wb_hi_i),
        .lo_i(wb_lo_i),
        .hi_o(hilo_hi_o),
        .lo_o(hilo_lo_o)
    );

endmodule