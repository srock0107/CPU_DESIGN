//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// Data Path 

`timescale 1 ns /1 ns

module DataPath (
	 clk, Databus, Addressbus, 
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
    Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,aluout,sel_aluout_rfin,sel_rfin,
    RFLwrite, RFHwrite,
    IRload, SRload,
	IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
    Cset, Creset, 
    Instruction, Cout,Zout,IO_datain
);
input clk;//时钟
input  [15:0] Databus;//数据总线
input  [15:0] IO_datain;//IO数据输入
output [15:0] Addressbus;//地址总线
output [15:0] aluout;//ALU输出
input
	//PC单元控制
	EnablePC,
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	//指令寄存器控制
	IRload,
	//MUX控制
	sel_rfin, sel_aluout_rfin,
	//寄存器阵列控制
	RFLwrite, RFHwrite,
	//通路切换控制
	Rd_on_AddressUnitRSide, Rs_on_AddressUnitRSide,
	RFright_on_OpndBus,
	IR_on_LOpndBus, IR_on_HOpndBus,
	//ALU控制
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	//状态寄存器控制
	Cset, Creset, SRload;


output [15:0] Instruction;//指令寄存器输出
output Cout,Zout;////状态寄存器输出

wire [15:0] Address, AddressUnitRSideBus;//PC单元输出输入
wire [15:0] Right, Left, OpndBus, ALUout, IRout;//寄存器阵列输出，ALU操作数输入，ALU输出，指令寄存器输出
wire SRCin, SRCout,SRZin,SRZout;//状态寄存器输入输出

wire
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	RFLwrite, RFHwrite,
	IRload, SRload,
	IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset;

wire [1:0] Laddr, Raddr;//寄存器阵列地址输入
wire [15:0] RFin,rfin;//寄存器阵列数据输入

assign aluout=ALUout;

//PC单元
AddressingUnit AU
(
//add your code
);


//ALU
ArithmeticUnit AL
(
//add your code
);

//寄存器阵列
RegisterFile RF(
//add your code
);

//指令寄存器
InstrunctionRegister IR
(
.in      (Databus),
.IRload  (IRload),
.clk     (clk),
.out     (IRout)
);

//状态寄存器
StatusRegister SR
(
.Cin      (SRCin),
.Zin      (SRZin),
.SRload   (SRload),
.clk      (clk),
.Cset     (Cset),
.Creset   (Creset),
.Zout     (SRZout),
.Cout     (SRCout)
);

assign Addressbus = Address;	

assign Zout = SRZout;

assign Cout = SRCout;

assign Instruction = IRout[15:0];

assign Laddr =  IRout[11:10];

assign Raddr =  IRout[09:08];

//通路切换
assign AddressUnitRSideBus = 
		(Rs_on_AddressUnitRSide) ? Right : (Rd_on_AddressUnitRSide) ? Left : 16'bZZZZZZZZZZZZZZZZ;

assign OpndBus[07:0] = IR_on_LOpndBus == 1 ? IRout[7:0] : 8'bZZZZZZZZ;

assign OpndBus[15:8] = IR_on_HOpndBus == 1 ? IRout[7:0] : 8'bZZZZZZZZ;

assign OpndBus = RFright_on_OpndBus == 1 ? Right : 16'bZZZZZZZZZZZZZZZZ;

//MUX	
assign RFin = sel_aluout_rfin ? ALUout : rfin;
	
assign rfin = sel_rfin ? IO_datain : Databus;

endmodule