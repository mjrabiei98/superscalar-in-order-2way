//opcodes
`define	 RT 	6'b000000
`define	 addi 	6'b001000	//changed
`define	 addiu	6'b001001 //added
`define	 andi 	6'b001100	//added
`define	 lui 	6'b001111	//added
`define	 ori 	6'b001101	//added
`define	 slti 	6'b001010
`define	 sltiu 	6'b001011	//added
`define	 xori 	6'b001110	//added
`define	 lw 	6'b100011	//changed
`define	 sw 	6'b101011	//changed
`define	 beq 	6'b000100	//changed
`define	 bne 	6'b000101	//added
`define	 j 		6'b000010		//changed
`define	 jal 	6'b000011	//changed
//`define jr 6'b001000	//put in R type

//funcs
`define add_func 6'b100000
`define addu_func 6'b100001
`define and_func 6'b100100
`define nor_func 6'b100111
`define or_func 6'b100101
`define slt_func 6'b101010
`define sltu_func 6'b101011
`define sub_func 6'b100010
`define subu_func 6'b100011
`define xor_func 6'b100110
`define sll_func 6'b000000
`define sllv_func 6'b000100
`define srl_func 6'b000010
`define srlv_func 6'b000110
`define jalr_func 6'b001001
`define jr_func 6'b001000




module controller(
	clk,
	rst,
	opcode,
	func,
	RegDst,
	Jmp,
	DataC,
	Regwrite,
	AluSrc,
	AluSrc1,	//added
	Branch,
	bne,		//added
	MemRead,
	MemWrite,
	MemtoReg,
	AluOperation
	);
	input 				clk,rst;
	input      [5:0] 	opcode,func;
	output reg [1:0]	RegDst,Jmp;
	output reg		    DataC,Regwrite,AluSrc,Branch,MemRead,MemWrite,MemtoReg;
	output reg [5:0]    AluOperation;	//changed
	output reg [1:0]	AluSrc1; 	//added
	output reg				bne; 	//added
	always@(opcode,func) begin
		    {RegDst,Jmp,DataC,Regwrite,AluSrc,Branch,MemRead,MemWrite,MemtoReg,AluOperation,AluSrc1, bne}=0;
			case(opcode) 
				`RT: begin
					if(func == `jalr_func) begin //jalr
						RegDst=2'b10;
						DataC=1;
						Regwrite=1;
						Jmp=2'b10;
					end	
					else if(func == `jr_func) begin	//jr
						Jmp=2'b10;
					end
					else if(func == `sll_func) begin
						RegDst=2'b01;
						Regwrite=1;
						AluSrc1 = 2'b01;
						AluOperation= `sllv_func;	//changed
					end
					else if(func == `srl_func) begin
						RegDst=2'b01;
						Regwrite=1;
						AluSrc1 = 2'b01;
						AluOperation= `srlv_func;	//changed
					end
					else begin
						RegDst=2'b01;
						Regwrite=1;
						AluOperation=func;	//changed							
					end	
				 end

				`addi: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `add_func;
				 end
				`addiu: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `addu_func;
				 end
				`andi: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `and_func;
				 end				 
				`lui: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `sllv_func;
					AluSrc1 = 2'b10;
				 end								
				`ori: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `or_func;
				 end				
				`slti: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `slt_func;
				 end					
				`sltiu: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `sltu_func;
				 end	
				`xori: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation= `xor_func;
				 end
				`beq: begin
					AluOperation= `sub_func;
					Branch=1;
				 end
				`bne: begin
					AluOperation= `sub_func;
					Branch=1;
					bne = 1'b1;
				 end			
				`j: begin
					Jmp=2'b01;
				 end
				`jal: begin
					RegDst=2'b10;
					DataC=1;
					Regwrite=1;
					Jmp=2'b01;
				 end
				`lw: begin
					Regwrite=1;
					AluSrc=1;
					AluOperation=`add_func;
					MemRead=1;
					MemtoReg=1;
				 end
				`sw: begin
					AluSrc=1;
					AluOperation=`add_func;
					MemWrite=1;
				 end

			endcase
	end
endmodule
