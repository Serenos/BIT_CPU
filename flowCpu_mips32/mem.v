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
    output reg[`RegBus] wdata_o,

    output reg[`RegBus] hi_o,
    output reg[`RegBus] lo_o,
    output reg enhilo_o,

    input wire[`AluOpBus] aluop_i,
    input wire[`RegBus] mem_addr_i,
    input wire[`RegBus] reg2_i,
    input wire[`DataBus] mem_data_i,//data from dataMem
    output reg[`DataAddrBus] mem_addr_o,
    output reg mem_we_o, //write or not
    output reg[3:0] mem_sel_o, // choose which byte
    output reg[`DataBus] mem_data_o,
    output reg mem_ce_o

);

    always @(*) begin
        if(rst == `RESETABLE) begin
            wd_o <= `NOPRegAddr;
            wreg_o <= `UNWRITEABLE;
            wdata_o <= `ZEROWORD;

            hi_o <= `ZEROWORD;
            lo_o <= `ZEROWORD;
            enhilo_o <= `UNWRITEABLE;

            mem_addr_o <= `ZEROWORD;
            mem_we_o <= `UNWRITEABLE;
            mem_sel_o <= 4'b0000;
            mem_data_o <= `ZEROWORD;
            mem_ce_o <= `ChipDisable;

        end else begin
            wd_o <= wd_i;
            wreg_o <= wreg_i;
            wdata_o <= wdata_i;

            hi_o <= hi_i;
            lo_o <= lo_i;
            enhilo_o <= enhilo_i;

            mem_addr_o <= `ZEROWORD;
            mem_we_o <= `WRITEABLE;
            mem_sel_o <= 4'b1111;
            mem_data_o <= `ZEROWORD;
            mem_ce_o <= `ChipDisable;

            case(aluop_i)
                `EXE_LB_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `UNWRITEABLE;
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00: begin
                            wdata_o <= {{24{mem_data_i[31]}}, mem_data_i[31:24]};
                            mem_sel_o <= 4'b1000;
                        end
                        2'b01:begin
                             wdata_o <= {{24{mem_data_i[23]}}, mem_data_i[23:16]};
                            mem_sel_o <= 4'b0100;                           
                        end
                        2'b10:begin
                            wdata_o <= {{24{mem_data_i[15]}}, mem_data_i[15:8]};
                            mem_sel_o <= 4'b0010;                            
                        end
                        2'b11:begin
                            wdata_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};
                            mem_sel_o <= 4'b0001;                            
                        end
                        default:begin
                            wdata_o <= `ZEROWORD;
                        end
                    endcase
                end
                `EXE_LBU_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `UNWRITEABLE;
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00: begin
                            wdata_o <= {{24{1'b0}}, mem_data_i[31:24]};
                            mem_sel_o <= 4'b1000;
                        end
                        2'b01:begin
                            wdata_o <= {{24{1'b0}}, mem_data_i[23:16]};
                            mem_sel_o <= 4'b0100;                           
                        end
                        2'b10:begin
                            wdata_o <= {{24{1'b0}}, mem_data_i[15:8]};
                            mem_sel_o <= 4'b0010;                            
                        end
                        2'b11:begin
                            wdata_o <= {{24{1'b0}}, mem_data_i[7:0]};
                            mem_sel_o <= 4'b0001;                            
                        end
                        default:begin
                            wdata_o <= `ZEROWORD;
                        end
                    endcase                    
                end
                `EXE_LH_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `UNWRITEABLE;
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00: begin
                            wdata_o <= {{16{mem_data_i[31]}}, mem_data_i[31:16]};
                            mem_sel_o <= 4'b1100;                        
                        end
                        2'b10:begin
                            wdata_o <= {{16{mem_data_i[15]}}, mem_data_i[15:0]};
                            mem_sel_o <= 4'b0011;                            
                        end
                        default:begin
                            wdata_o <= `ZEROWORD;
                        end
                    endcase                    
                end
                `EXE_LHU_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `UNWRITEABLE;
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00: begin
                            wdata_o <= {{16{1'b0}}, mem_data_i[31:16]};
                            mem_sel_o <= 4'b1100;                       
                        end
                        2'b10:begin
                            wdata_o <= {{16{1'b0}}, mem_data_i[15:0]};
                            mem_sel_o <= 4'b0011;                            
                        end
                        default:begin
                            wdata_o <= `ZEROWORD;
                        end
                    endcase                      
                end
                `EXE_LW_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `UNWRITEABLE;
                    mem_ce_o <= `ChipEnable;
                    wdata_o <= mem_data_i;
                    mem_sel_o <= 4'b1111;                    
                end
                `EXE_SB_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `WRITEABLE;
                    mem_data_o <= {reg2_i[7:0],reg2_i[7:0],reg2_i[7:0],reg2_i[7:0]};
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_o <= 4'b1000;
                        end
                        2'b01:begin
                            mem_sel_o <= 4'b0100;
                        end
                        2'b10:begin
                            mem_sel_o <= 4'b0010;
                        end
                        2'b11:begin
                            mem_sel_o <= 4'b0001;
                        end
                    endcase
                end
                `EXE_SH_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `WRITEABLE;
                    mem_data_o <= {reg2_i[15:0],reg2_i[15:0]};
                    mem_ce_o <= `ChipEnable;
                    case(mem_addr_i[1:0])
                        2'b00:begin
                            mem_sel_o <= 4'b1100;
                        end
                        2'b10:begin
                            mem_sel_o <= 4'b0011;
                        end
                    endcase                    
                end
                `EXE_SW_OP:begin
                    mem_addr_o <= mem_addr_i;
                    mem_we_o <= `WRITEABLE;
                    mem_data_o <= reg2_i;
                    mem_ce_o <= `ChipEnable;
                    mem_sel_o <= 4'b1111;                   
                end
        endcase
        end
    end
endmodule