//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//SAYEH

`timescale 1 ns /1 ns

module cpu (
	clk,
	ReadMem, WriteMem, ReadIO, WriteIO,
	Databus,
	IO_datain,
	Addressbus,
	aluout,
	ExternalReset, MemDataready
);
input clk;
output ReadMem, WriteMem, ReadIO, WriteIO;
input  [15: 0] Databus,IO_datain;
output [15: 0] Addressbus,aluout;
input ExternalReset, MemDataready;

//----------------------------------------------------------------------
wire[15:0] Instruction;
wire
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC,
	B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,sel_aluout_rfin,sel_rfin,
	RFLwrite, RFHwrite, 
	IRload, SRload,
	IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus,
	Cset, Creset, 
	Cflag,Zflag;  

	DataPath dp (
		.clk                          (clk),
		.Databus                      (Databus),
		.Addressbus                   (Addressbus),
		.ResetPC                      (ResetPC),
		.PCplusI                      (PCplusI),
		.PCplus1                      (PCplus1),
		.RplusI                       (RplusI),
		.Rplus0                       (Rplus0),
		.Rs_on_AddressUnitRSide       (Rs_on_AddressUnitRSide),
		.Rd_on_AddressUnitRSide       (Rd_on_AddressUnitRSide),
		.EnablePC                     (EnablePC),
		.B15to0                       (B15to0),
		.AandB                        (AandB),
		.AorB                         (AorB),
		.notB                         (notB),
		.shlB                         (shlB),
		.shrB                         (shrB),
		.AaddB                        (AaddB),
		.AsubB                        (AsubB),
		.AmulB                        (AmulB),
		.AcmpB                        (AcmpB),
		.aluout                       (aluout),
		.sel_aluout_rfin              (sel_aluout_rfin),
		.sel_rfin                     (sel_rfin),
		.RFLwrite                     (RFLwrite),
		.RFHwrite                     (RFHwrite),
		.IRload                       (IRload),
		.SRload                       (SRload),
		.IR_on_LOpndBus               (IR_on_LOpndBus),
		.IR_on_HOpndBus               (IR_on_HOpndBus),
		.RFright_on_OpndBus           (RFright_on_OpndBus),
		.Cset                         (Cset),
		.Creset                       (Creset),
		.Instruction                  (Instruction),
		.Cout                         (Cflag),
		.Zout                         (Zflag),
		.IO_datain                    (IO_datain)
	);

	control ctrl (
		.ExternalReset                (ExternalReset),
		.clk                          (clk),
		.ResetPC                      (ResetPC),
		.PCplusI                      (PCplusI),
		.PCplus1                      (PCplus1),
		.RplusI                       (RplusI),
		.Rplus0                       (Rplus0),
		.Rs_on_AddressUnitRSide       (Rs_on_AddressUnitRSide),
		.Rd_on_AddressUnitRSide       (Rd_on_AddressUnitRSide),
		.EnablePC                     (EnablePC),
		.B15to0                       (B15to0),
		.AandB                        (AandB),
		.AorB                         (AorB),
		.notB                         (notB),
		.shlB                         (shlB),
		.shrB                         (shrB),
		.AaddB                        (AaddB),
		.AsubB                        (AsubB),
		.AmulB                        (AmulB),
		.AcmpB                        (AcmpB),
		.sel_aluout_rfin              (sel_aluout_rfin),
		.sel_rfin                     (sel_rfin),
		.RFLwrite                     (RFLwrite),
		.RFHwrite                     (RFHwrite),
		.IRload                       (IRload),
		.SRload                       (SRload),
		.IR_on_LOpndBus               (IR_on_LOpndBus),
		.IR_on_HOpndBus               (IR_on_HOpndBus),
		.RFright_on_OpndBus           (RFright_on_OpndBus),
		.ReadMem                      (ReadMem),
		.WriteMem                     (WriteMem),
		.ReadIO                       (ReadIO),
		.WriteIO                      (WriteIO),
		.Cset                         (Cset),
		.Creset                       (Creset),
		.Instruction                  (Instruction),
		.Cflag                        (Cflag),
		.Zflag                        (Zflag),
		.memDataReady                 (MemDataready)

	);

endmodule
