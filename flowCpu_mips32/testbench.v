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

module testbench(
);
    reg clk;
    reg rst;

    initial begin
        clk = 1'b0;
        #10 clk = ~clk;
    end

    initial begin
        rst = `RESETABLE;
        #200 rst = `RESETUNABLE;
        #1000 $stop
    end

    mips_sopc mips_sopc0(
        .clk(clk),
        .rst(rst)
    );
endmodule