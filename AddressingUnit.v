//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Addressing Unit

`timescale 1 ns /1 ns

module AddressingUnit (
input [15:0] Rside,
input [7:0] Iside,
output [15:0] Address,
input clk,ResetPC, PCplusI, PCplus1, RplusI, Rplus0, PCenable
);
wire [15:0] PCout;

ProgramCounter PC 
(
.in		(Address),
.enable	(PCenable),
.clk		(clk), 
.out		(PCout)
);

AddressLogic AL 
(
.PCside	(PCout),
.Rside	(Rside), 
.Iside	(Iside), 
.ALout	(Address), 
.ResetPC	(ResetPC),
.PCplusI	(PCplusI),
.PCplus1	(PCplus1),
.RplusI	(RplusI),
.Rplus0	(Rplus0)
);
endmodule

