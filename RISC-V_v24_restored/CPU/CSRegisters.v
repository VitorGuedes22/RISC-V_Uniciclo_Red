`ifndef PARAM
	`include "Parametros.v"
`endif


module CSRegisters (
    input wire 			iCLK, iRST, iRegWrite,iRegWriteSimu,
	 input wire				iCLK50, iInst,
    input wire  [11:0] 	iReadRegister, iWriteRegister,
    input wire  [31:0] 	iWriteData, 
	 input wire  [31:0]  iWriteDataUEPC, iWriteDataUCAUSE, iWriteDataUTVAL,// registradores especiais precisam de acesso simultaneo
    output wire [31:0] 	oReadData,	
	 output wire [31:0]  oReadDataUTVEC, oReadDataUEPC, oReadDataUSTATUS,oReadDataUTVAL,// registradores especiais precisam de acesso simultaneo

    input wire  [4:0] 	iVGASelect, iRegDispSelect,
    output reg  [31:0] 	oVGARead, oRegDisp
    );
	 
	 
//  ustatus(0), fflags(1), frm(2), fcsr(3), uie(4), utvect(5), uscratch(64), uepc(65), ucause(66), utval(67), uip(68).
reg [31:0] registers [31:0]; // apenas 32 registradores CSR

wire[4:0] realReadRegister, realWriteRegister;
reg [4:0] i;
 
reg [15:0] CLK50Counter;  // Contador de ciclos, baseado no clock de 50 MHz

//  cycle(3072), time(3073), instret(3074), cycleh(3200), timeh(3201), instreth(3202).
reg [63:0] cycleCounter;  // Parte alta  = cycleh; Parte baixa = cycle
reg [63:0] timeCounter;	  // Parte alta = timeh; Parte baixa = time
reg [63:0] instCounter;   // H = instreth, L = instret

initial
	begin // zera o banco de registradores CSR
		for (i = 0; i <= 30; i = i + 1'b1)
			registers[i] <= ZERO;
			
		registers[17] <= MISA;
		registers[31] <= 32'hEEEEEEEE;	
		CLK50Counter <= 16'b0;
		timeCounter  <= 64'b0;
		instCounter  <= 64'b0;
		cycleCounter <= 64'b0;
	end

	
always @(posedge iCLK50 or posedge iRST) // A cada 50 mil ciclos, temos um 1 milissegundo
begin
	if (iRST) begin
      timeCounter <= 64'b0;
		CLK50Counter <= 16'b0;
   end
	else begin
		if (CLK50Counter == 16'd50000)
		begin
			timeCounter  <= timeCounter + 1'b1;
			CLK50Counter <= 16'b1;
		end
		else
			CLK50Counter <= CLK50Counter + 1'b1;
	end
end


`ifdef PIPELINE
always @(posedge iCLK or posedge iRST)
	begin
		if (iRST)
			instCounter <= 64'b0;
		else
		if (iInst == 1'b1)
			instCounter <= instCounter + 1'b1;			
	end
`else	
always @(posedge iInst or posedge iRST)
	begin
		if (iRST)
			instCounter <= 64'b0;
		else
			instCounter <= instCounter + 1'b1;	
	end		
`endif

	

// Mapeamento dos registradores CSR(0-4095) para realRegisters(0-31)

always @(*)
begin
	case(iReadRegister)
		12'd0:	realReadRegister <= 5'd0;
		12'd1:	realReadRegister <= 5'd1;
		12'd2:	realReadRegister <= 5'd2;
		12'd3:	realReadRegister <= 5'd3;
		12'd4:	realReadRegister <= 5'd4;
		12'd5:	realReadRegister <= 5'd5;
		12'd64:	realReadRegister <= 5'd6;
		12'd65:	realReadRegister <= 5'd7;
		12'd66:	realReadRegister <= 5'd8;
		12'd67:	realReadRegister <= 5'd9;
		12'd68:	realReadRegister <= 5'd10;
		12'd3072:realReadRegister <= 5'd11;
		12'd3073:realReadRegister <= 5'd12;
		12'd3074:realReadRegister <= 5'd13;
		12'd3200:realReadRegister <= 5'd14;
		12'd3201:realReadRegister <= 5'd15;
		12'd3202:realReadRegister <= 5'd16;	
		12'd769 :realReadRegister <= 5'd17;
		default:	realReadRegister <= 5'd31;	// Erro no endereçamento do CSR , retorna sempre 32'hEEEEEEEE
	endcase
end

always @(*)
begin
	case(iWriteRegister)
		12'd0:	realWriteRegister <= 5'd0;
		12'd1:	realWriteRegister <= 5'd1;
		12'd2:	realWriteRegister <= 5'd2;
		12'd3:	realWriteRegister <= 5'd3;
		12'd4:	realWriteRegister <= 5'd4;
		12'd5:	realWriteRegister <= 5'd5;	
		12'd64:	realWriteRegister <= 5'd6;
		12'd65:	realWriteRegister <= 5'd7;
		12'd66:	realWriteRegister <= 5'd8;
		12'd67:	realWriteRegister <= 5'd9;
		12'd68:	realWriteRegister <= 5'd10;
//		12'd3072:realWriteRegister <= 5'd11;   São MRO
//		12'd3073:realWriteRegister <= 5'd12;
//		12'd3074:realWriteRegister <= 5'd13;
//		12'd3200:realWriteRegister <= 5'd14;
//		12'd3201:realWriteRegister <= 5'd15;
//		12'd3202:realWriteRegister <= 5'd16;
//		12'd769 :realWriteRegister <= 5'd17;
		default:	realWriteRegister <= 5'd31;	// Erro no endereçamento do CSR , retorna sempre 32'hEEEEEEEE
	endcase
end

///////////////////////////////////////////////////////////////////
// CASES DEVEM SER MODIFICADOS CASO NOVOS CRS SEJAM ADICIONADOS 
	
assign oReadDataUSTATUS =	registers[0];	// leitura simultanea em ustatus, utvec, uepc
assign oReadDataUTVEC  	=	registers[5]; 
assign oReadDataUEPC   	=	registers[7];
assign oReadDataUTVAL   =  registers[9];
	
always @(*)
begin
	case (realReadRegister)	
	5'd11:	oReadData <= cycleCounter[31:0];
	5'd12:	oReadData <= timeCounter[31:0];
	5'd13:	oReadData <= instCounter[31:0];
	5'd14:	oReadData <= cycleCounter[63:32];
	5'd15:	oReadData <= timeCounter[63:32];
	5'd16:	oReadData <= instCounter[63:32];
	default:	oReadData <= registers[realReadRegister];
	endcase
end

always @(*)
begin
	case (iRegDispSelect)	
	5'd11:	oRegDisp <= cycleCounter	[31:0];
	5'd12:	oRegDisp <= timeCounter		[31:0];
	5'd13:	oRegDisp <= instCounter		[31:0];
	5'd14:	oRegDisp <= cycleCounter	[63:32];
	5'd15:	oRegDisp <= timeCounter		[63:32];
	5'd16:	oRegDisp <= instCounter		[63:32];
	default:	oRegDisp <= registers[iRegDispSelect];
	endcase
end

always @(*)
begin
	case (iVGASelect)	
	5'd11:	oVGARead <= cycleCounter	[31:0];
	5'd12:	oVGARead <= timeCounter		[31:0];
	5'd13:	oVGARead <= instCounter		[31:0];
	5'd14:	oVGARead <= cycleCounter	[63:32];
	5'd15:	oVGARead <= timeCounter		[63:32];
	5'd16:	oVGARead <= instCounter		[63:32];
	default:	oVGARead <= registers[iVGASelect];
	endcase
end


`ifdef PIPELINE
    always @(negedge iCLK or posedge iRST)
`else
    always @(posedge iCLK or posedge iRST)
`endif
begin
    if (iRST)
		begin // reseta o banco de registradores CSR
			for (i = 0; i <= 30; i = i + 1'b1)
				registers[i] <= ZERO;
				
			registers[17] <= MISA;
			registers[31] <= 32'hEEEEEEEE;	
			cycleCounter  <= 64'b0;
		end
    else
		begin
			i <= 5'b0; // para não dar warning
			cycleCounter <= cycleCounter + 64'b1;
					
			if(iRegWriteSimu)
				begin			
					registers[7] <= iWriteDataUEPC;
					registers[8] <= iWriteDataUCAUSE;
					registers[9] <= iWriteDataUTVAL;
				end		
			else 
				if(iRegWrite && (realWriteRegister != 5'd31))
						registers[realWriteRegister] <= iWriteData;
		end
end


endmodule

