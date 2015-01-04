`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Barc	
// Engineer: Deepak Kapoor (modified)
// 
// Create Date:    22:42:05 08/15/2014 
// Design Name: 
// Module Name:    Ram_Interface_Module 
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
//Ram interface wrapping four Ram for storing data 
//////////////////////////////////////////////////////////////////////////////////
module Ram_Interface_Module#(   
parameter DATA = 256,
parameter ADDR = 2
)(
	input wire               clk,
	input wire               a_w,                               
	input wire			[3:0]  a_adbus,
	input  wire [(DATA-1):0] a_data_in, 
	output wire [(DATA-1):0] a_data_out,  
	
	/*For simultaneous Read address Port must be differnt */
	input wire                b_w_A,  
	input wire  [(ADDR-1):0]  b_adbus_A,
	input  wire	[(DATA-1):0]  b_data_in_A,	
	output wire [(DATA-1):0]  b_data_out_A,
	
	input  wire                 b_w_B,  
	input  wire    [(ADDR-1):0] b_adbus_B,
	input  wire	   [(DATA-1):0] b_data_in_B,	
	output wire 	[(DATA-1):0] b_data_out_B,
	
	input  wire                 b_w_C,  
	input  wire    [(ADDR-1):0] b_adbus_C,
	input  wire	   [(DATA-1):0] b_data_in_C,	
	output wire 	[(DATA-1):0] b_data_out_C,
	
	input  wire                 b_w_D,  
	input  wire    [(ADDR-1):0] b_adbus_D,
	input  wire	   [(DATA-1):0] b_data_in_D,	
	output wire 	[(DATA-1):0] b_data_out_D
              
    );
	 
			wire [255:0] a_data_in_A,a_data_in_B,a_data_in_C,a_data_in_D;
			wire [(ADDR-1):0]   a_adbus_A,a_adbus_B,a_adbus_C,a_adbus_D;
			wire [255:0] a_data_out_A,a_data_out_B,a_data_out_C,a_data_out_D;
			
 //Mapping of input Port to respective Ram
			
			assign a_data_in_A=(a_adbus[3:2]==2'b00)?a_data_in:255'hz;
			assign a_adbus_A=(a_adbus[3:2]==2'b00)?a_adbus[(ADDR-1):0]:2'hz;

			assign a_data_in_B=(a_adbus[3:2]==2'b01)?a_data_in:255'hz;
			assign a_adbus_B=(a_adbus[3:2]==2'b01)?a_adbus[(ADDR-1):0]:2'hz;

			assign a_data_in_C=(a_adbus[3:2]==2'b10)?a_data_in:255'hz;
			assign a_adbus_C=(a_adbus[3:2]==2'b10)?a_adbus[(ADDR-1):0]:2'hz;

			assign a_data_in_D=(a_adbus[3:2]==2'b11)?a_data_in:255'hz;
			assign a_adbus_D=(a_adbus[3:2]==2'b11)?a_adbus[(ADDR-1):0]:2'hz;


			assign a_data_out=(a_adbus[3:2]==2'b00)?a_data_out_A:
			                 ((a_adbus[3:2]==2'b01)?a_data_out_B:
								  ((a_adbus[3:2]==2'b10)?a_data_out_C:
								  ((a_adbus[3:2]==2'b11)?a_data_out_D:a_data_out)));



			Ram_Module Ram_A (
				.clk(clk), 
				.a_w(a_w), 
				.b_w(b_w_A), 
				.a_adbus(a_adbus_A), 
				.a_data_in(a_data_in_A), 
				.a_data_out(a_data_out_A), 
				.b_adbus(b_adbus_A), 
				.b_data_in(b_data_in_A), 
				.b_data_out(b_data_out_A)
				);

			Ram_Module Ram_B (
				.clk(clk), 
				.a_w(a_w), 
				.b_w(b_w_B), 
				.a_adbus(a_adbus_B), 
				.a_data_in(a_data_in_B), 
				.a_data_out(a_data_out_B), 
				.b_adbus(b_adbus_B), 
				.b_data_in(b_data_in_B), 
				.b_data_out(b_data_out_B)
				);


			Ram_Module Ram_C (
				.clk(clk), 
				.a_w(a_w), 
				.b_w(b_w_C), 
				.a_adbus(a_adbus_C), 
				.a_data_in(a_data_in_C), 
				.a_data_out(a_data_out_C), 
				.b_adbus(b_adbus_C), 
				.b_data_in(b_data_in_C), 
				.b_data_out(b_data_out_C)
				);


			Ram_Module Ram_D (
				.clk(clk), 
				.a_w(a_w), 
				.b_w(b_w_D), 
				.a_adbus(a_adbus_D), 
				.a_data_in(a_data_in_D), 
				.a_data_out(a_data_out_D), 
				.b_adbus(b_adbus_D), 
				.b_data_in(b_data_in_D), 
				.b_data_out(b_data_out_D)
				);
endmodule
