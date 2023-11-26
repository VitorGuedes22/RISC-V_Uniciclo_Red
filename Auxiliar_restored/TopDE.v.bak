module TopDE (
	input wire CLOCK_50,
	input wire [9:0] SW,
	input wire [3:0] KEY,
	output wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
	);
	
	
	wire clock;
	fdiv FDVI1 (.clkin(CLOCK_50),.divisor(SW[4:0]),.clkout(clock));
	
	wire clockCPU;
	always @(posedge clock)
		clockCPU=~clockCPU;
		
	
	wire [31:0] regout, pc, instr;
	wire [31:0] in;
	
	Uniciclo UNI1 (.clockCPU(clockCPU), .clockMem(clock), .reset(~KEY[0]), 
						.PC(pc), .Instr(instr), .regin(SW[9:5]), .regout(regout));
	
	always @(*)
		begin
		if(~KEY[1])
			in<=pc;
		else
			if(~KEY[2])
				in<=instr;
			else
				in<=regout;	
		end
	


	decoder7 D0 (.In(in[3:0]),.Out(HEX0));
	decoder7 D1 (.In(in[7:4]),.Out(HEX1));
	decoder7 D2 (.In(in[11:8]),.Out(HEX2));
	decoder7 D3 (.In(in[15:12]),.Out(HEX3));
	decoder7 D4 (.In(in[19:16]),.Out(HEX4));
	decoder7 D5 (.In(in[23:20]),.Out(HEX5));
	
endmodule
	
	