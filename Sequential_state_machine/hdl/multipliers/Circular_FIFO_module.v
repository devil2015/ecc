`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:24:40 11/14/2014 
// Design Name: 
// Module Name:    Circular_FIFO_module 
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


//A- input FIFO 1
//B - input FIFO 2
	module Fifo_512#(
	parameter Data=512,
	parameter Adbus=3)(
		 input wire              clk,
		 input wire              wr_en,           //write enable
		 input wire              rd_en,            //read _enable
		 input wire [Data-1:0]   Data_in,
		 output reg [Data-1:0]   Data_out,
		 output wire             In_Busy,         //interupt indicate fifo full
		 output wire 		       Out_Busy        //interupt indicate fifo empty
		 
		 );
		 
	assign In_Busy=count[3]?1'h1:1'h0;
	
	assign Out_Busy=(count==4'h0)?1'h1:1'h0;
	
	
	reg [Data-1:0]  Fifo_memory [0:7];
	reg [Adbus-1:0] rd_addr,wr_addr;                 //read write address of FIFO
	reg [3:0] count;                                 //count variable to check FIFO is full or not
	
	
	initial begin
		rd_addr <= 6'h0;
		wr_addr <= 6'h0;
		count   <= 4'h0;
		end
		
	always@(posedge clk) begin
		if(wr_en && !count[3]) begin
			Fifo_memory [wr_addr] <=  Data_in;
			wr_addr            <= (wr_addr+1'h1)%4'h8;    //increase the counter to write in fifo
			end		
			

		if(rd_en && count[3:0]!=4'h0) begin
			Data_out <=  Fifo_memory [rd_addr];
			rd_addr  <= (rd_addr+1'h1)%4'h8;		
			end
		
		if(wr_en && !rd_en &&  !count[3])
				count <= count+1'h1;
		else if(!wr_en && rd_en && (count[3:0]!=4'h0))
				count <= count-1'h1;
		else
				count <=count;
	end
	
endmodule

