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
//C  - output FIFO  
//D - COMMAND FIFO
	module Circular_FIFO_module#(
	parameter Data=256,
	parameter Adbus=3)(
		 input wire             clk,
		 input wire             wr_en_A,           //write enable
		 input wire             rd_en_A,            //read _enable
		 input wire [Data-1:0]  Data_in_A,
		 output reg [Data-1:0]  Data_out_A,
		 output reg             full_FIFO_A,         //interupt indicate fifo full
		 
		 input wire             wr_en_B,           
		 input wire             rd_en_B,            
		 input wire [Data-1:0]  Data_in_B,
		 output reg [Data-1:0]  Data_out_B,
		 output reg             full_FIFO_B,  
		 
		 input wire             wr_en_C,           
		 input wire             rd_en_C,            
		 input wire [Data-1:0]  Data_in_C,
		 output reg [Data-1:0]  Data_out_C,
		 output reg             full_FIFO_C, 
		 
		 
		 input wire             wr_en_D,           
		 input wire             rd_en_D,            
		 input wire [Data-1:0]  Data_in_D,
		 output reg [Data-1:0]  Data_out_D,
		 output reg             full_FIFO_D 
		 
		 
		 );
	
	reg [Data-1:0]  memory_A [0:7],memory_B [0:7],memory_C [0:7],memory_D [0:7];
	reg [Adbus-1:0] rd_addr_A,wr_addr_A,rd_addr_B,wr_addr_B,rd_addr_C,wr_addr_C,rd_addr_D,wr_addr_D;                 //read write address of FIFO
	reg [3:0] count_A,count_B,count_C,count_D;                                 //count variable to check FIFO is full or not
	
	
	initial begin
		rd_addr_A <= 6'h0;
		wr_addr_A <= 6'h0;
		count_A   <= 4'h0;
		
		rd_addr_B <= 6'h0;
		wr_addr_B <= 6'h0;
		count_B   <= 4'h0;
		
		rd_addr_C <= 6'h0;
		wr_addr_C <= 6'h0;
		count_C   <= 4'h0;
		
		rd_addr_D <= 6'h0;
		wr_addr_D <= 6'h0;
		count_D   <= 4'h0;
		end
		
	always@(posedge clk) begin
		if(wr_en_A) begin
			memory_A [wr_addr_A] <= Data_in_A;
			wr_addr_A          <= (wr_addr_A+1'h1)%4'h8;
			count_A            <=  count_A +1'h1;
			end
		if(rd_en_A) begin
			Data_out_A <= memory_A [rd_addr_A];
			rd_addr_A  <= (rd_addr_A+1'h1)%4'h8;
			
			if(count_A!=4'h0)
				count_A    <= count_A -1'h1;
				end
		
		if(count_A[3])
			full_FIFO_A<=1'h1;            //enable when fifo is full
		else
			full_FIFO_A <=1'h0;
			
			
			if(wr_en_B) begin
			memory_B [wr_addr_B] <= Data_in_B;
			wr_addr_B          <= (wr_addr_B+1'h1)%4'h8;
			count_B            <=  count_B +1'h1;
			end
		if(rd_en_B) begin
			Data_out_B <= memory_B [rd_addr_B];
			rd_addr_B  <= (rd_addr_B+1'h1)%4'h8;
			
			if(count_B!=4'h0)
				count_B    <= count_B -1'h1;
				end
		
		if(count_B[3])
			full_FIFO_B<=1'h1;            //enable when fifo is full
		else
			full_FIFO_B <=1'h0;
			
			if(wr_en_C) begin
			memory_C [wr_addr_C] <= Data_in_C;
			wr_addr_C          <= (wr_addr_C+1'h1)%4'h8;
			count_C            <=  count_C +1'h1;
			end
		if(rd_en_C) begin
			Data_out_C <= memory_C [rd_addr_C];
			rd_addr_C <= (rd_addr_C+1'h1)%4'h8;
			
			if(count_C!=4'h0)
				count_C   <= count_C -1'h1;
				end
		
		if(count_C[3])
			full_FIFO_C<=1'h1;            //enable when fifo is full
		else
			full_FIFO_C <=1'h0;
			
			if(wr_en_A) begin
			memory_D [wr_addr_D] <= Data_in_D;
			wr_addr_D          <= (wr_addr_D+1'h1)%4'h8;
			count_D            <=  count_D +1'h1;
			end
		if(rd_en_A) begin
			Data_out_D <= memory_D [rd_addr_D];
			rd_addr_D  <= (rd_addr_D+1'h1)%4'h8;
			
			if(count_A!=4'h0)
				count_D    <= count_D -1'h1;
				end
		
		if(count_A[3])
			full_FIFO_D<=1'h1;            //enable when fifo is full
		else
			full_FIFO_D <=1'h0;
			
	
	end

endmodule
