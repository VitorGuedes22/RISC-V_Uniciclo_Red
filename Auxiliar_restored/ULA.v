parameter OP_AND = 3'b000,
			 OP_OR = 3'b001,
			 OP_ADD = 3'b010,
			 OP_SUB = 3'b011,
			 OP_SLT = 3'b100,
			 OP_XOR = 3'b101;


module ULA (
	iControl,
	iA,
	iB,
	oResult
	);

	input [2:0] iControl;
	input signed [31:0] iA;
	input signed [31:0] iB;
	output [31:0] oResult;
	
	always @(*)
	begin
		case (iControl)
			OP_AND: oResult <= iA & iB;
			
			OP_OR: oResult <= iA | iB;
			
			OP_ADD: oResult <= iA + iB;
			
			OP_SUB: oResult <= iA - iB;
			
			OP_SLT: oResult <= iA < iB;
			
			OP_XOR: oResult <= iA ^ iB;

			default: oResult <= iA & iB;
		endcase
	end

endmodule