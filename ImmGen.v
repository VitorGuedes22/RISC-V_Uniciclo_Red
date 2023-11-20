module ImmGen (
    input  		  [31:0] iInstrucao,
    output logic [31:0] oImm
);


always @ (*)
    case (iInstrucao[6:0])
        7'b0000011,
        7'b0010011,
        7'b1100111:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:20]};

        7'b0100011:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[31:25], iInstrucao[11:7]};

        7'b1100011:
            oImm <= {{20{iInstrucao[31]}}, iInstrucao[7], iInstrucao[30:25], iInstrucao[11:8], 1'b0};

        7'b0010111,
        7'b0110111:
            oImm <= {iInstrucao[31:12], 12'b0};

        7'b1101111:
            oImm <= {{12{iInstrucao[31]}}, iInstrucao[19:12], iInstrucao[20], iInstrucao[30:21], 1'b0};
				
		  7'b1110011:
				begin
					case(iInstrucao[14:12]) // funct 3
						3'b101:
							oImm <= {27'b0, iInstrucao[19:15]};
						3'b110:
							oImm <= {27'b0, iInstrucao[19:15]};
						3'b111:
							oImm <= ~{27'b0, iInstrucao[19:15]};
						default:
							oImm <= 32'h00000000;	
					endcase
				end
				
        default:
            oImm <= 32'h00000000;
    endcase


endmodule
