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

module top_cpu(
    input clk,
    input rst
);
    //PC&PC4
    wire [`PCSIZE] PC4;
    wire [`PCSIZE] PC;
    wire equal;
    wire branch;
    wire jump;
    //insMem
    wire [`INSTRSIZE] insData;
    //decode
    wire[`R_SIZE] rs;
    wire[`R_SIZE] rt;
    wire[`R_SIZE] rd;
    wire[`IMI_SIZE] im;
    wire[`OP_SIZE] opcode;
    wire[`OP_SIZE] funcode;
    //controlUnit
    wire regWirte;
    wire memWrite;
    wire waControl;
    wire wdControl;
    wire aluSrc;
    wire [`EXTENDSIGNAL_SIZE] signExtSignal;
    wire [`ALUCONTROL_SIZE] aluControl;
    //regFile
    wire[`DATALENGTH] RD1;
    wire[`DATALENGTH] RD2; 
    wire[`R_SIZE] WA;
    wire[`R_SIZE] WD;
    wire[`DATALENGTH] wdData;
    //signExt
    wire [`DATALENGTH] signImm;
    //aluSrcB
    wire [`DATALENGTH]srcB;
    //alu
    wire[`DATALENGTH] aluOut;

    //dataMem
    wire [`DATALENGTH]readData;



pc pc0(
    .clk(clk),
    .rst(rst),
    .PC4(PC4),
    .PC(PC),
    .signImm(signImm),
    .equal(equal),
    .branch(branch),
    .jump(jump)
);

pcAlu pcAlu0(
    .PC(PC),
    .PC4(PC4)
);

insMem insMem0(
    .clk(clk),
    .rst(rst),
    .insAddr(PC),
    .insData(insData)
);

decode decode0(
    .insData(insData),
    .rs(rs),
    .rd(rd),
    .rt(rt),
    .im(im),
    .opcode(opcode),
    .funcode(funcode)
);



controlUnit controlUnit0(
    .opcode(opcode),
    .funcode(funcode),
    .regWrite(regWrite),
    .memWrite(memWrite),
    .wdControl(wdControl),
    .waControl(waControl),
    .aluSrc(aluSrc),
    .branch(branch),
    .jump(jump),
    .aluControl(aluControl),
    .signExtSignal(signExtSignal)
);

signExt signExt0(
    .im(im),
    .signExtSignal(signExtSignal),
    .signImm(signImm)
);

regFile regFile0(
    .clk(clk),
    .rst(rst),
    .regWrite(regWrite),
    .RA1(rs),
    .RA2(rt),
    .WA(WA),
    .WD(wdData),
    .RD1(RD1),
    .RD2(RD2)
);

aluSrcB aluSrcB0(
    .aluSrc(aluSrc),
    .writeData(RD2),
    .signImm(signImm),
    .srcB(srcB)

);

alu alu0(
    .aluControl(aluControl),
    .srcA(RD1),
    .srcB(srcB),
    .aluOut(aluOut)
);

muxWA muxWA0(
    .waControl(waControl),
    .rt(rt),
    .rd(rd),
    .writingAddress(WA)
);

muxWD muxWD0(
    .wdControl(wdControl),
    .readData(readData),
    .aluOut(aluOut),
    .wdData(wdData)


);

dataMem dataMem0(
    .clk(clk),
    .rst(rst),
    .memWrite(memWrite),
    .addr(aluOut),
    .writeData(RD2),
    .readData(readData)

);

endmodule