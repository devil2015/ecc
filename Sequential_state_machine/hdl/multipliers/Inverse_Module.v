`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:17:35 12/11/2014 
// Design Name: 
// Module Name:    Inverse_Module 
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
	module Inverse_Module#(
		parameter Data=256,
		parameter addr=6,
		parameter Command_len=6)(

			input wire             clk,
			input wire [5:0]       Command,
			//Port to writing input to respective Ram
			input wire             wr_en,	
			input wire [Data-1:0]  Data_in,
			input wire [addr-1:0]  Addr,
			output wire [Data-1:0] Data_Out,
			
			input wire [63:0]      Data_Polynomial  

			
		 );

		initial begin
			Swap_Bus<=1'h0;
			end


		wire             w_A,w_B,w_C,w_D;	
		wire [1:0]       adbus_A,adbus_B,adbus_C,adbus_D;
		wire [Data-1:0]  data_in_A,data_in_B,data_in_C,data_in_D;
		wire [Data-1:0]  data_out_A,data_out_B,data_out_C,data_out_D;
		
		
		wire             w_A1,w_B1,w_C1,w_D1;	
		wire [1:0]       adbus_A1,adbus_B1,adbus_C1,adbus_D1;
		wire [Data-1:0]  data_in_A1,data_in_B1,data_in_C1,data_in_D1;
		wire [Data-1:0]  data_out_A1,data_out_B1,data_out_C1,data_out_D1;
		
		reg                    Swap_Bus;
		wire [Command_len-1:0] Command_Sequential;
		
	assign adbus_A=Swap_Bus?adbus_C1:adbus_A1;
	assign w_A=Swap_Bus?w_C1:w_A1;
	assign data_in_A=Swap_Bus?data_in_C1:data_in_A1;
	assign data_out_A1=Swap_Bus?data_out_C:data_out_A;
	
	
	assign adbus_C=Swap_Bus?adbus_A1:adbus_C1;
	assign w_C=Swap_Bus?w_A1:w_C1;
	assign data_in_C=Swap_Bus?data_in_A1:data_in_C1;
	assign data_out_C1=Swap_Bus?data_out_A:data_out_C;
	
	
	assign adbus_B=Swap_Bus?adbus_D1:adbus_B1;
	assign w_B=Swap_Bus?w_D1:w_B1;
	assign data_in_B=Swap_Bus?data_in_D1:data_in_B1;
	assign data_out_B1=Swap_Bus?data_out_D:data_out_B;
	
	
	assign adbus_D=Swap_Bus?adbus_B1:adbus_D1;
	assign w_D=Swap_Bus?w_A1:w_D1;
	assign data_in_D=Swap_Bus?data_in_B1:data_in_D1;
	assign data_out_D1=Swap_Bus?data_out_B:data_out_D;
	
	Sequential_state_machine Seq_Module (
			.clk(clk), 

		  
			.adbus_A(adbus_A1),	
			.data_in_A(data_out_A1),
 
			.adbus_B(adbus_B1),	
			.data_in_B(data_out_B1),

			.w_C(w_C1),  
			.adbus_C(adbus_C1),
			.data_out_C(data_in_C1),	

			.w_D(w_D1),  
			.adbus_D(adbus_D1),
			.data_out_D(data_in_D1),	
			
			.Data_Polynomial(Data_Polynomial),
			.Command(Command_Sequential)
	);
	
	assign Command_Sequential=Command;
	
	Ram_Interface_Module Ram_Interface(		
				.clk(clk),
				
				.a_w(wr_en),                               
				.a_adbus(Addr),
				.a_data_in(Data_in), 
				.a_data_out(Data_Out),  

				.b_w_A(w_A),  
				.b_adbus_A(adbus_A),
				.b_data_in_A(data_in_A),	
				.b_data_out_A(data_out_A),

				.b_w_B(w_B),  
				.b_adbus_B(adbus_B),
				.b_data_in_B(data_in_B),	
				.b_data_out_B(data_out_B),

				.b_w_C(w_C),  
				.b_adbus_C(adbus_C),
				.b_data_in_C(data_in_C),	
				.b_data_out_C(data_out_C),

				.b_w_D(w_D),  
				.b_adbus_D(adbus_D),
				.b_data_in_D(data_in_D),	
				.b_data_out_D(data_out_D)
			);
			
endmodule
