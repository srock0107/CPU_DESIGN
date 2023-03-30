//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Instruction Register

`timescale 1 ns /1 ns

module InstrunctionRegister (in, IRload, clk, out);
input [15:0] in;
input IRload, clk;
output [15:0] out;
reg [15:0] out;

	always @(negedge clk)//时钟下降沿触发
		if (IRload == 1) out <= in;

endmodule
