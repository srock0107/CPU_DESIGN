//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Register File

`timescale 1 ns /1 ns

module RegisterFile (
	input [15:0] in,
	input clk, RFLwrite, RFHwrite,
	//左右地址分别控制左右读取端口。使能写入时，左地址是写入地址，右地址则没有这个功能。
	input [1:0] Laddr, Raddr,
	output [15:0] Lout, Rout
);

reg [7:0] MemoryFileH [0:3];//rf高八位
reg [7:0] MemoryFileL [0:3];//rf低八位

//读取
assign Lout = {MemoryFileH [Laddr], MemoryFileL[Laddr]};
assign Rout = {MemoryFileH [Raddr], MemoryFileL[Raddr]};

//写入和保持
always @(negedge clk) begin
	case({RFHwrite,RFLwrite})
		2'b00: begin //keep
			MemoryFileH[Laddr] <= MemoryFileH[Laddr];
			MemoryFileL[Laddr] <= MemoryFileL[Laddr];
		end
		2'b01: begin 
			//add your code
		end
		2'b10: begin 
			//add your code
		end
		2'b11: begin 
			//add your code
		end
	endcase
end

endmodule


  