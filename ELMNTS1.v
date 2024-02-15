`timescale 1ns/1ns

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
`define sllv_func 6'b000100
`define srlv_func 6'b000110
`define jalr_func 6'b001001
`define jr_func 6'b001000

module mux3_to_1 #(parameter num_bit)(input clk,input [num_bit-1:0]data1,data2,data3, input [1:0]sel,output [num_bit-1:0]out);
	
	assign out=~sel[1] ? (sel[0] ? data2 : data1 ) : data3;	
endmodule

module mux2_to_1 #(parameter num_bit)(input clk,input [num_bit-1:0]data1,data2, input sel,output [num_bit-1:0]out);
	
	assign out=~sel?data1:data2;
endmodule

module sign_extension(input clk,input [15:0]primary, output [31:0] extended);

	assign extended=$signed(primary);
endmodule

module shl2 #(parameter num_bit)(input clk,input [num_bit-1:0]adr, output [num_bit-1:0]sh_adr);

	assign sh_adr=adr<<2;
endmodule

module alu(input clk,input [31:0]data1,data2, input [5:0]alu_op, output reg[31:0]alu_result, output zero_flag);
	
	always@(alu_op,data1,data2) begin
		alu_result=32'b0;
		case (alu_op)
			`add_func: alu_result = data1 + data2;
			`addu_func:	alu_result = data1 + data2;
			`and_func:	alu_result = data1 & data2;
			`nor_func:	alu_result = ~(data1 | data2);
			`or_func:	alu_result = (data1 | data2);
			`slt_func: begin
				if(data1[31] == data2[31]) alu_result = (data1<data2) ? 32'b1:32'b0;
				else alu_result = (data1[31]==1'b1) ? 32'b1 : 32'b0;
			end
			`sltu_func: alu_result = (data1<data2) ? 32'b1:32'b0;
			`sub_func: alu_result = data1 - data2;
			`subu_func: alu_result = data1 - data2;
			`xor_func: alu_result = data1 ^ data2;
			`sllv_func: alu_result = data2 << data1;
			`srlv_func: alu_result = data2 >> data1;


		endcase
	end
	assign zero_flag=(alu_result==32'b0) ? 1'b1:1'b0;
endmodule

module adder(input clk,input [31:0] data1,data2, output [31:0]sum);
	
	wire co;
	assign {co,sum}=data1+data2;
endmodule


module reg_file(input clk,rst,RegWrite1,RegWrite2,input [4:0] read_reg1,read_reg2,write_reg1,read_reg3,read_reg4,write_reg2,
				input [31:0]write_data1,write_data2,
				output [31:0]read_data1,read_data2,read_data3,read_data4);

	reg [31:0] register[0:31];
	integer i;
	always@(posedge clk,rst) begin
		if(rst) begin
			for(i=0;i<32;i=i+1) register[i]<=32'b0;
		end
		else begin
			if(RegWrite1) register[write_reg1]<=write_data1;
			if(RegWrite2) register[write_reg2]<=write_data2;
		end
	end
	assign read_data1=register[read_reg1];
	assign read_data2=register[read_reg2];
	assign read_data3=register[read_reg3];
	assign read_data4=register[read_reg4];
endmodule

module inst_memory(input clk,rst,input [31:0]adr,output [31:0]instruction1,instruction2);

	reg [31:0]mem_inst[0:255];
	initial begin
		$readmemb("inst.txt",mem_inst);
  	end
	assign instruction1=mem_inst[adr>>2];
	assign instruction2=mem_inst[(adr+4)>>2];
endmodule

module data_memory(input clk,rst,mem_read,mem_write,input [31:0]adr,write_data,output reg[31:0]read_data,
		   output [31:0] out1,out2);

	reg [31:0]mem_data[0:511];
	integer i,f;

	initial begin
		$readmemb("datamemory.txt",mem_data);
  	end

	always@(posedge clk) begin
		if(mem_write) mem_data[adr>>2]<=write_data;
	end

	always@(mem_read,adr) begin
		if(mem_read) read_data<=mem_data[adr>>2];
		else read_data<=32'b0;	
	end
	/*
	initial begin
		$writememb("datamemory.txt",mem_data); 
  	end
	*/

	initial begin
  		f = $fopen("datamemory.txt","w");
		for(i=0;i<512;i=i+1) begin
		$fwrite(f,"%b\n",mem_data[i]);
		end
		$fclose(f);  
	end

	assign out1=mem_data[500];
	assign out2=mem_data[501];
	
endmodule

module pc(input clk,rst,en, input [31:0]in,output reg[31:0]out);

	always @(posedge clk,rst) begin
		if(rst) out<=32'b0;
		else if (en) out<=in;
	end
endmodule

module register #(parameter num_bit)(input clk,rst, en, input [num_bit-1:0] din, output reg [num_bit-1:0] dout);
	always @(posedge clk,rst) begin
		if(rst)	dout = 200'b0;
		else if(en) dout = din;
	end
endmodule