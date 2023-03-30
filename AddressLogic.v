//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Address Logic

`timescale 1 ns /1 ns

module AddressLogic (
	PCside, Rside, Iside, ALout, ResetPC, PCplusI, PCplus1, RplusI, Rplus0
);
input [15:0] PCside, Rside;
input [7:0] Iside;
input ResetPC, PCplusI, PCplus1, RplusI, Rplus0;
output [15:0] ALout;
reg [15:0] ALout;		//此处方式为直接将输出端口设置成reg型信号，直接在always中赋值，同理于ProgramCounter中的方式
							//另一种方式是单独设置内部变量，在always中将输出信号赋给ALout_reg，让后通过assign将ALout和ALout_reg连接起来

	always @(PCside or Rside or Iside or ResetPC or PCplusI or PCplus1 or RplusI or Rplus0)
		case ({ResetPC, PCplusI, PCplus1, RplusI, Rplus0})
		//	5'b10000: //add your code
		//	5'b01000: //add your code
		//	5'b00100: //add your code
		//	5'b00010: //add your code		//Complement to 16 bits
		//	5'b00001: //add your code
			default: ALout = PCside;
		endcase

endmodule
