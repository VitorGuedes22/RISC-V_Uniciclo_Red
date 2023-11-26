parameter STACK_ADDRESS = 32'h1001_03FC,
			 GLOBAL_POINTER = 32'h1001_0000;


module BancoReg (
		iReadReg1,
		iReadReg2,
		iWriteReg,
		iWriteData,
		iRegDispSelect,
		oReadData1,
		oReadData2,
		oRegDisp,
		iCLK,
		iRST,
		iRegWrite
	);
	
	input wire iCLK, iRST, iRegWrite;
	input wire [4:0] iReadReg1, iReadReg2, iWriteReg;
	input wire [31:0] iWriteData;
	input [4:0] iRegDispSelect;
	
	output [31:0] oReadData1, oReadData2;
	output [31:0] oRegDisp;
	
	reg [31:0] registers[31:0];

	parameter  SPR=5'd2, // Stack Pointer
				  GPR=5'd3; // Global Pointer
	reg [5:0] i;

	initial
		begin
			for (i = 0; i <= 31; i = i + 1'b1)
				registers[i] = 32'd0;
			registers[SPR] = STACK_ADDRESS;
			registers[GPR] = GLOBAL_POINTER;
		end
	
	assign oReadData1 =	registers[iReadReg1];
	assign oReadData2 =	registers[iReadReg2];
	
	assign oRegDisp =	registers[iRegDispSelect];
	
	always @(posedge iCLK or posedge iRST)
	begin
		if(iRST)
		begin
			for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] <= 32'b0;
			registers[SPR]   <= STACK_ADDRESS;
			registers[GPR] <= GLOBAL_POINTER;
		end
		else
		begin
			i <= 6'b0;
			if(iRegWrite && (iWriteReg != 5'b0))
				registers[iWriteReg] <= iWriteData;
		end
	end
	
endmodule