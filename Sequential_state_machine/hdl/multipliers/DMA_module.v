`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Deepak Kapoor
// 
// Create Date:    10:14:25 12/04/2014 
// Design Name: 
// Module Name:    DMA_module 
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


//A -Input 1 Fifo
//B - Input 2 Fifo
//C - Output Fifo
//cdm- Command Fifo

module Fifo_Core_module#(
parameter Data=256)(
	input wire               clk,
	//FiFO FOR Core1
	input wire               wr_en_Core1_Inp,
	input wire [2*Data-1:0]  Data_in_Core1_Inp,
	output wire              In_Busy_Core1_Inp,
	
	input wire              wr_en_Core1_Cmd,
	input wire [7:0]        Data_in_Core1_Cmd,
	output wire             In_Busy_Core1_Cmd,
	
	input wire              rd_en_Core1_Output,
	output wire [Data-1:0]  Data_Out_Core1_Output,
	output wire             Out_Busy_Core1_Output,
	
	//FiFO FOR Core2
	input wire              wr_en_Core2_Inp,
	input wire [Data-1:0]   Data_in_Core2_Inp,
	output wire             In_Busy_Core2_Inp,
	
	input wire              wr_en_Core2_Cmd,
	input wire [7:0]        Data_in_Core2_Cmd,
	output wire             In_Busy_Core2_Cmd,
	
	
	
	input wire             rd_en_Core2_Output,
	output wire [Data-1:0] Data_Out_Core2_Output,
	output wire            Out_Busy_Core2_Output
	
    );



	initial begin
		$dumpfile("test.vcd");
		$dumpvars();
		
		wr_en_Core1_Output<=1'h0;
		wr_en_Core2_Output<=1'h0;		
	end
  
	wire              rd_en_Core1_Inp;
	wire [2*Data-1:0] Data_Out_Core1_Inp;
	wire              Out_Busy_Core1_Inp;

	 Fifo_512 Fifo_Input_Core1(
				.clk(clk),
				.wr_en(wr_en_Core1_Inp),           //write enable
				.rd_en(rd_en_Core1_Inp),            //read _enable
				.Data_in(Data_in_Core1_Inp),
				.Data_out(Data_Out_Core1_Inp),
				.In_Busy(In_Busy_Core1_Inp),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_Core1_Inp)        //interupt indicate fifo empty
		 );
		 
	assign rd_en_Core1_Inp =Out_Busy_Core1_Inp?1'h0:1'h1;
		 
		 
	wire              rd_en_Core2_Inp;
	wire [2*Data-1:0] Data_Out_Core2_Inp;
	wire              Out_Busy_Core2_Inp;

	 Fifo_256 Fifo_Input_Core2(
				.clk(clk),
				.wr_en(wr_en_Core2_Inp),           //write enable
				.rd_en(rd_en_Core2_Inp),            //read _enable
				.Data_in(Data_in_Core2_Inp),
				.Data_out(Data_Out_Core2_Inp),
				.In_Busy(In_Busy_Core2_Inp),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_Core2_Inp)        //interupt indicate fifo empty
		 );
		 
	assign rd_en_Core2_Inp =Out_Busy_Core2_Inp?1'h0:1'h1;
		 
		  
		 

	wire [255:0] Core1_Inp_A,Core1_Inp_B;
	wire [127:0] Core1_Out_C,Core1_Out_D;
	wire [2:0]   Core1_Select_Line;

	Core1_Implementation  Core1(
				.clk(clk),
				.A(Core1_Inp_A),                 
				.B(Core1_Inp_B),                 
				.select_line(Core1_Select_Line),
				.C_Out(Core1_Out_C),
				.D_Out(Core1_Out_D)
		);
		
		
	wire [127:0] Core2_Inp_A,Core2_Inp_B;
	wire [255:0] Core2_Out_C;
	wire [2:0]   Core2_Select_Line;
	wire         Out_Busy_Core2; 	
		
		Core2_Implementation  Core2(
					.clk(clk),
					.A(Core2_Inp_A),                 
					.B(Core2_Inp_B),                     
					.select_line(Core2_Select_Line),
					.Out_Busy(Out_Busy_Core2),
					.In_Busy(Out_Busy_Core2_Inp),
					.C_Out(Core2_Out_C)
			);
		
		
	wire         rd_en_Core1_Cmd;
	wire [7:0]   Data_Out_Core1_Cmd;
	wire         Out_Busy_Core1_Cmd;
	
		
		Fifo_command_Module Fifo_Command1(
					.clk(clk),
					.wr_en(wr_en_Core1_Cmd),           //write enable
					.rd_en(rd_en_Core1_Cmd),            //read _enable
					.Data_in(Data_in_Core1_Cmd),
					.Data_out(Data_Out_Core1_Cmd),
					.In_Busy(In_Busy_Core1_Cmd),         //interupt indicate fifo full
					.Out_Busy(Out_Busy_Core1_Cmd)
				);
	
	
	
   assign rd_en_Core1_Cmd =Out_Busy_Core1_Cmd?1'h0:1'h1;	
				
				
	wire          rd_en_Core2_Cmd;
	wire [7:0]    Data_Out_Core2_Cmd;
	wire         Out_Busy_Core2_Cmd;
	
		
		Fifo_command_Module Fifo_Command2(
						.clk(clk),
						.wr_en(wr_en_Core2_Cmd),           //write enable
						.rd_en(rd_en_Core2_Cmd),            //read _enable
						.Data_in(Data_in_Core2_Cmd),
						.Data_out(Data_Out_Core2_Cmd),
						.In_Busy(In_Busy_Core2_Cmd),         //interupt indicate fifo full
						.Out_Busy(Out_Busy_Core2_Cmd)
							);
				
				
	 assign rd_en_Core2_Cmd =Out_Busy_Core2_Cmd?1'h0:1'h1;
					
				
				
	reg           wr_en_Core1_Output;
	wire  [255:0] Data_in_Core1_Output;
	wire          In_Busy_Core1_Output;
	
		 Fifo_256 Fifo_Ouput1(
				.clk(clk),
				.wr_en(wr_en_Core1_Output),           //write enable
				.rd_en(rd_en_Core1_Output),            //read _enable
				.Data_in(Data_in_Core1_Output),
				.Data_out(Data_Out_Core1_Output),
				.In_Busy(In_Busy_Core1_Output),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_Core1_Output) 
				);
				
		
					
	reg         wr_en_Core2_Output;
	wire  [255:0] Data_in_Core2_Output;
	wire         In_Busy_Core2_Output;
	assign Data_in_Core2_Output=Core2_Out_C;
	
		 Fifo_256 Fifo_Ouput2(
				.clk(clk),
				.wr_en(wr_en_Core2_Output),           //write enable
				.rd_en(rd_en_Core2_Output),            //read _enable
				.Data_in(Data_in_Core2_Output),
				.Data_out(Data_Out_Core2_Output),
				.In_Busy(In_Busy_Core2_Output),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_Core2_Output) 
				);
				
				
	assign 	 Core1_Inp_A =Data_Out_Core1_Inp[255:0];	
	assign 	 Core1_Inp_B =Data_Out_Core1_Inp[511:256];
	assign   Core1_Select_Line =Data_Out_Core1_Cmd[2:0];
	
	assign 	 Core2_Inp_B =Data_Out_Core2_Inp[255:128];	
	assign   Core2_Inp_A =Data_Out_Core2_Inp[127:0]; 
	assign   Core2_Select_Line =Data_Out_Core2_Cmd[2:0];
	assign Data_in_Core1_Output={Core1_Out_C,Core1_Out_D};
	
	
	always @(posedge clk) begin
		if(!Out_Busy_Core2 && !In_Busy_Core2_Output) begin        //Pushing result OF Core2  in Fifo
			wr_en_Core2_Output<=1'h1;
			end
		else
			wr_en_Core2_Output <=1'h0;
					
		if(!Out_Busy_Core1_Inp && !In_Busy_Core1_Output) begin                       //Pushing result of Core1 in Fifo
			wr_en_Core1_Output<=1'h1;
			end
		else
			wr_en_Core1_Output <=1'h0;
		end
	endmodule
