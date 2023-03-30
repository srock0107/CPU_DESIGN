//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Status Register

`timescale 1 ns /1 ns

module StatusRegister (Cin, Zin, SRload, clk, Cset, Creset, Cout, Zout);
input Cin, Zin, Cset, Creset;
input SRload, clk;
output Cout, Zout;
reg Cout, Zout;
    always @(negedge clk) // 时钟下降沿触发 
		if (SRload == 1) begin // 输出有效时，执行语句
			Cout = Cin;
			Zout = Zin;
		end else if (Cset)// 置一
			Cout = 1;
		else if (Creset) // 置0
			Cout = 0;
endmodule
