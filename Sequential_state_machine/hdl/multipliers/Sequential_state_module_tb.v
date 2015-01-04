`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:21:31 12/09/2014
// Design Name:   Sequential_state_machine
// Module Name:   /home/lab1/devel/ecc/Sequential_state_machine/hdl/multipliers/Sequential_state_module_tb.v
// Project Name:  fifo
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Sequential_state_machine
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Sequential_state_module_tb;

	// Inputs
	reg clk;
	reg [3:0] Seq_Command;
	reg [255:0] Input_Data_A;
	reg [255:0] Input_Data_B;
	reg [63:0] Data_Polynomial;
	reg [10:0] Polynomial_Length;
	reg [2:0] Output_Addr;
	reg wr_reg;

	// Outputs
	wire [255:0] Output_Data;

	// Instantiate the Unit Under Test (UUT)
	Sequential_state_machine Seq_Module (
		.clk(clk), 
		.Seq_Command(Seq_Command), 
		.Input_Data_A(Input_Data_A), 
		.Input_Data_B(Input_Data_B), 
		.Data_Polynomial(Data_Polynomial), 
		.Polynomial_Length(Polynomial_Length), 
		.Output_Addr(Output_Addr), 
		.Output_Data(Output_Data),
		.wr_reg(wr_reg)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		wr_reg =0;
		Seq_Command = 0;
		Input_Data_A = 0;
		Input_Data_B = 0;
		Data_Polynomial = 0;
		Polynomial_Length = 0;
		Output_Addr = 0;

		#5;
		wr_reg=1;
		repeat(3)
		write($random,$random);
		
		Seq_Command=1;
		#20
		Seq_Command=0;
		wr_reg=0;

	end
	task write(input [255:0] data1,input [255:0] data2);
		@(posedge clk) begin
			Input_Data_A =data1;
			Input_Data_B= data2;
		end
		
	
		
	endtask
	
	always begin
	#5 clk =~clk;
	end
      
endmodule

