module RAM(
input                readMem,
input       [15:0]   address,
input        	      clk,
input       [15:0]	data,
input       	      wren,
output       [15:0]   out,
output reg           memDataReady
);

wire [15:0] q;
assign out=q;

RAM_CORE ramcore
(
.address         (address),
.clock             (clk),
.data            (data),
.wren            (wren),
.q               (q)
);


always@(posedge clk)
begin
 if(readMem)
   memDataReady=1;
 else
   memDataReady=0;
end

endmodule
