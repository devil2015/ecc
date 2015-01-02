`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:Deepak Kapoor 
// 
// Create Date:    11:43:05 07/23/2014 
// Design Name: 
// Module Name:    lower_bit_implementation 
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


module Core2_Implementation#(
	parameter MUL=3'b001
	)(
	
   //INPUTS
	input wire         clk,
	input wire [127:0] A,                 
	input wire [127:0] B,                      //change
	input wire [2:0] select_line,
	input wire 		In_Busy,
	//OUTPUT
	output wire Out_Busy,
	output[255:0] C_Out
	
	);
	
	//OUTPUT PORTS
	wire [255:0] Data_C_Out[1:0];   
	//INPUT PORTS
	wire [127:0] Data_A_MUL,Data_B_MUL;


		assign Data_A_MUL =(select_line==MUL)?A[127:0]:128'hz;
		assign  Data_B_MUL=(select_line==MUL)?B[127:0]:128'hz;
		
	
      
	   mul_128_module mul_128(
			.clk(clk),
			.A(Data_A_MUL),
			.B(Data_B_MUL),
			.mul_128(Data_C_Out[MUL]),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy)
		);
		
		

		assign C_Out=Data_C_Out[select_line];

endmodule	


