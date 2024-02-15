
`timescale 1ns/1ns

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
`define  nop    6'b001000   //added




module issueLogic (input clk,rst, input [31:0] instruction_D1, instruction_E1, instruction_M1, instruction_WB1, input branch, input [1:0] jmp,
                          input [31:0] instruction_D2, instruction_E2, instruction_M2, instruction_WB2, output reg stall,stall_outer_dependent, flush, output reg [1:0] swap1,swap2);


    wire[5:0] ID_opcode1 = instruction_D1[31:26];
    wire[5:0] EX_opcode1 = instruction_E1[31:26];
    wire[5:0] MEM_opcode1 = instruction_M1[31:26];
    wire[5:0] WB_opcode1 = instruction_WB1[31:26];

    wire[4:0] rs_D1 = instruction_D1[25:21];
    wire[4:0] rt_D1 = instruction_D1[20:16];

    wire[5:0] ID_opcode2 = instruction_D2[31:26];
    wire[5:0] EX_opcode2 = instruction_E2[31:26];
    wire[5:0] MEM_opcode2 = instruction_M2[31:26];
    wire[5:0] WB_opcode2 = instruction_WB2[31:26];

    wire[4:0] rs_D2 = instruction_D2[25:21];
    wire[4:0] rt_D2 = instruction_D2[20:16];
    

    wire[4:0] ws_E1;
    assign ws_E1 = (EX_opcode1 == `RT) ? instruction_E1[15:11] : (EX_opcode1 == `lw | EX_opcode1 == `addi) ? instruction_E1[20:16] : 5'd0;

    wire[4:0] ws_M1;
    assign ws_M1 = (MEM_opcode1 == `RT) ? instruction_M1[15:11] : (MEM_opcode1 == `lw | MEM_opcode1 == `addi) ? instruction_M1[20:16] : 5'd0;

    wire[4:0] ws_W1;
    assign ws_W1 = (WB_opcode1 == `RT) ? instruction_WB1[15:11] : (WB_opcode1 == `lw | WB_opcode1 == `addi) ? instruction_WB1[20:16] : 5'd0;

    wire[4:0] ws_E2;
    assign ws_E2 = (EX_opcode2 == `RT) ? instruction_E2[15:11] : (EX_opcode2 == `lw | EX_opcode2 == `addi) ? instruction_E2[20:16] : 5'd0;

    wire[4:0] ws_M2;
    assign ws_M2 = (MEM_opcode2 == `RT) ? instruction_M2[15:11] : (MEM_opcode2 == `lw | MEM_opcode2 == `addi) ? instruction_M2[20:16] : 5'd0;

    wire[4:0] ws_W2;
    assign ws_W2 = (WB_opcode2 == `RT) ? instruction_WB2[15:11] : (WB_opcode2 == `lw | WB_opcode2 == `addi) ? instruction_WB2[20:16] : 5'd0;


    wire read_en1_ln1 = ((ID_opcode1 == `j) | (ID_opcode1 == `jal) | (ID_opcode1 == `nop))? 1'b0 : 1'b1;

    wire read_en2_ln1 = ((ID_opcode1 == `RT) | (ID_opcode1 == `sw ))? 1'b1 : 1'b0;


    // check do dastoore vared shode
    wire correct_place, dependent;
    wire[4:0] ws_D1;
    assign ws_D1 = (ID_opcode1 == `RT) ? instruction_D1[15:11] : (ID_opcode1 == `lw | ID_opcode1 == `addi) ? instruction_D1[20:16] : 5'd0;
    wire read_en1_ln2 = ((ID_opcode2 == `j) | (ID_opcode2 == `jal) | (ID_opcode2 == `nop))? 1'b0 : 1'b1;
    wire read_en2_ln2 = ((ID_opcode2 == `RT) | (ID_opcode2 == `sw ))? 1'b1 : 1'b0;

    assign correct_place = ((ID_opcode2 == `j ) | (ID_opcode2 == `beq) | (ID_opcode1 == `lw))? 1'b0 : 1'b1 ;
    assign dependent = (((rs_D2 == ws_D1) & (rs_D1 != 5'b00000)) | ((rt_D2 == ws_D1) & (rt_D1 != 5'b00000)))  ? 1'b1 : 1'b0; 


    // check dastoora ba state haye badi
    // age vabastegi dare ba dastoora badi pipe faghat bayad stall konim va nop bedim jelo ta un dastoora anjameshun tamum she
    wire dataDependent;

    assign dataDependent =
    (((((rs_D1 == ws_E1) | (rs_D1 == ws_M1) | (rs_D1 == ws_W1))  & (rs_D1 != 5'b00000)) | 
     (((rt_D1 == ws_E1) | (rt_D1 == ws_M1) | (rt_D1 == ws_W1))  & (rt_D1 != 5'b00000))) |
    ( ((((rs_D1 == ws_E2) | (rs_D1 == ws_M2) | (rs_D1 == ws_W2))  & (rs_D1 != 5'b00000)) | 
    (((rt_D1 == ws_E2) | (rt_D1 == ws_M2) | (rt_D1 == ws_W2))  & (rt_D1 != 5'b00000))) ) |
     (((((rs_D2 == ws_E1) | (rs_D2 == ws_M1) | (rs_D2 == ws_W1))  & (rs_D2 != 5'b00000)) | 
    (((rt_D2 == ws_E1) | (rt_D2 == ws_M1) | (rt_D2 == ws_W1))  & (rt_D2 != 5'b00000)))) |
     (((((rs_D2 == ws_E2) | (rs_D2 == ws_M2) | (rs_D2 == ws_W2))  & (rs_D2 != 5'b00000)) | 
    (((rt_D2 == ws_E2) | (rt_D2 == ws_M2) | (rt_D2 == ws_W2)) & (rt_D2 != 5'b00000))))) && (swap1 == 2'b00 | swap2 == 2'b00 | stall == 1'b0) ? 1'b1 : 1'b0; 




    //swap = 10 -> nop tu un khat mifreste jelo
    //stall =1 va swap = 00 or 01 dastoor ro tu un khat mifreste jelo vali ghablia ro stall mikone
    // stall_outer_loop = pipe kolan stall mishe va nop mire jelo

    always@(instruction_D1, instruction_E1, instruction_M1, instruction_WB1,instruction_D2, instruction_E2, instruction_M2, instruction_WB2)begin
        stall = 1'b0;
        swap1 = 2'b00;
        swap2 = 2'b00;
        flush = 1'b0;
        stall_outer_dependent = 1'b0;

        if(dataDependent) begin
            stall = 1'b1;
            swap1 = 2'b10;
            swap2 = 2'b10;
            stall_outer_dependent = 1'b1;

        end

        else if((!correct_place) && dependent)begin
            if(ID_opcode1 == `lw)begin


                // check kon dastoor lw aval ta koja rafte jelo

                // age swap nashode bud :
                //swap kon 
                // swapedOrNot = 1;
                //dastoore line aval ro nop kon
                //stall kon pc va IF_ID

                // age lw aval tu marhale WB bud:
                //swap nakon
                // dastoore aval ro nop kon dastoore dovom bere bara ejra


                swap1 = 2'b10;
                swap2 = (instruction_D1 == instruction_WB2) ? 2'b00 : 2'b01;
                stall = (instruction_D2 == instruction_WB2) ? 1'b0 : 1'b1;


            end
            else if((ID_opcode2 == `j ) | (ID_opcode2 == `beq))begin

                //dastoore aval ta WB anjam she
                //dastoore dovom bade ejra dastoore aval bere bala ejra beshe
                //stall hame beshe

                swap1 = (instruction_D1 == instruction_WB1) ? 2'b01 : 2'b00;
                swap2 = 2'b10;

                stall = (instruction_D1 == instruction_WB1) ? 1'b0 : 1'b1;
                $display("swaped");

            end



        end
        else if((correct_place) && dependent)begin

            // dastoore aval ta WB bere badesh dastoore dovom ejrashe
            swap1 = (instruction_D1 == instruction_WB1) ? 2'b10 : 2'b00;
            swap2 = (instruction_D1 == instruction_WB1) ? 2'b00 : 2'b10;
            stall = (instruction_D1 == instruction_WB1) ? 1'b0 : 1'b1;

        end 
        else if((!correct_place) && (!dependent))begin

            //swap shan ba ham ejra shan
            swap1 = 2'b01;
            swap2 = 2'b01;

        end 
        else if((correct_place) && (!dependent))begin
            swap1 = 2'b00;
            swap2 = 2'b00;
        end


        if(branch | (jmp != 2'b00))begin

            flush = 1'b1;
            stall = 1'b0;
            

        end

    end




    endmodule