`timescale 1ns/1ns

`define nop 32'b00100000000000000000000000000000



module data_path(
	clk,
	rst,
	RegDst_in,
	Jmp_in,
	DataC_in,
	RegWrite_in,
	AluSrc_in,
	AluSrc1_in,	//added
	Branch_in,
	bne_in, 		//added
	MemRead_in,
	MemWrite_in,
	MemtoReg_in,
	AluOperation_in,
	func,
	opcode,
	out1,
	out2,

	RegDst_in_ln1,
	Jmp_in_ln1,
	DataC_in_ln1,
	RegWrite_in_ln1,
	AluSrc_in_ln1,
	AluSrc1_in_ln1,	//added
	Branch_in_ln1,
	bne_in_ln1, 		//added
	MemRead_in_ln1,
	MemWrite_in_ln1,
	MemtoReg_in_ln1,
	AluOperation_in_ln1,
	func_ln1,
	opcode_ln1

	);

	input 					clk,rst;
	input       [1:0]		RegDst_in,Jmp_in;
	input 					DataC_in,RegWrite_in,AluSrc_in,Branch_in,MemRead_in,MemWrite_in,MemtoReg_in;
	input       [5:0]		AluOperation_in;
	input		[1:0]		AluSrc1_in;	//added
	input					bne_in;		//added
	output      [5:0] 		func,opcode;
	output wire [31:0] 		out1,out2;


	input       [1:0]		RegDst_in_ln1,Jmp_in_ln1;
	input 					DataC_in_ln1,RegWrite_in_ln1,AluSrc_in_ln1,Branch_in_ln1,MemRead_in_ln1,MemWrite_in_ln1,MemtoReg_in_ln1;
	input       [5:0]		AluOperation_in_ln1;
	input		[1:0]		AluSrc1_in_ln1;	//added
	input					bne_in_ln1;		//added
	output	    [5:0] 		func_ln1,opcode_ln1;

	wire        [31:0] 		instruction1,write_data_reg_ln1,read_data1_reg_ln1,read_data2_reg_ln1,mem_read_data_ln1,
							inst_extended_ln1,alu_input2_ln1,alu_result_ln1,read_data_mem_ln1,shifted_inst_extended_ln1,out_adder2_ln1,out_branch_ln1;
	wire		[31:0]		data1_alu_ln1;	//added
	wire 		[4:0] 		write_reg_ln1;
	wire 		[25:0] 		shl2_inst_ln1;
	wire 					and_z_b_ln1,zero_ln1;
	wire					bne_o_ln1; //added
	

	wire       [1:0]		RegDst_ln1,Jmp_ln1;
	wire 					DataC_ln1,RegWrite1_ln1,AluSrc_ln1,Branch_ln1,MemtoReg_ln1;
	wire       [5:0]		AluOperation_ln1;
	wire		[1:0]		AluSrc1_ln1;	//added
	wire					bne_ln1;		//added

	wire [31:0] instruction_F_ln1;
	wire [206:0] EX_ln1;
	wire [197:0] MEM_ln1;
	wire [100:0] WB_ln1;



	wire        [31:0] 		in_pc,out_pc,instruction,write_data_reg,read_data1_reg,read_data2_reg,pc_adder,mem_read_data,
							inst_extended,alu_input2,alu_result,read_data_mem,shifted_inst_extended,out_adder2,out_branch;
	wire		[31:0]		data1_alu;	//added
	wire 		[4:0] 		write_reg;
	wire 		[25:0] 		shl2_inst;
	wire 					and_z_b,zero;
	wire					bne_o; //added
	

	wire       [1:0]		RegDst,Jmp;
	wire 					DataC,RegWrite,AluSrc,Branch,MemRead,MemWrite,MemtoReg;
	wire       [5:0]		AluOperation;
	wire		[1:0]		AluSrc1;	//added
	wire					bne;		//added

	wire [31:0] pc_adder_F, instruction_F;
	wire [206:0] EX;
	wire [197:0] MEM;
	wire [100:0] WB;

	wire [31:0] ID_EX_INST_out_ln1,EX_MEM_INST_out_ln1,MEM_WB_INST_out_ln1;
	wire stall,stall_outer_dependent,flush;
	wire [1:0] swap1,swap2;
	wire [31:0] ID_EX_INST_out_ln2,EX_MEM_INST_out_ln2,MEM_WB_INST_out_ln2;
	wire [31:0] IF_ID_out;
	wire [31:0] IF_ID_ln1_out;


	pc PC(.clk(clk),.rst(rst), .en((~stall) ? 1'b1 : 1'b0), .in(in_pc),.out(out_pc));

	adder adder_of_pc(.clk(clk),.data1(out_pc),.data2(32'd8),.sum(pc_adder_F));

	inst_memory InstMem(.clk(clk),.rst(rst),.adr(out_pc),.instruction1(instruction_F_ln1),.instruction2(instruction_F));

	reg_file RegFile(.clk(clk),.rst(rst),.RegWrite2(RegWrite),.read_reg3(instruction[25:21]),.read_reg4(instruction[20:16]),
					 .write_reg2(WB[4:0]),.write_data2(write_data_reg),.read_data3(read_data1_reg),.read_data4(read_data2_reg),
					 .RegWrite1(RegWrite1_ln1),.read_reg1(instruction1[25:21]),.read_reg2(instruction1[20:16]),
					 .write_reg1(WB_ln1[4:0]),.write_data1(write_data_reg_ln1),.read_data1(read_data1_reg_ln1),.read_data2(read_data2_reg_ln1));


	//line 2

	adder adder2(.clk(clk),.data1(shifted_inst_extended),.data2(EX[174:143]),.sum(out_adder2));

	alu ALU(.clk(clk),.data1(data1_alu),.data2(alu_input2),.alu_op(AluOperation),.alu_result(alu_result),.zero_flag(zero));


	data_memory data_mem(.clk(clk),.rst(rst),.mem_read(MemRead),.mem_write(MemWrite),.adr(MEM[100:69]),
						 .write_data(MEM[68:37]),.read_data(read_data_mem),.out1(out1),.out2(out2)); 

	mux3_to_1 #5 mux3_reg_file(.clk(clk),.data1(EX[9:5]),.data2(EX[4:0]),.data3(5'd31),.sel(RegDst),.out(write_reg));

	mux3_to_1 #32 alu_mux1(.clk(clk), .data1(EX[142:111]), .data2({27'b0,EX[14:10]}), .data3(32'd16), .sel(AluSrc1), .out(data1_alu));

	assign bne_o = bne ^ MEM[101];
	assign and_z_b=bne_o & Branch;

	mux2_to_1 #32 mux2_reg_file(.clk(clk),.data1(mem_read_data),.data2(WB[36:5]),.sel(DataC),.out(write_data_reg));

	mux2_to_1 #32 alu_mux(.clk(clk),.data1(EX[110:79]),.data2(EX[46:15]),.sel(AluSrc),.out(alu_input2));

	mux2_to_1 #32 mux_of_mem(.clk(clk),.data1(WB[68:37]),.data2(WB[100:69]),.sel(MemtoReg),.out(mem_read_data));
	
	sign_extension sign_ext(.clk(clk),.primary(instruction[15:0]),.extended(inst_extended));

	shl2 #26 shl2_1(.clk(clk),.adr(instruction[25:0]),.sh_adr(shl2_inst));

	shl2 #32 shl2_of_adder2(.clk(clk),.adr(EX[46:15]),.sh_adr(shifted_inst_extended));

	assign func=instruction[5:0];

	assign opcode=instruction[31:26];

	assign instruction = stall_outer_dependent ? `nop : (swap2 == 2'b01)? IF_ID_ln1_out : (swap2 == 2'b10) ? `nop : IF_ID_out;

	register #64 IF_ID(.clk(clk),.rst(rst), .en(~stall), .din(flush? {pc_adder_F,`nop} : {pc_adder_F,instruction_F}), .dout({pc_adder,IF_ID_out}));
	register #207 ID_EX(.clk(clk),.rst(rst), .en(1'b1), .din({{pc_adder[31:26],shl2_inst},pc_adder,read_data1_reg,read_data2_reg,pc_adder,inst_extended,instruction[10:6],instruction[20:16],instruction[15:11]}), 
	.dout({EX[206:175],EX[174:143],EX[142:111],EX[110:79],EX[78:47],EX[46:15],EX[14:10],EX[9:5],EX[4:0]}));
	register #198 EX_MEM(.clk(clk),.rst(rst), .en(1'b1), .din({EX[142:111],EX[206:175],out_adder2,zero,alu_result,EX[110:79],EX[78:47],write_reg}), .dout({MEM[197:166],MEM[165:134],MEM[133:102],MEM[101],MEM[100:69],MEM[68:37],MEM[36:5],MEM[4:0]}));
	register #101 MEM_WB(.clk(clk),.rst(rst), .en(1'b1), .din({read_data_mem,MEM[100:69],MEM[36:5],MEM[4:0]}), .dout({WB[100:69],WB[68:37],WB[36:5],WB[4:0]}));

	wire DataC_EX,RegWrite_EX,MemRead_EX,MemWrite_EX,MemtoReg_EX, Branch_EX,bne_EX;
	wire [1:0]Jmp_EX;

	register #20 ID_EX_CNTRL(.clk(clk),.rst(rst|flush), .en(1'b1), .din({RegDst_in,Jmp_in,DataC_in,RegWrite_in,AluSrc_in,Branch_in,MemRead_in,MemWrite_in,
	MemtoReg_in,AluOperation_in,AluSrc1_in,bne_in}), .dout({RegDst,Jmp_EX,DataC_EX,RegWrite_EX,AluSrc,Branch_EX,MemRead_EX,MemWrite_EX,MemtoReg_EX,
	AluOperation,AluSrc1,bne_EX}));
	
	wire DataC_MEM,RegWrite_MEM,MemtoReg_MEM;

	register #9 EX_MEM_CNTRL(.clk(clk),.rst(rst|flush), .en(1'b1), .din({DataC_EX,RegWrite_EX,MemRead_EX,MemWrite_EX,MemtoReg_EX,Branch_EX,bne_EX,Jmp_EX}), .dout({DataC_MEM,RegWrite_MEM,
	MemRead,MemWrite,MemtoReg_MEM,Branch,bne,Jmp}));

	register #3 MEM_WB_CNTRL(.clk(clk),.rst(rst|flush), .en(1'b1), .din({DataC_MEM,RegWrite_MEM,MemtoReg_MEM}), .dout({DataC,RegWrite,MemtoReg}));



	
	//line 1
	
	adder adder2_ln1(.clk(clk),.data1(shifted_inst_extended_ln1),.data2(EX_ln1[174:143]),.sum(out_adder2_ln1));

	alu ALU_ln1(.clk(clk),.data1(data1_alu_ln1),.data2(alu_input2_ln1),.alu_op(AluOperation_ln1),.alu_result(alu_result_ln1),.zero_flag(zero_ln1));

	mux3_to_1 #5 mux3_reg_file_ln1(.clk(clk),.data1(EX_ln1[9:5]),.data2(EX_ln1[4:0]),.data3(5'd31),.sel(RegDst_ln1),.out(write_reg_ln1));

	mux3_to_1 #32 mux3_jmp_ln1(.clk(clk),.data1(out_branch_ln1),.data2(MEM_ln1[165:134]),.data3(MEM_ln1[197:166]),.sel(Jmp_ln1),.out(in_pc));

	mux3_to_1 #32 alu_mux1_ln1(.clk(clk), .data1(EX_ln1[142:111]), .data2({27'b0,EX_ln1[14:10]}), .data3(32'd16), .sel(AluSrc1_ln1), .out(data1_alu_ln1));

	assign bne_o_ln1 = bne_ln1 ^ MEM_ln1[101];
	assign and_z_b_ln1=bne_o_ln1 & Branch_ln1;

	mux2_to_1 #32 mux2_reg_file_ln1(.clk(clk),.data1(mem_read_data_ln1),.data2(WB_ln1[36:5]),.sel(DataC_ln1),.out(write_data_reg_ln1));

	mux2_to_1 #32 alu_mux_ln1(.clk(clk),.data1(EX_ln1[110:79]),.data2(EX_ln1[46:15]),.sel(AluSrc_ln1),.out(alu_input2_ln1));

	mux2_to_1 #32 mux_of_mem_ln1(.clk(clk),.data1(WB_ln1[68:37]),.data2(WB_ln1[100:69]),.sel(MemtoReg_ln1),.out(mem_read_data_ln1));

	mux2_to_1 #32 mux2_branch_ln1(.clk(clk),.data1(pc_adder_F),.data2(MEM_ln1[133:102]),.sel(and_z_b_ln1),.out(out_branch_ln1));
	
	sign_extension sign_ext_ln1(.clk(clk),.primary(instruction1[15:0]),.extended(inst_extended_ln1));

	shl2 #26 shl2_1_ln1(.clk(clk),.adr(instruction1[25:0]),.sh_adr(shl2_inst_ln1));

	shl2 #32 shl2_of_adder2_ln1(.clk(clk),.adr(EX_ln1[46:15]),.sh_adr(shifted_inst_extended_ln1));

	assign func_ln1=instruction1[5:0];

	assign opcode_ln1=instruction1[31:26];

	assign instruction1 = stall_outer_dependent ? `nop : (swap1 == 2'b01)? IF_ID_out : (swap1 == 2'b10) ? `nop : IF_ID_ln1_out;

	register #64 IF_ID_ln1(.clk(clk),.rst(rst), .en(~stall), .din(flush?{pc_adder_F,`nop}:{pc_adder_F,instruction_F_ln1}), .dout({pc_adder,IF_ID_ln1_out}));

	register #207 ID_EX_ln1(.clk(clk),.rst(rst), .en(1'b1), .din({{pc_adder[31:26],shl2_inst_ln1},pc_adder,read_data1_reg_ln1,read_data2_reg_ln1,pc_adder,
                                                                  inst_extended_ln1,instruction1[10:6],instruction1[20:16],instruction1[15:11]}), 
	                                                              .dout({EX_ln1[206:175],EX_ln1[174:143],EX_ln1[142:111],EX_ln1[110:79],EX_ln1[78:47],
                                                                  EX_ln1[46:15],EX_ln1[14:10],EX_ln1[9:5],EX_ln1[4:0]}));

	register #198 EX_MEM_ln1(.clk(clk),.rst(rst), .en(1'b1), .din({EX_ln1[142:111],EX_ln1[206:175],out_adder2_ln1,zero_ln1,alu_result_ln1,EX_ln1[110:79],EX_ln1[78:47],write_reg_ln1}),
                         .dout({MEM_ln1[197:166],MEM_ln1[165:134],MEM_ln1[133:102],MEM_ln1[101],MEM_ln1[100:69],MEM_ln1[68:37],MEM_ln1[36:5],MEM_ln1[4:0]}));


	register #101 MEM_WB_ln1(.clk(clk),.rst(rst), .en(1'b1), .din({32'd0,MEM_ln1[100:69],MEM_ln1[36:5],MEM_ln1[4:0]}), .dout({WB_ln1[100:69],WB_ln1[68:37],WB_ln1[36:5],WB_ln1[4:0]}));

	wire DataC_EX_ln1,RegWrite_EX_ln1,MemRead_EX_ln1,MemWrite_EX_ln1,MemtoReg_EX_ln1, Branch_EX_ln1,bne_EX_ln1;
	wire [1:0]Jmp_EX_ln1;

	register #20 ID_EX_CNTRL_ln1(.clk(clk),.rst(rst | flush), .en(1'b1), .din({RegDst_in_ln1,Jmp_in_ln1,DataC_in_ln1,RegWrite_in_ln1,AluSrc_in_ln1,Branch_in_ln1,MemRead_in_ln1,MemWrite_in_ln1,
	MemtoReg_in_ln1,AluOperation_in_ln1,AluSrc1_in_ln1,bne_in_ln1}), .dout({RegDst_ln1,Jmp_EX_ln1,DataC_EX_ln1,RegWrite_EX_ln1,AluSrc_ln1,Branch_EX_ln1,MemRead_EX_ln1,MemWrite_EX_ln1,MemtoReg_EX_ln1,
	AluOperation_ln1,AluSrc1_ln1,bne_EX_ln1}));
	
	wire DataC_MEM_ln1,RegWrite_MEM_ln1,MemtoReg_MEM_ln1,blank;

	register #9 EX_MEM_CNTRL_ln1(.clk(clk),.rst(rst), .en(1'b1), .din({DataC_EX_ln1,RegWrite_EX_ln1,MemRead_EX_ln1,MemWrite_EX_ln1,MemtoReg_EX_ln1,Branch_EX_ln1,bne_EX_ln1,Jmp_EX_ln1}), 
								 .dout({DataC_MEM_ln1,RegWrite_MEM_ln1, blank, blank,MemtoReg_MEM_ln1,Branch_ln1,bne_ln1,Jmp_ln1}));


	register #3 MEM_WB_CNTRL_ln1(.clk(clk),.rst(rst), .en(1'b1), .din({DataC_MEM_ln1,RegWrite_MEM_ln1,MemtoReg_MEM_ln1}), .dout({DataC_ln1,RegWrite1_ln1,MemtoReg_ln1}));





	issueLogic isLogic(clk,rst, IF_ID_ln1_out,ID_EX_INST_out_ln1, EX_MEM_INST_out_ln1, MEM_WB_INST_out_ln1, and_z_b_ln1, Jmp_ln1, 
					   IF_ID_out,ID_EX_INST_out_ln2, EX_MEM_INST_out_ln2, MEM_WB_INST_out_ln2,stall,stall_outer_dependent, flush, swap1,swap2);


	register #32 ID_EX_INST_ln1(.clk(clk),.rst(rst), .en(1'b1), .din(flush? `nop : instruction1), .dout(ID_EX_INST_out_ln1));
	register #32 EX_MEM_INST_ln1(.clk(clk),.rst(rst), .en(1'b1), .din(flush? `nop :ID_EX_INST_out_ln1), .dout(EX_MEM_INST_out_ln1));
	register #32 MEM_WB_INST_ln1(.clk(clk),.rst(rst), .en(1'b1), .din(EX_MEM_INST_out_ln1), .dout(MEM_WB_INST_out_ln1));


	register #32 ID_EX_INST_ln2(.clk(clk),.rst(rst), .en(1'b1), .din(flush? `nop :instruction), .dout(ID_EX_INST_out_ln2));
	register #32 EX_MEM_INST_ln2(.clk(clk),.rst(rst), .en(1'b1), .din(flush? `nop :ID_EX_INST_out_ln2), .dout(EX_MEM_INST_out_ln2));
	register #32 MEM_WB_INST_ln2(.clk(clk),.rst(rst), .en(1'b1), .din(flush? `nop :EX_MEM_INST_out_ln2), .dout(MEM_WB_INST_out_ln2));
	
	


endmodule
