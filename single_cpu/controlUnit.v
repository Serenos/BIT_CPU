`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2020 01:21:06 PM
// Design Name: 
// Module Name: controlUnit
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

module controlUnit(
    input wire[`OP_SIZE] opcode,
    input wire[`OP_SIZE] funcode,

    output regWrite,
    output memWrite,
    
    output waControl, //signal to choose writing address to the reg (rt or rd)
    output wdControl, //signal to choose the data writing to the reg (aluOut or readData)


    output aluSrc,
    output branch,
    output jump,
    output [`ALUCONTROL_SIZE] aluControl,
    output [`EXTENDSIGNAL_SIZE] signExtSignal
);

    assign regWrite = (opcode == `OP_ALL_ZERO && funcode == `FUNC_ADD)?1'b1:
                    (opcode == `OP_ADDI || opcode == `OP_ADDIU || opcode == `OP_LUI || opcode == `OP_LW) ? 1'b1:1'b0;

    assign waControl = (opcode == `OP_ALL_ZERO && funcode == `FUNC_ADD) ? 1'b1: 1'b0;
    
    assign wdControl = (opcode == `OP_LW) ? 1'b1 : 1'b0;

    assign memWrite = (opcode == `OP_SW) ? 1'b1:1'b0;

    assign aluControl = (opcode == `OP_ALL_ZERO && funcode == `FUNC_ADD) ? `ALU_ADD:
                    (opcode == `OP_ADDI || opcode == `OP_ADDIU || opcode == `OP_LW || opcode == `OP_SW) ? `ALU_ADD 
                    :(opcode == `OP_BEQ) ? `ALU_SUB : `ALU_NONE;
    
    assign aluSrc = (opcode == `OP_ADDIU || opcode == `OP_ADDI || opcode == `OP_LUI || opcode == `OP_LW || opcode == `OP_SW )?1'b1:1'b0;

    assign signExtSignal = (opcode == `OP_ADDIU || opcode == `OP_ADDI || opcode == `OP_LW || opcode == `OP_SW) ? 2'b01 :
                    (opcode == `OP_LUI) ? 2'b10 : 2'b00; 
    
    assign branch = (opcode == `OP_BEQ) ? 1'b1 : 1'b0;
    assign jump   = (opcode == `OP_J)   ? 1'b1 : 1'b0;

endmodule