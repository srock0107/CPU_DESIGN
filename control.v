//----------------------------------------------------------------------
//--SAYEH (Simple Architecture Yet Enough Hardware) CPU
//----------------------------------------------------------------------
//Controller

`timescale 1 ns / 1 ps

module control (
	ExternalReset, clk,
    ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
    Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB, sel_aluout_rfin, sel_rfin, 
    RFLwrite, RFHwrite, 
    IRload, SRload,
	IR_on_LOpndBus, IR_on_HOpndBus, RFright_on_OpndBus, 
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset, 
	Instruction, 
	Cflag, Zflag, memDataReady
);

input ExternalReset, clk; //时钟与顶层复位
output
	//PC单元控制
	EnablePC, ResetPC, 
	PCplusI, PCplus1, RplusI, Rplus0,
	//指令寄存器控制
	IRload,
	//MUX控制
	sel_aluout_rfin,sel_rfin,
	//寄存器阵列控制
	RFLwrite, RFHwrite,
	//通路切换控制
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
	RFright_on_OpndBus,	
	IR_on_LOpndBus, IR_on_HOpndBus,
	//ALU控制
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,
	//状态寄存器控制
	SRload, Cset, Creset,	
	//读写控制
    ReadMem, WriteMem, ReadIO, WriteIO; 
reg
	ResetPC, PCplusI, PCplus1, RplusI, Rplus0,
	Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide, EnablePC, 
    B15to0, AandB, AorB, notB, shlB, shrB, AaddB, AsubB, AmulB, AcmpB,sel_aluout_rfin,sel_rfin,
    RFLwrite, RFHwrite,
    WPreset, WPadd, IRload, SRload,
	IR_on_LOpndBus,IR_on_HOpndBus, RFright_on_OpndBus,
    ReadMem, WriteMem, ReadIO, WriteIO, Cset, Creset;
    
input[15:0] Instruction;//指令输入
input Cflag, Zflag; //状态寄存器输出控制
input memDataReady; //外部信号输入控制

// 状态机编码表示
parameter [3 : 0]
	reset          = 0 ,
	fetch          = 1 ,
	memread        = 2 ,
	exec1          = 3 ,
	exec1lda       = 4 ,
	// exec2lda    = 7 ,
	exec1inp       = 5 ,	
	incpc          = 6 ;

// 指令编码表示
parameter b0000 = 4'b0000;
parameter b1111 = 4'b1111;

parameter nop = 4'b0000;
parameter scf = 4'b0001;
parameter ccf = 4'b0010;
parameter jpr = 4'b0011;
parameter jnz = 4'b0100;

parameter mvr = 4'b0001;
parameter lda = 4'b0010;
parameter sta = 4'b0011;
parameter inp = 4'b0100;
parameter oup = 4'b0101;
parameter anl = 4'b0110;
parameter orr = 4'b0111;
parameter nol = 4'b1000;
parameter shl = 4'b1001;
parameter shr = 4'b1010;
parameter add = 4'b1011;
parameter sub = 4'b1100;
parameter mul = 4'b1101;
parameter cmp = 4'b1110;

parameter mil = 2'b00;
parameter mih = 2'b01;
parameter jpa = 2'b10;

reg [3 : 0] Pstate, Nstate;

// 状态更新（我要去哪儿？时序电路时钟触发）
always @(posedge clk)
begin
    if( ExternalReset )
    begin
        Pstate <= reset;
    end
    else
    begin
        Pstate <= Nstate;
    end
end

// 状态转移（我怎样去？组合电路立刻改变）
always @ ( * )
begin
    case ( Pstate )
    reset : // 0000
        if( ExternalReset ) begin
            Nstate = reset;
        end
        else
            Nstate = fetch;

    fetch : // 0001
        if( ExternalReset )
            Nstate = reset;
        else begin
            Nstate = memread;
        end 

    memread : // 0010
        if( ExternalReset )
            Nstate = reset;
        else begin
            if (memDataReady == 1'b0) begin
                Nstate = memread;
            end
            else begin   
                Nstate = exec1;
            end
        end

    exec1 : // 0011
        if( ExternalReset )
            Nstate = reset;
        else begin
            case (Instruction[15:12])
            lda :
            begin
                Nstate = exec1lda;
            end

            sta :
            begin
                Nstate = incpc; 
            end

            inp :
            begin
                Nstate = exec1inp; 
            end

            default :
                Nstate = fetch;
            endcase
        end 

    exec1lda : // 0100
        if( ExternalReset )
            Nstate = reset;
        else begin
            if (memDataReady == 1'b0) begin
                Nstate = exec1lda;
            end
            else begin
                Nstate = fetch;
            end
        end
        
    
    exec1inp : // 0101
        if( ExternalReset )
            Nstate = reset;
        else begin
            Nstate = fetch;					
        end
        

    incpc : // 0110
	begin 
        Nstate = fetch;
    end
    
    default:
        Nstate = reset;

    endcase
end

// 状态输出（去了干啥？时序电路时钟触发）
always @ (posedge clk)
begin    
    ResetPC 			   <= 1'b0;
    PCplusI 			   <= 1'b0;
    PCplus1 			   <= 1'b0;
    RplusI 				   <= 1'b0;
    Rplus0  			   <= 1'b0;
    EnablePC 			   <= 1'b0;
    B15to0 				   <= 1'b0;
    AandB 				   <= 1'b0;
    AorB 				   <= 1'b0;
    notB 				   <= 1'b0;
    shrB 				   <= 1'b0;
    shlB 				   <= 1'b0;
    AaddB  				   <= 1'b0;
    AsubB 				   <= 1'b0;
    AmulB  				   <= 1'b0;
    AcmpB  				   <= 1'b0;
    RFLwrite			   <= 1'b0;
    RFHwrite 			   <= 1'b0;
    IRload 				   <= 1'b0;
    SRload  			   <= 1'b0;
    sel_aluout_rfin        <= 1'b0;
    sel_rfin               <= 1'b0;
    IR_on_LOpndBus 		   <= 1'b0;
    IR_on_HOpndBus		   <= 1'b0;
    RFright_on_OpndBus 	   <= 1'b0;
    ReadMem 			   <= 1'b0;
    WriteMem 			   <= 1'b0;
    ReadIO 				   <= 1'b0;
    WriteIO 			   <= 1'b0;
    Cset				   <= 1'b0;
    Creset				   <= 1'b0;
    Rs_on_AddressUnitRSide  <= 1'b0;
    Rd_on_AddressUnitRSide  <= 1'b0;

    case ( Nstate )
    reset : // 0000
        if( ExternalReset ) begin
            ResetPC     <= 1'b1;
            EnablePC    <= 1'b1;
            Creset      <= 1'b1;
        end

    fetch : // 0001
        if( !ExternalReset )
            ReadMem <= 1'b1;

    memread : // 0010
        if( !ExternalReset )
        begin
            if (memDataReady == 1'b0) begin
                ReadMem <= 1'b1;
            end
            else begin   
                IRload <= 1'b1;   
            end
        end

    exec1 : // 0011
        if( !ExternalReset )
        begin
            case (Instruction[15:12])
            b0000 :
                case (Instruction[11:8]) 
                nop :
                    begin
                        PCplus1     <=  1'b1;
                        EnablePC    <=  1'b1;
                    end
                    
                scf : begin
                    Cset        <=  1'b1;						
                    PCplus1     <=  1'b1;
                    EnablePC    <=  1'b1;
                end

                ccf : begin
                    Creset      <= 1'b1;			
                    PCplus1     <= 1'b1;
                    EnablePC    <= 1'b1;
                end

                jpr : begin
                    PCplusI     <= 1'b1;
                    EnablePC    <= 1'b1;
                end	
                
                jnz : begin
                    if( Zflag == 1'b0 )
                    begin
                        RplusI      <= 1'b1;
                        EnablePC    <= 1'b1;
                    end
                    else
                    begin
                        PCplus1     <= 1'b1;
                        EnablePC    <= 1'b1;
                    end
                end
                
                default: begin
                    PCplus1     <= 1'b1;
                    EnablePC    <= 1'b1;
                end
                endcase

            mvr : begin
               //add your code
            end

            lda : begin
                Rplus0                  <= 1'b1;
                Rs_on_AddressUnitRSide  <= 1'b1;
                ReadMem                 <= 1'b1;
            end

            sta : begin
                Rplus0                  <= 1'b1;
                Rd_on_AddressUnitRSide  <= 1'b1;
                RFright_on_OpndBus      <= 1'b1;
                B15to0                  <= 1'b1;
                WriteMem                <= 1'b1;
            end

            inp : begin
                ReadIO                  <= 1'b1;
            end

            oup : begin
                //Rplus0                    <= 1'b1;
                //Rd_on_AddressUnitRSide    <= 1'b1;
                RFright_on_OpndBus          <= 1'b1;
                B15to0                      <= 1'b1;
                WriteIO                     <= 1'b1;
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            anl : begin
                RFright_on_OpndBus          <= 1'b1;
                AandB                       <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;					
                PCplus1                     <= 1'b1;
                EnablePC                    <=1'b1;
            end

            orr : begin
                RFright_on_OpndBus          <= 1'b1;
                AorB                        <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;					
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            nol : begin
                RFright_on_OpndBus          <= 1'b1;
                notB                        <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            shl : begin
                RFright_on_OpndBus          <= 1'b1;
                shlB                        <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            shr : begin
                RFright_on_OpndBus          <= 1'b1;
                shrB                        <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            add : begin
                RFright_on_OpndBus          <= 1'b1;
                AaddB                       <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            sub : begin
                RFright_on_OpndBus          <= 1'b1;
                AsubB                       <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;					
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            mul : begin
                RFright_on_OpndBus          <= 1'b1;
                AmulB                       <= 1'b1;
                sel_aluout_rfin             <= 1'b1;
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;
                SRload                      <= 1'b1;
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            cmp : begin
                RFright_on_OpndBus          <= 1'b1;
                AcmpB                       <= 1'b1;
                SRload                      <= 1'b1;
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end

            b1111 :
                case (Instruction[9: 8]) 
                mil : begin
                   //add your code
                end

                mih : begin
                  //add your code
                end

                jpa : begin
                    Rd_on_AddressUnitRSide  <= 1'b1;
                    RplusI                  <= 1'b1;
                    EnablePC                <= 1'b1;
                end

                default:begin
                    RplusI                  <= 1'b1;
                    EnablePC                <= 1'b1;
                end
                endcase

            default :
            begin
            end
            endcase
        end 

    exec1lda : // 0100
        if( !ExternalReset ) begin
            if (memDataReady == 1'b0) begin
                Rplus0                      <= 1'b1;
                Rs_on_AddressUnitRSide      <= 1'b1;
                ReadMem                     <= 1'b1;
            end
            else begin  
                RFLwrite                    <= 1'b1;
                RFHwrite                    <= 1'b1;	
                sel_aluout_rfin             <= 1'b0;	
                
                PCplus1                     <= 1'b1;
                EnablePC                    <= 1'b1;
            end
        end
        
    
    exec1inp : // 0101
        if( !ExternalReset ) begin
            RFLwrite                        <= 1'b1;
            RFHwrite                        <= 1'b1;	
            sel_aluout_rfin                 <= 1'b0;	
            sel_rfin                        <= 1'b1;
            PCplus1                         <= 1'b1;
            EnablePC                        <= 1'b1;					
        end
        

    incpc : begin // 0110
        PCplus1                             <= 1'b1;
        EnablePC                            <= 1'b1;
    end
    
    default:
    begin
    end

    endcase
end

endmodule
