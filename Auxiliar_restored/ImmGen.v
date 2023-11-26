module ImmGen (
		iInstrucao,
		oImm
	);
	
	input [31:0] iInstrucao;
	output logic [31:0] oImm;
	
	always @(*)
	begin
		case (iInstrucao[6:0])
			OP_LOAD, OP_R_IMM: oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:20]};
			OP_B: oImm <= {{20{iInstrucao[31]}}, iInstrucao[7], iInstrucao[30:25], iInstrucao[11:8], 1'b0};
			OP_STORE: oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:25], iInstrucao[11:7]};
			OP_JAL: oImm <= {{12{iInstrucao[31]}}, iInstrucao[19:12], iInstrucao[20], iInstrucao[30:21], 1'b0};
			default: oImm <= 32'h00000000;
		endcase
	end

endmodule