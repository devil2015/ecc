`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:58:55 10/14/2014 
// Design Name: 
// Module Name:    Ram_module 
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
module Ram_Module#(
   parameter DATA = 256,
	parameter ADDR = 2)(                               
	input wire               clk,
	input wire               a_w,
	input wire               b_w,                               
	input	 wire	[(ADDR-1):0] a_adbus,
	input  wire [(DATA-1):0] a_data_in, 
	output reg	[(DATA-1):0] a_data_out,
	input  wire	[(ADDR-1):0] b_adbus,
	input  wire [(DATA-1):0] b_data_in, 
	output reg	[(DATA-1):0] b_data_out
	);


	reg [(DATA-1):0]memory [0:7],b_data_out1,a_data_out1;
	
	
	
	always @(posedge clk) begin
		if( a_w ) begin
				memory[a_adbus] <= a_data_in;
			end
				a_data_out<=memory[a_adbus];	
	end

    	always @(posedge clk) begin
		if( b_w ) begin
				memory[b_adbus] <= b_data_in;
			end
				b_data_out<=memory[b_adbus];	

	end//end of always module


endmodule
