///----------------------------------------------------------------------
//--SAYEH(Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
// SayehTest

`timescale 1 ns /1 ns

module cpu_top(clk,ExternalReset,in,out);
input clk, ExternalReset;
input  [7:0] in;
output [7:0] out;
wire  MemDataready,Reset;
wire [15:0]	 MemoryData;
wire [15:0]  Addressbus,aluout;
wire [15:0]  Databus;
wire ReadMem, WriteMem, ReadIO, WriteIO;
reg [7:0] out;

wire [7:0] portadress;
reg clk_5;

reg [15:0] IO_datain;

assign portadress=Databus[7:0];
 

always@(posedge clk_5)
begin
  if(WriteIO==1'b1)
    begin
    case(portadress)        //输出结果
      8'd2:    out<=aluout[7:0];
    default: out<=0;
    endcase
    end
  else
    out<=out;			//不变
end


always@(posedge clk_5)	//当ReadIO为1且portadress为3时，从外部读入数据，否则为0。本次实验暂时无需用到，增加输入端口的目的是为了方便扩展
begin 
  if(ReadIO)
      begin
	    case(portadress)
	      8'd3: IO_datain<={8'd0,in};
	    endcase
      end 
	else IO_datain<=0;
end

PLL U0(					//通过PLL将时钟频率改变
.refclk    (clk),//  50MHZ
.rst       (),   //  
.outclk_0  (clk_5)// 5MHZ
);


RAM U1(
.readMem        (ReadMem),
.address        (Addressbus),
.clk            (clk_5),
.data           (aluout),
.wren           (WriteMem),
.out            (Databus),
.memDataReady   (MemDataready)
);


cpu U2 (
.clk            (~clk_5),
.ReadMem        (ReadMem),
.WriteMem       (WriteMem),
.ReadIO         (ReadIO),
.WriteIO        (WriteIO),
.Databus        (Databus),
.IO_datain      (IO_datain),
.Addressbus     (Addressbus),
.aluout         (aluout),
.ExternalReset  (Reset),
.MemDataready   (MemDataready)
);

		

assign Reset=~ExternalReset; //当ExternalReset为0，Reset为1时复位

endmodule

