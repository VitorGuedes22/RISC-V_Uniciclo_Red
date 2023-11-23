parameter 
	/* Parâmetros gerais */
	ON          		= 1'b1,
	OFF         		= 1'b0,
	ZERO        		= 32'h00000000,
	
	/* Operações da ULA */
	OP_AND				= 3'b000,
	OP_OR		   		= 3'db001,
	OP_ADD				= 3'b010,
	OP_SUB				= 3'b011,
	OP_SLT				= 3'b100,
	OP_XOR				= 3'b101,
	OP_NULL	   		= 3'b111, // saída ZERO
	
	/* Opcodes */
	OPC_LOAD       	= 7'b0000011,
	OPC_R_IMM     		= 7'b0010011,
	OPC_STORE      	= 7'b0100011,
	OPC_R        		= 7'b0110011,
	OPC_B            	= 7'b1100011,
	OPC_JAL        	= 7'b1101111,
	
	/* Funct7 */
	FUNCT7_ADD			= 7'b0000000,
   FUNCT7_SUB        = 7'b0100000,
	FUNCT7_SLT			= 7'b0000000,
	FUNCT7_XOR			= 7'b0000000,
	FUNCT7_OR			= 7'b0000000,
	FUNCT7_AND			= 7'b0000000,
	
	/* Funct3 */	
	
	FUNCT3_ADD			= 3'b000,
	FUNCT3_SUB			= 3'b000,
	FUNCT3_SLT			= 3'b010,
	FUNCT3_XOR			= 3'b100,
	FUNCT3_OR			= 3'b110,
	FUNCT3_AND			= 3'b111,
	FUNCT3_ADDI			= 3'b001,
	FUNCT3_ANDI			= 3'b111,
	FUNCT3_ORI			= 3'b100,
	FUNCT3_XORI			= 3'b010,
	
	/* Endereços */
	BEGINNING_TEXT    = 32'h0040_0000,
	TEXT_WIDTH			= 14+2,					// 16384 words = 16384x4 = 64ki bytes	 
   END_TEXT          = (BEGINNING_TEXT + 2**TEXT_WIDTH) - 1,	 

	 
   BEGINNING_DATA1   = 32'h1001_0000,
	DATA_WIDTH1			= 15+2,					// 32768 words = 32768x4 = 128ki bytes
   END_DATA1         = (BEGINNING_DATA1 + 2**DATA_WIDTH1) - 1,	 

	 
   BEGINNING_DATA2   = END_DATA1 + 1,
	DATA_WIDTH2			= 13+2,					// 8192 words = 8192x4 = 32ki bytes
   END_DATA2         = (BEGINNING_DATA2 + 2**DATA_WIDTH2) - 1,	

	BEGINNING_DATA		= BEGINNING_DATA1,
	END_DATA				= END_DATA2,
	 
	STACK_ADDRESS     = END_DATA-3,
	
	
	BEGINNING_IODEVICES         = 32'hFF00_0000,
	 
   BEGINNING_VGA0              = 32'hFF00_0000,
   END_VGA0                    = 32'hFF01_2C00,  // 320 x 240 = 76800 bytes

   BEGINNING_VGA1              = 32'hFF10_0000,
   END_VGA1                    = 32'hFF11_2C00,  // 320 x 240 = 76800 bytes	 
	 
	FRAMESELECT					  = 32'hFF20_0604,  // Frame Select register 0 ou 1
	 
	KDMMIO_CTRL_ADDRESS		     = 32'hFF20_0000,	// Para compatibilizar com o KDMMIO
	KDMMIO_DATA_ADDRESS		  	  = 32'hFF20_0004,
	 
	BUFFER0_TECLADO_ADDRESS     = 32'hFF20_0100,
   BUFFER1_TECLADO_ADDRESS     = 32'hFF20_0104,
	 
   TECLADOxMOUSE_ADDRESS       = 32'hFF20_0110,
   BUFFERMOUSE_ADDRESS         = 32'hFF20_0114,
	 
	RS232_READ_ADDRESS          = 32'hFF20_0120,
   RS232_WRITE_ADDRESS         = 32'hFF20_0121,
   RS232_CONTROL_ADDRESS       = 32'hFF20_0122,
	  
	AUDIO_INL_ADDRESS           = 32'hFF20_0160,
   AUDIO_INR_ADDRESS           = 32'hFF20_0164,
   AUDIO_OUTL_ADDRESS          = 32'hFF20_0168,
   AUDIO_OUTR_ADDRESS          = 32'hFF20_016C,
   AUDIO_CTRL1_ADDRESS         = 32'hFF20_0170,
   AUDIO_CRTL2_ADDRESS         = 32'hFF20_0174,

   NOTE_SYSCALL_ADDRESS        = 32'hFF20_0178,
   NOTE_CLOCK                  = 32'hFF20_017C,
   NOTE_MELODY                 = 32'hFF20_0180,
   MUSIC_TEMPO_ADDRESS         = 32'hFF20_0184,
   MUSIC_ADDRESS               = 32'hFF20_0188,      // Endereco para uso do Controlador do sintetizador
   PAUSE_ADDRESS               = 32'hFF20_018C,

	ADC_CH0_ADDRESS				 = 32'hFF20_0200,			// Canais do Conversor Analogico-Digital
	ADC_CH1_ADDRESS				 = 32'hFF20_0204,
	ADC_CH2_ADDRESS				 = 32'hFF20_0208,
	ADC_CH3_ADDRESS				 = 32'hFF20_020C,
	ADC_CH4_ADDRESS				 = 32'hFF20_0210,
	ADC_CH5_ADDRESS				 = 32'hFF20_0214,
	ADC_CH6_ADDRESS				 = 32'hFF20_0218,
	ADC_CH7_ADDRESS				 = 32'hFF20_021C,
	
	IRDA_DECODER_ADDRESS		 = 32'hFF20_0500,
	IRDA_CONTROL_ADDRESS       = 32'hFF20_0504, 	 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
	IRDA_READ_ADDRESS          = 32'hFF20_0508,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
   IRDA_WRITE_ADDRESS         = 32'hFF20_050C,		 	// Relatorio questao B.10) - Grupo 2 - (2/2016)
   
	STOPWATCH_ADDRESS			 = 32'hFF20_0510,	 		//Feito em 2/2016 para servir de cronometro
	 
	LFSR_ADDRESS					 = 32'hFF20_0514,			// Gerador de numeros aleatorios
	 
	KEYMAP0_ADDRESS				 = 32'hFF20_0520,			// Mapa do teclado 2017/2
	KEYMAP1_ADDRESS				 = 32'hFF20_0524,
	KEYMAP2_ADDRESS				 = 32'hFF20_0528,
	KEYMAP3_ADDRESS				 = 32'hFF20_052C,
	
	BREAK_ADDRESS					 = 32'hFF20_0600,  	  // Buffer do endereço do Break Point
	 
	TIMERLOW_ADDRESS				 = 32'hFF20_0700,			// Timer de 64 bits, compatibilidade com o Timer Tool/Rars
	TIMERHIGH_ADDRESS			 = 32'hFF20_0704,
	INTERLOW_ADDRESS				 = 32'hFF20_0708,			// Tempo para gerar uma interrupcao
	INTERHIGH_ADDRESS			 = 32'hFF20_070C,	 
	DIVIDER_ADDRESS				 = 32'hFF20_0710,			// chaves do divisor de frequencias
	 