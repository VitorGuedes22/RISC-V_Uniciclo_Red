`ifndef PARAM
	`include "../Parametros.v"
`endif

module Memory_Interface (
    input wire        		iCLK, iCLKMem,
    //  Barramento de IO
    input wire        		wReadEnable, wWriteEnable,
    input wire  	[3:0]  	wByteEnable,
    input wire 	[31:0] 	wAddress, wWriteData,
    output 	[31:0] 	wReadData
);


    wire        wMemWrite_UserCode, wMemWrite_UserData, wMemWrite_UserData2;
	 wire        wMemRead_UserCode, wMemRead_UserData, wMemRead_UserData2;
    wire [31:0] wMemData_UserCode, wMemData_UserData, wMemData_UserData2;
	 wire [31:0] usercode_add, userdata_add, userdata_add2;
    wire        is_usercode, is_userdata, is_userdata2;


UserCodeBlock UCodeMem (
    .address(usercode_add[TEXT_WIDTH-1:2]),           //em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWrite_UserCode),
	 .rden(wMemRead_UserCode),
    .q(wMemData_UserCode)
);


UserDataBlock UDataMem (
    .address(userdata_add[DATA_WIDTH1-1:2]),           //em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWrite_UserData),
	 .rden(wMemRead_UserData),
    .q(wMemData_UserData)
);

UserDataBlock2 UDataMem1 (
    .address(userdata_add2[DATA_WIDTH2-1:2]),           //em words
    .byteena(wByteEnable),
    .clock(iCLKMem),
    .data(wWriteData),
    .wren(wMemWrite_UserData2),
	 .rden(wMemRead_UserData2),
    .q(wMemData_UserData2)
);

    reg MemWritten;
    initial MemWritten <= 1'b0;
    always @(iCLK) MemWritten <= iCLK;
 

    assign is_usercode          	= wAddress >= BEGINNING_TEXT    &&  wAddress <= END_TEXT;
    assign is_userdata          	= wAddress >= BEGINNING_DATA1   &&  wAddress <= END_DATA1;
    assign is_userdata2          = wAddress >= BEGINNING_DATA2   &&  wAddress <= END_DATA2;
	 
	 assign usercode_add				= wAddress - BEGINNING_TEXT;
	 assign userdata_add				= wAddress - BEGINNING_DATA1;
	 assign userdata_add2			= wAddress - BEGINNING_DATA2;	 

	 assign wMemRead_UserCode   	= wReadEnable && is_usercode;
    assign wMemRead_UserData   	= wReadEnable && is_userdata;
    assign wMemRead_UserData2   	= wReadEnable && is_userdata2;
	 
    assign wMemWrite_UserCode   	= ~MemWritten && wWriteEnable && is_usercode;
    assign wMemWrite_UserData   	= ~MemWritten && wWriteEnable && is_userdata;
    assign wMemWrite_UserData2   = ~MemWritten && wWriteEnable && is_userdata2;
//    assign wMemWrite_UserCode   	= wWriteEnable && is_usercode;
//    assign wMemWrite_UserData   	= wWriteEnable && is_userdata;


    always @(*)
    if(wReadEnable)
        begin
            if(is_usercode)     wReadData <= wMemData_UserCode; else
            if(is_userdata)     wReadData <= wMemData_UserData; else
				if(is_userdata2)    wReadData <= wMemData_UserData2; else
            wReadData   <= 32'hzzzzzzzz;
        end
    else
        wReadData   <= 32'hzzzzzzzz;

endmodule
