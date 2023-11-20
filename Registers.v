module Registers (
    input wire 			iCLK, iRST, iRegWrite,
    input wire  [4:0] 	iReadRegister1, iReadRegister2, iWriteRegister,
    input wire  [31:0] 	iWriteData,
    output wire [31:0] 	oReadData1, oReadData2
    );

/* Register file */
reg [31:0] registers[31:0];

parameter  SPR=5'd2;                    // SP

reg [5:0] i;

initial
	begin
		for (i = 0; i <= 31; i = i + 1'b1)
			registers[i] = 32'h10010000;
		registers[SPR] = 32'h100103FC;
	end


assign oReadData1 =	registers[iReadRegister1];
assign oReadData2 =	registers[iReadRegister2];


`ifdef PIPELINE
    always @(negedge iCLK or posedge iRST)
`else
    always @(posedge iCLK or posedge iRST)
`endif
begin
    if (iRST)
    begin // reseta o banco de registradores e pilha
        for (i = 0; i <= 31; i = i + 1'b1)
            registers[i] <= 32'b0;
			registers[SPR]   <= 32'h100103FC;  // SP
    end
    else
	 begin
		i<=6'b0; // para não dar warning
		if(iRegWrite && (iWriteRegister != 5'b0))
				registers[iWriteRegister] <= iWriteData;
	 end
end

endmodule