// * Bloco de Controle UNICICLO
// *
 

 module Control_UNI(
    input  [31:0] iInstr, 
    output [ 1:0]	oOrigAULA, 
	 output [ 1:0]	oOrigBULA, 
	 output			oRegWrite, 
	 output 			oCSRegWrite,
	 output			oMemWrite, 
	 output			oMemRead,
	 output			oInvInstruction,
	 output 			oEcall,
	 output 	   	oEbreak,
	 output [ 2:0]	oMem2Reg, 
	 output [ 2:0]	oOrigPC,
	 output [ 4:0] oALUControl
);

wire 			wEbreak;
wire [6:0]  Opcode 	= iInstr[ 6: 0];
wire [2:0]  Funct3	= iInstr[14:12];
wire [6:0]  Funct7	= iInstr[31:25];
wire [11:0]	Funct12	= iInstr[31:20]; // instruções de systema ecall e ebreak em que funct12 = funct7 + rs2


assign oEbreak = wEbreak;
	

always @(*)
	case(Opcode)
	
		7'b1110011:
			begin			
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 	
		
				case(Funct3)
					3'b000:
						begin			
							case(Funct12)
							
								12'b000000000000:
									begin
										oCSRegWrite 			<= 1'b0;
										oInvInstruction		<= 1'b0;
										oOrigAULA				<= 2'b00;	// tanto faz ja que regwrite é 0
										oOrigBULA 				<= 2'b00;	// tanto faz ja que regwrite é 0
										oALUControl				<= 5'd31;
										oEcall 					<= 1'b1;
										wEbreak					<= 1'b0;
										oOrigPC					<= 3'b100;
										oRegWrite				<= 1'b0;
										oMem2Reg 				<= 3'b000;// tanto faz ja que regwrite é 0
									end
									
								12'b000000000001:
									begin										
										oCSRegWrite 			<= 1'b0;
										oInvInstruction		<= 1'b0;
										oOrigAULA				<= 2'b00;	// tanto faz ja que regwrite é 0
										oOrigBULA 				<= 2'b00;	// tanto faz ja que regwrite é 0
										oALUControl				<= 5'd31;
										oEcall 					<= 1'b0;
										wEbreak					<= 1'b1;
										oOrigPC					<= 3'b000;
										oRegWrite				<= 1'b0;
										oMem2Reg 				<= 3'b000;// tanto faz ja que regwrite é 0
									end
									
								12'b000000000010:
									begin
									
										oCSRegWrite 			<= 1'b0;
										oInvInstruction		<= 1'b0;
										oOrigAULA				<= 2'b00;	// tanto faz ja que regwrite é 0
										oOrigBULA 				<= 2'b00;	// tanto faz ja que regwrite é 0
										oALUControl				<= 5'd31;
										oEcall 					<= 1'b0;
										wEbreak					<= 1'b0;
										oOrigPC					<= 3'b101;		// pc = uepc
										oRegWrite				<= 1'b0;
										oMem2Reg 				<= 3'b000;// tanto faz ja que regwrite é 0
									end
									
								default: // instrucao invalida
									begin
										oCSRegWrite 			<= 1'b0;
										oInvInstruction		<= 1'b1;
										oOrigAULA				<= 2'b00;	// tanto faz ja que regwrite é 0
										oOrigBULA 				<= 2'b00;	// tanto faz ja que regwrite é 0
										oALUControl				<= 5'd31;
										oEcall 					<= 1'b0;
										wEbreak					<= 1'b0;
										oOrigPC					<= 3'b000;
										oRegWrite				<= 1'b0;
										oMem2Reg 				<= 3'b000;
									end
							endcase					
						end
						
					3'b001:
						begin
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b00; // conteudo de rs1
							oOrigBULA 				<= 2'b11; // zero
							oALUControl				<= 5'd3;
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					3'b010:  
						begin
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b00; // conteudo de rs1
							oOrigBULA 				<= 2'b10; // CSR
							oALUControl				<= 5'd1;
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					3'b011:  
						begin
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b11; // conteudo de rs1 negado
							oOrigBULA 				<= 2'b10; // CSR
							oALUControl				<= 5'd0 ; // CSR = CSR & !rs1
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;	
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					3'b101:
						begin
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b10; //imediato
							oOrigBULA 				<= 2'b11; // zero
							oALUControl				<= 5'd3;
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					3'b110:
						begin	
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b10;	//imediato 
							oOrigBULA 				<= 2'b10;	// CSR
							oALUControl				<= 5'd1;
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					3'b111:	
						begin
							oCSRegWrite 			<= 1'b1;
							oInvInstruction		<= 1'b0;
							oOrigAULA				<= 2'b10; //imediato 
							oOrigBULA 				<= 2'b10; // CSR
							oALUControl				<= 5'd0; // CSR = CSR & ~imm)
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b1;
							oMem2Reg 				<= 3'b100;
						end
						
					default: // instrucao invalida
						begin	
							oCSRegWrite 			<= 1'b0;
							oInvInstruction		<= 1'b1;
							oOrigAULA				<= 2'b00;	// tanto faz ja que regwrite é 0
							oOrigBULA 				<= 2'b00;	// tanto faz ja que regwrite é 0
							oALUControl				<= 5'd31;
							oEcall 					<= 1'b0;
							wEbreak					<= 1'b0;
							oOrigPC					<= 3'b000;
							oRegWrite				<= 1'b0;
							oMem2Reg 				<= 3'b000;
						end
				endcase
			end
			
		7'b0000011:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA				<= 1'b0;
				oOrigBULA 				<= 2'b01;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b1; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b010;
				oOrigPC					<= 3'b000;
			end
			
		7'b0010011:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b01;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;
				case (Funct3)
					3'b000:			oALUControl <= 5'd3;
					3'b001:			oALUControl <= 5'd7;
					3'b010:			oALUControl <= 5'd5;
					3'b011:		oALUControl	<= 5'd6;
					3'b100:			oALUControl <= 5'd2;
					3'b101,
					3'b101:
						if(Funct7==7'b0100000)  oALUControl <= 5'd9;
						else 							oALUControl <= 5'd8;
					3'b110:			oALUControl <= 5'd1;
					3'b111:			oALUControl <= 5'd0;	
					default: // instrucao invalida
						begin
							oInvInstruction  		<= 1'b1;
							oOrigAULA  				<= 2'b00;
							oOrigBULA 				<= 2'b00;
							oRegWrite				<= 1'b0;
							oMemWrite				<= 1'b0; 
							oMemRead 				<= 1'b0; 
							oALUControl				<= 5'd31;
							oMem2Reg 				<= 3'b000;
							oOrigPC					<= 3'b000;
						end				
				endcase
			end
			
		7'b0010111:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b01;
				oOrigBULA 				<= 2'b01;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;
			end
			
		7'b0100011:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b01;
				oRegWrite				<= 1'b0;
				oMemWrite				<= 1'b1; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;	
			end
		
		7'b0110011:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b00;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;
				case (Funct7)
				7'b0000000,  // ou qualquer outro 7'b0000000
				7'b0100000:	 // SUB ou SRA			
					case (Funct3)
						3'b000,
						3'b000:
							if(Funct7==7'b0100000)   oALUControl <= 5'd4;
							else 							 oALUControl <= 5'd3;
						3'b001:			oALUControl <= 5'd7;
						3'b010:			oALUControl <= 5'd5;
						3'b011:		oALUControl	<= 5'd6;
						3'b100:			oALUControl <= 5'd2;
						3'b101,
						3'b101:
							if(Funct7==7'b0100000)  oALUControl <= 5'd9;
							else 							oALUControl <= 5'd8;
						3'b110:			oALUControl <= 5'd1;
						3'b111:			oALUControl <= 5'd0;
						default: // instrucao invalida
							begin
								oInvInstruction  		<= 1'b1;
								oOrigAULA  				<= 2'b00;
								oOrigBULA 				<= 2'b00;
								oRegWrite				<= 1'b0;
								oMemWrite				<= 1'b0; 
								oMemRead 				<= 1'b0; 
								oALUControl				<= 5'd31;
								oMem2Reg 				<= 3'b000;
							end				
					endcase

//`ifndef RV32I					
//				FUNCT7_MULDIV:	
//					case (Funct3)
//						FUNCT3_MUL:			oALUControl <= OPMUL;
//						FUNCT3_MULH:		oALUControl <= OPMULH;
//						FUNCT3_MULHSU:		oALUControl <= OPMULHSU;
//						FUNCT3_MULHU:		oALUControl <= OPMULHU;
//						FUNCT3_DIV:			oALUControl <= OPDIV;
//						FUNCT3_DIVU:		oALUControl <= OPDIVU;
//						FUNCT3_REM:			oALUControl <= OPREM;
//						FUNCT3_REMU:		oALUControl <= OPREMU;	
//						default: // instrucao invalida
//							begin
//								oInvInstruction  		<= 1'b1;
//								oOrigAULA  				<= 2'b00;
//								oOrigBULA 				<= 2'b00;
//								oRegWrite				<= 1'b0;
//								oMemWrite				<= 1'b0; 
//								oMemRead 				<= 1'b0; 
//								oALUControl				<= OPNULL;
//								oMem2Reg 				<= 3'b000;
//								oOrigPC					<= 3'b000;
//							end				
//					endcase
//`endif			
				default: // instrucao invalida
					begin
						oInvInstruction  		<= 1'b1;
						oOrigAULA  				<= 2'b00;
						oOrigBULA 				<= 2'b00;
						oRegWrite				<= 1'b0;
						oMemWrite				<= 1'b0; 
						oMemRead 				<= 1'b0; 
						oALUControl				<= 5'd31;
						oMem2Reg 				<= 3'b000;
						oOrigPC					<= 3'b000;
					end				
			endcase			
		end
		
		7'b0110111:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b01;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd10;
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;
			end
			
		7'b1100011:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b00;
				oRegWrite				<= 1'b0;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b001;
			end
			
		7'b1100111:
			begin	
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b00;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b001;
				oOrigPC					<= 3'b011;
			end
		
		7'b1101111:
			begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oEcall 					<= 1'b0;
				oInvInstruction  		<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b00;
				oRegWrite				<= 1'b1;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd3;
				oMem2Reg 				<= 3'b001;
				oOrigPC					<= 3'b010;
			end

      
		default: // instrucao invalida
        begin
				wEbreak					<= 1'b0;
				oCSRegWrite 			<= 1'b0;
				oInvInstruction  		<= 1'b1;
				oEcall 					<= 1'b0;
				oOrigAULA  				<= 2'b00;
				oOrigBULA 				<= 2'b00;
				oRegWrite				<= 1'b0;
				oMemWrite				<= 1'b0; 
				oMemRead 				<= 1'b0; 
				oALUControl				<= 5'd31;
				oMem2Reg 				<= 3'b000;
				oOrigPC					<= 3'b000;
				
        end
		  
	endcase

endmodule