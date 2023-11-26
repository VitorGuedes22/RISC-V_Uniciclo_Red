parameter OP_R = 7'b0110011,
			 OP_B = 7'b1100011,
			 OP_LOAD = 7'b0000011,
			 OP_STORE = 7'b0100011,
			 OP_JAL = 7'b1101111,
			 OP_R_IMM = 7'b0010011,
			 
			 FUNCT3_ADD	= 3'b000,
			 FUNCT3_SUB	= 3'b000,
			 FUNCT3_SLT	= 3'b010,
			 FUNCT3_OR	= 3'b110,
			 FUNCT3_AND	= 3'b111,
			 FUNCT3_ADDI = 3'b001,
			 FUNCT3_ANDI = 3'b111,
			 FUNCT3_ORI = 3'b100,
			 FUNCT3_XORI = 3'b010,
			 
			 FUNCT7_ADD	= 7'b0000000,
			 FUNCT7_SUB = 7'b0100000;
			 
		//0010011 opcode
		//00000000010000101000 00101 0010011
			 
module Controle (
	iInst,
	oBranch,
	//oMemRead,
	oMemtoReg,
	oALUControl,
	oMemWrite,
	oALUSrc,
	oRegWrite,
	oOrigPC
	);

	input [31:0] iInst;
	 
	output oBranch;
   //output oMemRead;
	output [1:0] oMemtoReg;
	output [2:0] oALUControl;
	output oMemWrite;
	output oALUSrc;
	output oRegWrite;
	output [1:0] oOrigPC;
	
	wire [6:0] Opcode = iInst[6:0];
	wire [2:0] funct3 = iInst[14:12];
	wire [6:0] funct7 = iInst[31:25];
	
	always @(*) 
	begin
		case (Opcode)	
			OP_B:
			begin
					oALUSrc <= 1'b0;
					oMemtoReg <= 2'b00;
					oRegWrite <= 1'b0;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b0;
					oBranch <= 1'b1;
					oALUControl <= OP_SUB;
					oOrigPC <= 2'b01;
		  end
			OP_LOAD:
			begin
					oALUSrc <= 1'b1;
					oMemtoReg <= 2'b01;
					oRegWrite <= 1'b1;
					//oMemRead <= 1'b1;
					oMemWrite <= 1'b0;
					oBranch <= 1'b0;
					oALUControl <= OP_ADD;
					oOrigPC <= 2'b00;
			end
			OP_STORE:
			begin
					oALUSrc <= 1'b1;
					oMemtoReg <= 2'b00;
					oRegWrite <= 1'b0;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b1;
					oBranch <= 1'b0;
					oALUControl <= OP_ADD;
					oOrigPC <= 2'b00;
			end
			OP_JAL:
			begin
					oALUSrc <= 1'b0;
					oMemtoReg <= 2'b10;
					oRegWrite <= 1'b1;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b0;
					oBranch <= 1'b0;
					oALUControl <= OP_ADD;
					oOrigPC <= 2'b10;
			end	
			OP_R:
				begin
					oALUSrc <= 1'b0;
					oMemtoReg <= 2'b00;
					oRegWrite <= 1'b1;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b0;
					oBranch <= 1'b0;
					
					case (funct3)
						FUNCT3_ADD:
								if (funct7 == FUNCT7_ADD) oALUControl <= OP_ADD;
								else oALUControl <= OP_SUB;
						FUNCT3_AND: oALUControl <= OP_AND;
						FUNCT3_OR: oALUControl <= OP_OR;
						FUNCT3_SLT: oALUControl <= OP_SLT;	
						default: oALUControl <= OP_ADD;
					endcase
					oOrigPC<= 2'b00;
				end
			OP_R_IMM:
				begin
					oALUSrc <= 1'b1;
					oMemtoReg <= 2'b00;
					oRegWrite <= 1'b1;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b0;
					oBranch <= 1'b0;
					
					case (funct3)
						FUNCT3_ADDI: oALUControl <= OP_ADD;
						FUNCT3_ANDI: oALUControl <= OP_AND;
						FUNCT3_ORI: oALUControl <= OP_OR;
						FUNCT3_XORI: oALUControl <= OP_XOR;
						default: oALUControl <= OP_ADD;
					endcase
					oOrigPC <= 2'b00;
				end
			default:
				begin
					oALUSrc <= 1'b0;
					oMemtoReg <= 2'b00;
					oRegWrite <= 1'b0;
					//oMemRead <= 1'b0;
					oMemWrite <= 1'b0;
					oBranch <= 1'b0;
					oALUControl <= OP_ADD;
					oOrigPC <= 2'b11;
				end
		endcase		
	end		
endmodule