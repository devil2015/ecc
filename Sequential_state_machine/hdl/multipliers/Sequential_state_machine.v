`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: zzz
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
parameter Xor=2,
parameter Sqr=3,
parameter Inv=4,
parameter Red=5)(

	input wire clk,
	input wire [2:0] Seq_Command,
	input wire [Data-1:0] Input_Data_A,
	input wire [Data-1:0] Input_Data_B,
	input wire [63:0]     Polynomial_Data,
	input wire [10:0]     Polynomial_Length,
	output reg [Data-1:0] Output_Data
    );
//sets of register to store Data whose Job is to be performed




	initial begin
		X<=2'h1;
	end
	
	reg [Data-1:0] Input_Mul_A[0:2];
	reg [Data-1:0] Input_Mul_B[0:2];
	reg [Data-1:0] Input_Sqr[0:2];
	reg [Data-1:0] Input_Inv[0:2];
	reg [Data-1:0] Input_Xor_B[0:2];
	reg [Data-1:0] Input_Xor_A[0:2];
	
	
	reg [Data-1:0] Temp_Mul[0:5];
	reg [Data-1:0] Temp_Sqr[0:5];
	reg [Data-1:0] Temp_Inv[0:2];
	reg [Data-1:0] Temp_Xor[0:2];
	
	reg [2:0] X;
	
	
	 reg         wr_en_A,wr_en_B,rd_en_C,wr_en_Core2_A,wr_en_Core2_B,
						wr_en_Core2_Cmd,rd_en_Core2_C;
						
	 reg [Data-1:0] Data_in_A,Data_in_B,Data_in_Cmd,Data_in_Core2_A,Data_in_Core2_B,
							Data_Out_C,Data_in_Core2_Cmd,Data_Out_Core2_C;
							
	 wire            Fifo_In_Busy_A,Fifo_In_Busy_B,wr_en_Cmd,Fifo_In_Busy_Cmd,
							Fifo_Out_Busy_C,Fifo_In_Busy_Core2_A,Fifo_In_Busy_Core2_B,
							Fifo_In_Busy_Core2_Cmd,Fifo_Out_Busy_Core2_C;
	
	      
	
	
	always @(posedge clk) begin
		case(command)
			Mul:begin
				case(X) 
					2'h0:begin
						Input_Mul_A[2]<=Input_Data_A;
						Input_Mul_B[2]<=Input_Data_B;
						if(Polynomail_Length[9])
							X<=2'h1;
						else
							X<=2'h3;
						end
					2'h1:begin
						Input_Mul_A[1]<=Input_Data_A;
						Input_Mul_B[1]<=Input_Data_B;
						if(Polynomail_Length[5])
							X<=2'h2;
						else
							X<=2'h3;
						end
					2'h2:begin
						Input_Mul_A[0]<=Input_Data_A;
						Input_Mul_B[0]<=Input_Data_B;
						X<=2'h3;
						end
					endcase
				end
			endcase
			end
				
		
		
	
	
	
		
			Fifo_Core_module Fifo_Core_Interface(
			
				.clk(clk),	
				.wr_en_A(wr_en_Core1_A),
				.Data_in_A(Data_in__Core1_A),
				.Fifo_In_Busy_A(Fifo_In_Busy_Core1_A),

				.wr_en_B(wr_en_Core1_B),
				.Data_in_B(Data_in_B),
				.Fifo_In_Busy_B(Fifo_In_Busy_B),
				.wr_en_Cmd(wr_en_Cmd),
				.Data_in_Cmd(Data_in_Cmd),
				.Fifo_In_Busy_Cmd(Fifo_In_Busy_Cmd),
				.rd_en_C(rd_en_C),
				.Data_Out_C(Data_Out_C),
				.Fifo_Out_Busy_C(Fifo_Out_Busy_C),

				.wr_en_Core2_A(wr_en_Core2_A),
				.Data_in_Core2_A(Data_in_Core2_A),
				.Fifo_In_Busy_Core2_A(Fifo_In_Busy_Core2_A),

				.wr_en_Core2_B(wr_en_Core2_B),
				.Data_in_Core2_B(Data_in_Core2_B),
				.Fifo_In_Busy_Core2_B(Fifo_In_Busy_Core2_B),
				.wr_en_Core2_Cmd(wr_en_Core2_Cmd),
				.Data_in_Core2_Cmd(Data_in_Core2_Cmd),
				.Fifo_In_Busy_Core2_Cmd(Fifo_In_Busy_Core2_Cmd),
				.rd_en_Core2_C(rd_en_Core2_C),
				.Data_Out_Core2_C(Data_Out_Core2_C),
				.Fifo_Out_Busy_Core2_C(Fifo_Out_Busy_Core2_C)
				);


endmodule
