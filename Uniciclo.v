module Uniciclo (
	input wire clockCPU, clockMem,
	input wire reset,
	output reg [31:0] PC,
	output reg [31:0] Instr,
	input  wire[4:0] regin,
	output reg [31:0] regout
	);
	
	
	initial
		begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end
		

// Aqui vai o seu código do processador

ramI RAM1 (.address(PC[9:0]), .clock(clockMem), .data(), .wren(1'b0), .q());


assign mControlState    = 6'b000000;


// Unidade de Controle
wire [ 1:0]	 wCOrigAULA; 
wire [ 1:0]	 wCOrigBULA; 
wire			 wCRegWrite; 
wire         wCCSRegWrite;
wire			 wCMemWrite; 
wire			 wCMemRead;
wire 			 wCInvInstruction;
wire 			 wCEcall;
//wire 			 wCEbreak;
wire [ 2:0]	 wCMem2Reg; 
wire [ 2:0]	 wCOrigPC;
wire [ 4:0]  wCALUControl;


 Control_UNI CONTROL0 (
	.iInstr(Instr), 
   .oOrigAULA(wCOrigAULA), 
	.oOrigBULA(wCOrigBULA), 
	.oRegWrite(wCRegWrite), 
	.oCSRegWrite(wCCSRegWrite),
	.oMemWrite(wCMemWrite), 
	.oMemRead(wCMemRead),
	.oInvInstruction(wCInvInstruction),
	.oEcall(wCEcall),
	.oEbreak(wCEbreak),
	.oMem2Reg(wCMem2Reg), 
	.oOrigPC(wCOrigPC),
	.oALUControl(wCALUControl)
);

	 



// ****************************************************** 
// Instanciacao das estruturas e banco de registradores 	 		  						 


wire [31:0] wPC4       	= PC + 32'h00000004;
wire [31:0] wBranchPC  	= PC + wImmediate;

wire [11:0] wCSR 			= Instr[31:20];
wire [ 4:0] wRs1			= Instr[19:15];
wire [ 4:0] wRs2			= Instr[24:20];
wire [ 4:0] wRd			= Instr[11: 7];
wire [ 2:0] wFunct3		= Instr[14:12];
wire [ 6:0] wOpcode     = Instr[ 6: 0];

wire [31:0] wRegWrite; //mux saída de dados da memória

wire [31:0] wRead1, wRead2;

Registers registers1(
		.iCLK(clockCPU),
		.iRST(reset),
		.iReadRegister1(wRs1),
		.iReadRegister2(wRs2),
		.iWriteRegister(wRd),
		.iWriteData(wRegWrite),
		.iRegWrite(wCRegWrite),
		.oReadData1(wRead1),
		.oReadData2(wRead2)
);
		
// Unidade geradora do imediato 
wire [31:0] wImmediate;

ImmGen IMMGEN0 (
    .iInstrucao(Instr),
    .oImm(wImmediate)
);


// ALU - Unidade Lógica-Artimética
wire [31:0] wALUresult;

ALU ALU0 (
    .iControl(wCALUControl),
    .iA(wOrigAULA),
    .iB(wOrigBULA),
    .oResult(wALUresult)  
);
			
endmodule
