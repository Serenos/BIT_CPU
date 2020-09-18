`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: BIT
// Engineer: Lixiang
// 
// Create Date: 09/14/2020 01:21:06 PM
// Design Name: 
// Module Name: ex
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

module ex(
    input rst,

    input wire[`AluOpBus] aluop_i,
    input wire[`AluSelBus] alusel_i,
    input wire[`RegBus] reg1_i,
    input wire[`RegBus] reg2_i,
    input wire[`RegAddrBus] wd_i,
    input wire wreg_i,

    output reg[`RegAddrBus] wd_o,
    output reg wreg_o,
    output reg[`RegBus] wdata_o

    input wire[`RegBus] hi_i,
    input wire[`RegBus] lo_i,

    input wire[`RegBus] wb_hi_i,
    input wire[`RegBus] wb_lo_i,
    input wire wb_enhilo_i,
    input wire[`RegBus] mem_hi_i,
    input wire[`RegBus] mem_lo_i,
    input wire mem_enhilo_i,

    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o,
    output reg enhilo_o

);
    reg[`RegBus] logicout;
    reg[`RegBus] shiftres;
    reg[`RegBus] moveres;
    reg[`RegBus] HI;
    reg[`RegBus] LO;

    //logic 
    always @(*) begin
        if(rst == `RESETABLE) begin
            logicout <= `ZEROWORD;
        end else begin
            case(aluop_i)
                `EXE_OR_OP:begin
                    logicout <= reg1_i | reg2_i;
                end
                `EXE_AND_OP:begin
                    logicout <= reg1_i & reg2_i;
                end
                `EXE_NOR_OP:begin
                    logicout <= ~(reg1_i | reg2_i);
                end
                `EXE_XOR_OP:begin
                    logicout <= reg1_i ^ reg2_i;
                end
                default: begin
                    logicout <= `ZEROWORD;
                end
            endcase
        end
    end

    //shift
    always @(*) begin
        if(rst == `RESETABLE) begin
            shiftres <= `ZEROWORD;
        end else begin
            case(aluop_i)
                `EXE_SLL_OP:begin
                    shiftres <= reg2_i << reg1_i[4:0];
                end
                `EXE_SRL_OP:begin
                    shiftres <= ~(reg1_i | reg2_i);
                end
                `EXE_SRA_OP:begin
                    shiftres <= ({32{reg2_i[31]}}<<(6'd32-{1'b0,reg1_i[4:0]})) | reg2_i>>reg1_i[4:0];
                end
                default: begin
                    shiftres <= `ZEROWORD;
                end
            endcase
        end
    end
    
    //get the newest hilo and resolve data realtion
    always @(*) begin
        if(rst == `RESETABLE) begin
            HI <= `ZEROWORD;
            LO <= `ZEROWORD;
        end else if(mem_enhilo_i == `WRTIEABLE) begin
            HI <= mem_hi_i;
            LO <= mem_lo_i;
        end else if(wb_enhilo_i == `WRTIEABLE) begin
            HI <= wb_hi_i;
            LO <= wb_lo_i;
        end else begin
            HI <= hi_i;
            LO <= lo_i;
        end
    end

    //move 
    always @(*) begin
        if(rst == `RESETABLE) begin
            moveres <= `ZEROWORD;
        end else begin
            moveres <= `ZEROWORD;
            case(alu_op_i)
                `EXE_MFHI_OP: begin
                    moveres <= HI;
                end
                `EXE_MFLO_OP: begin
                    moveres <= LO;
                end
                `EXE_MOVZ_OP: begin
                    moveres <= reg1_i;
                end
                `EXE_MOVN_OP: begin
                    moveres <= reg1_i;
                end
                default: begin
                    
                end
            endcase
        end
    end

    always @(*) begin
        wd_o <= wd_i;
        wreg_o <= wreg_i;
        case(alusel_i)
            `EXE_RES_LOGIC:begin
                wdata_o <= logicout;
            end
            `EXE_RES_SHIFT:begin
                wdata_o <= shiftres;
            end
            `EXE_RES_MOVE: begin
                wdata_o <= moveres;
            end
            default:begin
                wdata_o <= logicout;
            end
        
        endcase
    end

    //for MTHI MTLO
    always @(*) begin
        if(rst == `RESETABLE) begin
            enhilo_o <= `UNWRITEABLE;
            hi_o <= `ZEROWORD;
            lo_o <= `ZEROWORD;
        end else if(alu_op_i == `EXE_MTHI_OP) begin
            enhilo_o <= `WRITEABLE;
            hi_o <= reg1_i;
            lo_o <= LO;
        end else if(alu_op_i == `EXE_MTLO_OP) begin
            enhilo <= `WRITEABLE;
            hi_o <= HI;
            lo_o <= reg1_i;
        end else begin
            whilo_o <= `UNWRITEABLE;
            hi_o <= `ZEROWORD;
            lo_o <= `ZEROWORD;
        end
    end

endmodule