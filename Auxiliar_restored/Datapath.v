module Datapath (
	iClkCPU,
	iClkMem,
	iRST,
	//initialPC,
	iregin,
	oInstView,
	oregout,
	oPCView,
	
	//Controle
	oInstruction,
	iBranch,
	//iMemRead,
	iMemtoReg,
	iALUControl,
	iMemWrite,
	iALUSrc,
	iRegWrite,
	iOrigPC

	
	//Memoria de instrucoes
   //IwAddress, 
   //IwReadData,
	);
	
	input wire iClkCPU, iClkMem;
	input wire iRST;
	//input [31:0] initialPC;
	input [4:0] iregin;
	
	output [31:0] oInstView;
	output [31:0] oPCView;
	output [31:0] oregout;
	
	//Controle
	output [31:0] oInstruction;
	input	 iBranch;
	//input	 iMemRead;
	input	[1:0] iMemtoReg;
	input	[2:0] iALUControl;
	input	 iMemWrite;
	input  iALUSrc;
	input  iRegWrite;
	input [1:0] iOrigPC;
	
		
	reg  [31:0] PC;

	initial
		begin
			PC <= 32'h0040_0000;
		end
	
	//Memoria de instrucoes
	
	wire [31:0] IwReadData;
	wire [31:0] instruction;
	rom INSTRUCTMEM (
		.address(PC[9:0]),
		.clock(iClkMem),
		.q(IwReadData)
		);
		
	
	assign oInstruction = IwReadData;
	assign oPCView = PC;
	assign oInstView = IwReadData;

	
	wire [31:0] wPC4       	= PC + 32'h00000001;
	wire [31:0] wBranchPC  	= PC + wImmediate;

	wire [4:0] wRs1 = IwReadData[19:15];
	wire [4:0] wRs2 = IwReadData[24:20];
	wire [4:0] wRd	= IwReadData[11:7];
		
	//Banco de registradores
	wire [31:0] wRead1, wRead2;
	
	BancoReg REGISTRADORES (
		.iCLK(iClkCPU),
		.iRST(iRST),
		.iRegWrite(iRegWrite),
		.iReadReg1(wRs1),
		.iReadReg2(wRs2),
		.iWriteReg(wRd),
		.iWriteData(wRegWrite),
		.iRegDispSelect(iregin),
		.oReadData1(wRead1),
		.oReadData2(wRead2),
		.oRegDisp(oregout)
		);
	
	//Gerador de imediato
	wire [31:0] wImmediate;
	
	ImmGen IMMGEN (
		.iInstrucao(IwReadData),
		.oImm(wImmediate)
		);
		
	//ALU
	wire [31:0] wALUResult;
	
	ULA ULA0 (
		.iControl(iALUControl),
		.iA(wRead1),
		.iB(wOrigBULA),
		.oResult(wALUResult)
		);
	
	//Memoria de dados
	wire [31:0] wDataMemOutput;
	
	ram DATAMEM (
		.address(wALUResult[9:0]),
		.clock(iClkMem),
		.data(wRead2),
		.wren(iMemWrite),
		.q(wDataMemOutput)
		);
	
	// Multiplexadores
	
wire [31:0] wOrigBULA;
always @(*)
	case (iALUSrc)
		1'b0: wOrigBULA <= wRead2;
		1'b1: wOrigBULA <= wImmediate;
	endcase

wire [31:0] wRegWrite;
always @(*)
	case (iMemtoReg)
		2'b00: wRegWrite <= wALUResult; // tipo R
		2'b01: wRegWrite <= wDataMemOutput; // load
		2'b10: wRegWrite <= wPC4;  // Jal
		default: wRegWrite <= wALUResult;
	endcase
	
wire [31:0] wNPC;
always @(*)
	case (iOrigPC)
		2'b00: wNPC <= wPC4; //PC + 4
		2'b01: wNPC <= (iBranch && wRead1 == wRead2) ? wBranchPC : wPC4; // Branch
		2'b10: wNPC <= wBranchPC; // Jal
		default: wNPC <= 32'h0040_0000;
	endcase

always @(posedge iClkCPU or posedge iRST)
begin
    if(iRST)
		begin
			PC	<= 32'h0040_0000;	
		end
    else
			begin
			PC	<= wNPC;
			end
end


endmodule