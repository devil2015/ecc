
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:55:45 10/14/2014 
// Design Name: 
// Module Name:    Ram_module_1 
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
module Ram_module_for_scalar_mul#(
   parameter DATA = 256,
	parameter ADDR = 6)(                               
	input wire clk,
	input wire a_w,
	input wire b_w,                               
	input	 wire	[(ADDR-1):0] a_adbus,
	input  wire [(DATA-1):0] a_data_in, 
	output reg	[(DATA-1):0] a_data_out,
	input  wire	[(ADDR-1):0] b_adbus,
	input  wire [(DATA-1):0] b_data_in, 
	output reg	[(DATA-1):0] b_data_out,
	output reg  [(DATA-1):0] command,
	input wire  [(DATA-1):0] status
	);


	reg [(DATA-1):0]memory [0:41];
	
	
	always @(posedge clk) begin
		if( a_w ) begin
				if(a_adbus==5'h1) begin
					command<=a_data_in;
					end
					memory[a_adbus] <= a_data_in;
			end
				if(a_adbus==5'h0) begin
					a_data_out<=status;
					end
				else begin
					a_data_out<=memory[a_adbus];
					end
		end

    	always @(posedge clk) begin
			if( b_w ) begin
				memory[b_adbus] <= b_data_in;
				end
				b_data_out<=memory[b_adbus];

			end//end of always module


endmodule
