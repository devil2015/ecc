`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BARC
// Engineer: Deepak
// 
// Create Date:    05:42:12 01/01/2009 
// Design Name: 
// Module Name:    Outer_Ram_interface 
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
module Ram_interface_scalar_mul#(
	parameter Data=256,
	parameter Addr=5,
	parameter command_len=1)
	(
   input wire clk,
	//interfacing of Ram for taking Data from outside
	input  wire               a_w,	
	input  wire  [Addr:0]     a_adbus,
	input  wire  [(Data-1):0] a_data_in,
	output wire  [(Data-1):0] a_data_out,
	//interfacing of Ram with inner module
	input  wire               b_w,
	input  wire  [Addr:0]     b_adbus,                 //address bus
	input  wire  [(Data-1):0] b_data_in,
	output wire  [(Data-1):0] b_data_out,
	output wire   [(Data-1):0] command,
	input  wire  [(Data-1):0] status
    );


Ram_module_for_scalar_mul Ram_module_for_scalar_mul (
		.clk(clk), 
		.a_w(a_w), 
		.b_w(b_w), 
		.a_adbus(a_adbus), 
		.a_data_in(a_data_in), 
		.a_data_out(a_data_out), 
		.b_adbus(b_adbus), 
		.b_data_in(b_data_in), 
		.b_data_out(b_data_out),
		.command(command),
		.status(status)
	);


endmodule
