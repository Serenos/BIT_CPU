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
);
    reg[`RegBus] logicout;

    always @(*) begin
        if(rst == `RESETABLE) begin
            logicout <= `ZEROWORD;
        end else begin
            case(aliop_i)
                `EXE_OR_OP:begin
                    logicout <= reg1_i | reg2_i;
                end
                default: begin
                    logicout <= `ZEROWORD;
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
            default:begin
                wdata_o <= logicout;
            end
        
        endcase
    end
endmodule