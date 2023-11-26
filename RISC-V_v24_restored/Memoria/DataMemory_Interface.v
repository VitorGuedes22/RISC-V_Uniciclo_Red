`ifndef PARAM
	`include "../Parametros.v"
`endif

module DataMemory_Interface (
    input wire      			iCLK, iCLKMem,
    //  Barramento de IO
    input wire       	 	wReadEnable, wWriteEnable,
    input wire		[3:0]  	wByteEnable,
    input wire		[31:0] 	wAddress, wWriteData,
    output [31:0] 	wReadData
);


    wire        wMemWriteMB0,wMemReadMB0;
    wire [31:0] wMemDataMB0;
    wire        wMemWriteMB1,wMemReadMB1;
    wire [31:0] wMemDataMB1;
    wire        is_usermem, is_usermem2;
    wire [31:0] usermem_add, usermem_add2;
	 
UserDataBlock MB0 (
    .address(usermem_add[DATA_WIDTH1-1:2]), // Memoria em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWriteMB0),
	 .rden(wMemReadMB0),
    .q(wMemDataMB0)
);


UserDataBlock2 MB1 (
    .address(usermem_add2[DATA_WIDTH2-1:2]), // Memoria em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWriteMB1),
	 .rden(wMemReadMB1),
    .q(wMemDataMB1)
);


    reg MemWritten;
    initial MemWritten <= 1'b0;
    always @(iCLK) MemWritten <= iCLK;
					

    assign is_usermem 	= wAddress >= BEGINNING_DATA1  &&  wAddress <= END_DATA1;       // Memoria usuario  .data
	 assign is_usermem2 	= wAddress >= BEGINNING_DATA2  &&  wAddress <= END_DATA2;       // Memoria2 usuario  .data
	 
	 assign usermem_add 	= wAddress - BEGINNING_DATA1;
	 assign usermem_add2 = wAddress - BEGINNING_DATA2;

	 assign wMemReadMB0  = wReadEnable  && is_usermem;
	 assign wMemReadMB1  = wReadEnable  && is_usermem2;
	 
   assign wMemWriteMB0 	= ~MemWritten && wWriteEnable && is_usermem;              // Controle de escrita no MB0
	assign wMemWriteMB1 	= ~MemWritten && wWriteEnable && is_usermem2;              // Controle de escrita no MB1
//	 assign wMemWriteMB0 = wWriteEnable && is_usermem;
 
    always @(*)
        if(wReadEnable)
            begin
                if(is_usermem)   wReadData <= wMemDataMB0; else
					 if(is_usermem2)  wReadData <= wMemDataMB1; else
                wReadData <= 32'hzzzzzzzz;
            end
        else
            wReadData <= 32'hzzzzzzzz;

endmodule
