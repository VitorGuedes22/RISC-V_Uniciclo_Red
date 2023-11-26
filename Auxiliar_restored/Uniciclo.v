module Uniciclo (
	input wire clockCPU, clockMem,
	input wire reset,
	output reg [31:0] PC,
	output reg [31:0] Instr,
	input  wire[4:0] regin,
	output reg [31:0] regout
	);
	
	
	/*initial
		begin
			PC<=32'h0040_0000;
			Instr<=32'b0;
			regout<=32'b0;
		end*/
		
	
// Aqui vai o seu código do processador

// Controle

wire oCBranch;
//wire oCMemRead;
wire [1:0] oCMemtoReg;
wire [2:0] oCALUControl;
wire oCMemWrite;
wire oCALUSrc;
wire oCRegWrite;
wire [1:0] oCOrigPC;


Controle CONTROL(
	.iInst(wInst),
	.oBranch(oCBranch),
	//.oMemRead(oCMemRead),
	.oMemtoReg(oCMemtoReg),
	.oALUControl(oCALUControl),
	.oMemWrite(oCMemWrite),
	.oALUSrc(oCALUSrc),
	.oRegWrite(oCRegWrite),
	.oOrigPC(oCOrigPC)
	);

// Caminho de dados
wire [31:0] wInst;

Datapath DATAPATH(
	// Start	
	.iClkCPU(clockCPU),
	.iClkMem(clockMem),
	.iRST(reset),
	//.initialPC(PC),
	.iregin(regin),
	.oInstView(Instr),
	.oregout(regout),
	.oPCView(PC),
	
	//Controle
	.oInstruction(wInst),
	.iBranch(oCBranch),
	//.iMemRead(oCMemRead),
	.iMemtoReg(oCMemtoReg),
	.iALUControl(oCALUControl),
	.iMemWrite(oCMemWrite),
	.iALUSrc(oCALUSrc),
	.iRegWrite(oCRegWrite),
	.iOrigPC(oCOrigPC)
	);
			
endmodule
