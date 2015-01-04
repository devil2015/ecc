`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:23:39 12/11/2014
// Design Name:   Inverse_Module
// Module Name:   /home/lab1/devel/ecc/Sequential_state_machine/hdl/multipliers/Inverse_tb.v
// Project Name:  fifo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Inverse_Module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Inverse_tb;

	// Inputs
	reg clk;
	reg [5:0] Command;
	reg wr_en;
	reg [255:0] Input_Data;
	reg [5:0] Addr;
	reg [63:0] Data_Polynomial;

	// Outputs
	wire [255:0] Output_Data;

	// Instantiate the Unit Under Test (UUT)
	Inverse_Module uut (
		.clk(clk), 
		.Command(Command), 
		.wr_en(wr_en), 
		.Input_Data(Input_Data), 
		.Addr(Addr), 
		.Data_Polynomial(Data_Polynomial), 
		.Output_Data(Output_Data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		Command = 0;
		wr_en = 0;
		Input_Data = 0;
		Addr = 0;
		Data_Polynomial = 0;
		#10
		write($random,4'h4);
		#20
		wr_en=1'h0;
		Command=1;
		#10
		Command=0;
		#10;
		
	end
	
	task write(input [255:0] data,input [4:0] addr);
	@(posedge clk) begin
		wr_en=1'h1;
		Input_Data=data;
		Addr= addr;
		end
		endtask
		
	always  begin
	#5 clk=~clk;
	end
      
endmodule

