`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Deepak Kapoor
// 
// Create Date:    16:22:39 12/05/2014 
// Design Name: 
// Module Name:    Sequential_state_machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:\ 
//
//////////////////////////////////////////////////////////////////////////////////
module Sequential_state_machine#(
	parameter Data=256,
	parameter Addr=2,
	parameter Command_len=6,
	parameter Opcode_Size=16,
	parameter Mul=1,
	parameter Sqr=2,
	parameter Inv=3,
	parameter Xor=4,
	parameter Red=5,
	parameter A=3'b001,
	parameter B=3'b010,
	parameter C=3'b011,
	parameter D=3'b100,
	parameter E=3'b101,
	parameter Fifo=3'b110,
	parameter  Ram_C=3'b111
		)(
		input wire	                 clk, 
  
		output wire	[Addr-1:0]       adbus_A,
		input wire	[Data-1:0]       data_in_A,	

		output wire	[Addr-1:0]       adbus_B,
		input wire	[Data-1:0]       data_in_B,	

		output reg	                 w_C,  
		output reg	[Addr-1:0]       adbus_C,	
		output reg	[Data-1:0]       data_out_C,

		output wire	                 w_D,  
		output wire	[Addr-1:0]       adbus_D,	
		output wire	[Data-1:0]       data_out_D,

		input wire	[63:0]            Data_Polynomial,
		input wire	[Command_len-1:0] Command
    );

				
		wire                 Out_Busy_Core2_Output,In_Busy_Core2_Inp,In_Busy_Core2_Cmd,Fifo_In_Busy_Core2_Inp;
		wire                 rd_en_Core2,wr_en_Core2_Cmd,wr_en_Core2_Inp;
			 
		wire [7:0]           Data_in_Core2_Cmd,Data_in_Core1_Cmd;
		wire [Data-1:0]      Data_in_Core2_A,Data_in_Core2_B,Data_in_Core1_Msb,Data_in_Core1_Lsb;
		wire [Data-1:0]      Data_Out_Core2,Data_Out_Core1;	
		
		wire                   Cmmd_Transfer;
		wire [Opcode_Size-1:0] Data_Opcode;
      wire [Opcode_Size-1:0] Data_In_Opcode_Core2,Delay_Opcode_Core2,Opcode;		
					
		
			
		wire                   wr_en_Opcode_Core2,rd_en_Opcode_Core2,In_Busy_Opcode_Core2,
		                       Out_Busy_Opcode_Core2;
		
		
		reg                    wr_en_temp;
		wire                   rd_en_temp,In_Busy_temp,Out_Busy_temp;
		reg  [Data-1:0]        Data_In_temp;
		wire [Data-1:0]        Data_Out_temp;
		
		//Temp reg to store final result of square and multiplication
	   reg  [Data-1:0]         temp_A,temp_B,temp_C,temp_D,temp_E;
							
		assign adbus_A=Opcode[2:1];
		assign Data_in_Core1_Lsb[127:0]=Delay_Opcode[3]?data_in_A[255:128]:data_in_A[127:0];
		assign Data_in_Core1_Lsb[255:128]=Delay_Opcode[3]?128'h0:data_in_A[255:128];
		assign Data_in_Core1_Cmd =Delay_Opcode[5:4];
		assign adbus_B=Opcode[10:9];
		assign Data_in_Core1_Msb=data_in_B;
		

			Fifo_Core_module Fifo_Core_Interface(
			
				.clk(clk),	
				// Core 1 Square ,Xor
				.Core1_Inp_A(Data_in_Core1_Msb),
				.Core1_Inp_B(Data_in_Core1_Lsb),   //input
            .Core1_Cmd(Data_in_Core1_Cmd),   //command
            .Data_Out_Core1(Data_Out_Core1),  //Output
				
				//Core 2 Fifo Multiplication
				.wr_en_Core2_Inp(wr_en_Core2_Inp),
				.Data_in_Core2_A(Data_in_Core2_A),
				.Data_in_Core2_B(Data_in_Core2_B),
				.In_Busy_Core2_Inp(In_Busy_Core2_Inp),  //Fifo Busy
         //command Fifo core2
				.wr_en_Core2_Cmd(wr_en_Core2_Cmd),
				.Data_in_Core2_Cmd(Data_in_Core2_Cmd),
				.In_Busy_Core2_Cmd(In_Busy_Core2_Cmd),
			//Data out Fifo 
				.rd_en_Core2_Output(rd_en_Core2),
				.Data_Out_Core2_Output(Data_Out_Core2),
				.Out_Busy_Core2_Output(Out_Busy_Core2_Output)
				);
							
			
			Rom Rom(
				.clk(clk),
				.command(Command),
				.Data_Out_Opcode(Opcode)
				);
				

     //for storing opcode dealy caused in Core2				
		Fifo#(16,3) Opcode_Fifo_Core2(
				.clk(clk),
				.wr_en(wr_en_Opcode_Core2),           //write enable
				.rd_en(rd_en_Opcode_Core2),            //read _enable
				.Data_in(Data_In_Opcode_Core2),
				.Data_out(Delay_Opcode_Core2),
				.In_Busy(In_Busy_Opcode_Core2),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_Opcode_Core2) 
				);
				
				
				//storing intermeditiate result
		Fifo#(256,8) Fifo_temp_reg(
				.clk(clk),
				.wr_en(wr_en_temp),           //write enable
				.rd_en(rd_en_temp),            //read _enable
				.Data_in(Data_In_temp),
				.Data_out(Data_Out_temp),
				.In_Busy(In_Busy_temp),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_temp) 
				);
				
		//reg [Opcode_Size-1:0] p;
		reg [Opcode_Size-1:0] Delay_Opcode;
		
		
		always @(posedge clk) begin
			Delay_Opcode<=Opcode;
			if(Delay_Opcode[4]==1'h1) begin
				case(Delay_Opcode[8:6])
			
					A: temp_A<=Data_Out_Core1;
					B: temp_B<=Data_Out_Core1;
					C: temp_C<=Data_Out_Core1;
					D: temp_D<=Data_Out_Core1;
					E: temp_E<=Data_Out_Core1;
					Fifo:begin
						wr_en_temp<=1'h1;
						Data_In_temp<=Data_Out_Core1;
						end
					Ram_C:begin
						w_C<=1'h1;
						data_out_C<=Data_Out_Core1;
						adbus_C<=Delay_Opcode[2:1];
						end
					endcase
				end
			end
		
endmodule
