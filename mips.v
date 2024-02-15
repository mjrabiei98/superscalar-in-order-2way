module mips(
	clk,
	rst,
	out1,
	out2
	);
	input 					clk,rst;
	output wire [31:0] 		out1,out2;

	wire 		[5:0] 		opcode,func;
	wire 		[1:0]		RegDst,Jmp;
	wire 					DataC,Regwrite,AluSrc,Branch,MemRead,MemWrite,MemtoReg;
	wire 		[5:0]		AluOperation;
	wire		[1:0]		AluSrc1;	//added
	wire					bne;		//added


	wire 		[5:0] 		opcode_ln1,func_ln1;
	wire 		[1:0]		RegDst_ln1,Jmp_ln1;
	wire 					DataC_ln1,Regwrite_ln1,AluSrc_ln1,Branch_ln1,MemRead_ln1,MemWrite_ln1,MemtoReg_ln1;
	wire 		[5:0]		AluOperation_ln1;
	wire		[1:0]		AluSrc1_ln1;	//added
	wire					bne_ln1;		//added



	controller CU2(.clk(clk),.rst(rst),.opcode(opcode),.func(func),.RegDst(RegDst),.Jmp(Jmp),
	              .DataC(DataC),.Regwrite(Regwrite),.AluSrc(AluSrc),.Branch(Branch),.MemRead(MemRead),.MemWrite(MemWrite),
				  .MemtoReg(MemtoReg),.AluOperation(AluOperation), .AluSrc1(AluSrc1), .bne(bne));

	controller CU1(.clk(clk),.rst(rst),.opcode(opcode_ln1),.func(func_ln1),.RegDst(RegDst_ln1),.Jmp(Jmp_ln1),
	              .DataC(DataC_ln1),.Regwrite(Regwrite_ln1),.AluSrc(AluSrc_ln1),.Branch(Branch_ln1),.MemRead(MemRead_ln1),.MemWrite(MemWrite_ln1),
				  .MemtoReg(MemtoReg_ln1),.AluOperation(AluOperation_ln1), .AluSrc1(AluSrc1_ln1), .bne(bne_ln1));

	data_path DP(.clk(clk),.rst(rst),.RegDst_in(RegDst),.Jmp_in(Jmp),.DataC_in(DataC),.RegWrite_in(Regwrite),.AluSrc_in(AluSrc),
				 .Branch_in(Branch),.MemRead_in(MemRead),.MemWrite_in(MemWrite),.MemtoReg_in(MemtoReg),.AluOperation_in(AluOperation),
		         .func(func),.opcode(opcode),.out1(out1),.out2(out2), .AluSrc1_in(AluSrc1), .bne_in(bne),
				 
				 .RegDst_in_ln1(RegDst_ln1),.Jmp_in_ln1(Jmp_ln1),.DataC_in_ln1(DataC_ln1),.RegWrite_in_ln1(Regwrite_ln1),.AluSrc_in_ln1(AluSrc_ln1),
				 .Branch_in_ln1(Branch_ln1),.MemRead_in_ln1(MemRead_ln1),.MemWrite_in_ln1(MemWrite_ln1),.MemtoReg_in_ln1(MemtoReg_ln1),.AluOperation_in_ln1(AluOperation_ln1),
		         .func_ln1(func_ln1),.opcode_ln1(opcode_ln1), .AluSrc1_in_ln1(AluSrc1_ln1), .bne_in_ln1(bne_ln1)
				 );
endmodule