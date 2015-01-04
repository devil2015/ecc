`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:23:00 12/08/2014 
// Design Name: 
// Module Name:    Transfer_Module 
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
/////////////////////////////////////////////////////////////

//// It process the opcode to be processed for Transfering

//******************OPcode Decode*******************************

	module Transfer_Data_Module#(
	parameter Data=32)(
		input wire [Data-1:0] command,
		output wire      Reg_fifo_In_Core1,
		
		
		output wire [1:0] Data_A_B_Core1,
		output wire [2:0] Addr_Reg_Core1_A,
		output wire [2:0] Addr_Reg_Core1_B,
		output wire       Msb_A_Core1,
		output  wire  [1:0]    command_Core1,
		
		output wire      Reg_fifo_In_Core2,
		output wire        Mul_Msb,
		output  wire [2:0] Addr_Reg_B,
		output  wire [1:0]      command_Core2,
		
		output wire       Transfer_Cmd,
		
		output wire       Transfer_Fifo_Out_Core1,
	   output wire [2:0] Addr_Fifo_Out_Core1,
		
		output wire       Transfer_Fifo_Out_Core2,
	   output wire [2:0] Addr_Fifo_Out_Core2
		
		 );
		 
		 
		 assign Reg_fifo_In_Core1    = command[0];
		 assign Data_A_B_Core1       = command[2:1];
		 assign Addr_Reg_Core1_A     = command[5:3];
		 
		 assign Addr_Reg_Core1_B     = command[8:6];
		 assign Msb_A_Core1          = command[9];
		 assign command_Core1        = command[12:10];
		 
		 assign Reg_fifo_In_Core2    = command[13];
		 assign Mul_Msb              = command[14];
		 assign Addr_Reg_B           = command[17:15];
		 assign command_Core2        = command[19:18];
		 assign Transfer_Fifo_Out_Core1 =command[20];
		 assign Addr_Fifo_Out_Core1     = command[23:21];
		 assign Transfer_Fifo_Out_Core2 =command[24];
		 assign Addr_Fifo_Out_Core1     = command[27:25];
		 
		 


	endmodule
