`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Sequential_state_machine#(
parameter Data=256,
parameter Mul=1,
parameter Sqr=2,
parameter Inv=3,
parameter Xor=4,
parameter  Red=5
)(
	input wire            clk,
	input wire [2:0]      Seq_Command,
	input wire [Data-1:0] Input_Data_A,
	input wire [Data-1:0] Input_Data_B,
	
	input wire [63:0]     Data_Polynomial,   //Containing Data Characteristics
	input wire [10:0]     Polynomial_Length,
	output reg [Data-1:0] Output_Data
    );
//sets of register to store Data whose Job is to be performed
	wire [2:0] command;
	assign command=Seq_Command;
	wire [Data-1] Data_Out_Reg_A,Data_Out_Reg_B;
	
	Register_Module Register(
		.Data_in({Input_Data_A,Input_Data_B}),
      .command(command),
		
      .fifo_dump(fifo_dump),
      .Data_Out_A(Data_Out_Reg_A),
		.Data_Out_B(Data_Out_Reg_B),
		
		.Polynomial_Length(Polynomial_Length)
);
	
				
		wire Out_Busy_Core2_Output,In_Busy_Core2_Inp,In_Busy_Core2_Cmd,Fifo_In_Busy_Core2_Inp,
		     Out_Busy_Core1_Output,In_Busy_Core1_Cmd,In_Busy_Core1_Inp;
		reg rd_en_Core2_Output,rd_en_Core1_Output,wr_en_Core2_Cmd,wr_en_Core2_Inp,
			 wr_en_Core1_Cmd,wr_en_Core1_Inp;
			 
		reg [7:0] Data_in_Core2_Cmd,Data_in_Core1_Cmd;
		reg [2*Data-1:0] Data_in_Core1_Inp;
		reg [Data-1:0]   Data_in_Core2_Inp;
		wire [Data-1:0] Data_Out_Core2_Output,Data_Out_Core1_Output;
	
			Fifo_Core_module Fifo_Core_Interface(
			
				.clk(clk),	
				.wr_en_Core1_Inp(wr_en_Core1_Inp),
				.Data_in_Core1_Inp(Data_in_Core1_Inp),
				.In_Busy_Core1_Inp(In_Busy_Core1_Inp),


				.wr_en_Core1_Cmd(wr_en_Core1_Cmd),
				.Data_in_Core1_Cmd(Data_in_Core1_Cmd),
				.In_Busy_Core1_Cmd(In_Busy_Core1_Cmd),
				
				.rd_en_Core1_Output(rd_en_Core1_Output),
				.Data_Out_Core1_Output(Data_Out_Core1_Output),
				.Out_Busy_Core1_Output(Out_Busy_Core1_Output),

				.wr_en_Core2_Inp(wr_en_Core2_Inp),
				.Data_in_Core2_Inp(Data_in_Core2_Inp),
				.In_Busy_Core2_Inp(In_Busy_Core2_Inp),

	
				.wr_en_Core2_Cmd(wr_en_Core2_Cmd),
				.Data_in_Core2_Cmd(Data_in_Core2_Cmd),
				.In_Busy_Core2_Cmd(In_Busy_Core2_Cmd),
				
				.rd_en_Core2_Output(rd_en_Core2_Output),
				.Data_Out_Core2_Output(Data_Out_Core2_Output),
				.Out_Busy_Core2_Output(Out_Busy_Core2_Output)
				);


endmodule
