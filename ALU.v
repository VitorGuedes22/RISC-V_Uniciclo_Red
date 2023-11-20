module ALU (
	input 		 [4:0]  iControl,
	input signed [31:0] iA, 
	input signed [31:0] iB,
	output 		 [31:0] oResult
	);

//	wire [4:0] iControl=OPMUL;		// Usado para as análises


always @(*)
begin
    case (iControl)
		5'd0:
			oResult  <= iA & iB;
		5'd1:
			oResult  <= iA | iB;
		5'd2:
			oResult  <= iA ^ iB;
		5'd3:
			oResult  <= iA + iB;
		5'd4:
			oResult  <= iA - iB;
		5'd5:
			oResult  <= iA < iB;
		5'd31:
			oResult  <= 32'h00000000; // recebe zero
			
		default:
			oResult  <= 32'h00000000; // recebe zero
    endcase
end

endmodule