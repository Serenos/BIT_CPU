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
        rst=1'b1;
        clk = 1'b0;
        #20 rst=1'b1;
        #20 rst=1'b0;
        
        $display("running...");
    end

    always #10 clk=~clk;

    mips_sopc mips_sopc0(
        .clk(clk),
        .rst(rst)
    );
endmodule