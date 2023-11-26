`ifndef PARAM
	`include "../Parametros.v"
`endif

module Break_Interface(
    input         iCLK,
	 input 			iEbreak,
	 input	[3:0]	iKEY,
    input         Reset,
    output logic  oBreak
);




// Precisa ser no negedge quando o PC já estiver estável e a instrução não executada
always @ ( negedge iCLK or posedge Reset or negedge iKEY[2] ) begin		// Acionamento dos break points	
	if (Reset || ~iKEY[2])
		oBreak <= 1'b0;
	else
		if (iEbreak)
			oBreak <= 1'b1;
		else
			oBreak <= 1'b0;
end


endmodule
