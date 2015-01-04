`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:45:28 12/08/2014 
// Design Name: 
// Module Name:    Multiplication_Rom 
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


///Polynomial_len <128---- Addr 0
///Polynomial_len >128<256-----Addr 1
///Polynomial_len >256<384 ----Addr 2
///Polynomial_len >384<512-----Addr 3
///Polynomial_len >512    -----Addr 4

module Rom#(
parameter Data=16)(
   input  wire            clk,
	input  wire [5:0]      command,             //command to start pouring out Datas
	output reg  [Data-1:0] Data_Out_Opcode
	
	 );
	 
	 initial begin
		 Data_Out_Opcode<=32'h0;
		 counter<=6'h1;
		 end
		 
		reg [5:0] counter;
		reg start_counter,end_counter;  //var to start and stop counter
		wire [4:0] X;
		reg p;
		assign X=command[5]?command[4:0]:X;
		
	always @(posedge clk) begin
		if(command[5]) begin
			start_counter<=1'h1;
			end
		case(X)
		
		//128
			 5'h1:begin
					case(counter)
						4'h1:begin 
								Data_Out_Opcode<=16'b001_01_0_000;
								start_counter<=1'h0;
								end
						endcase // case Addr
				end
			//256
			5'h2:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b001_01_0_000;
				      4'h2: begin
							Data_Out_Opcode<=32'b010_01_1_000;
							start_counter<=1'h0;
							end
					endcase // case Addr
				end
			
		//384
		5'h3:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b001_01_0_000;
						4'h2: Data_Out_Opcode<=32'b010_01_1_000;
				      4'h3: begin
							Data_Out_Opcode<=32'b011_01_0_010;
							start_counter<=1'h0;
							end
					endcase // case Addr
			end
		
		//512
		5'h4:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b001_01_0_000;
				      4'h2: Data_Out_Opcode<=32'b010_01_1_000;
				      4'h3: Data_Out_Opcode<=16'b011_01_0_010;
						4'h4: begin
						      Data_Out_Opcode <=16'b100_01_1_010;
							   start_counter<=1'h0;
							end
					endcase // case Addr
			end
		
		//576
		5'h5:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b001_01_0_000;
				      4'h2: Data_Out_Opcode<=32'b010_01_1_000;
				      4'h3: Data_Out_Opcode<=16'b011_01_0_010;
						4'h4: Data_Out_Opcode <=16'b100_01_1_010;
						4'h5:begin
								Data_Out_Opcode <=16'b101_01_0_100;
								start_counter<=1'h0;
							end
					endcase // case Addr
			end
			
		
		///////////////////////Xor///////////////////////////////////////////
		4'h6:begin 
						case(counter)
						4'h1:begin
								Data_Out_Opcode<=16'b0_00_111_10_0_000;
								start_counter<=1'h0;
								end
						endcase // case Addr
				end
			//256
			5'h7:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b0_00_111_10_0_000;
				      4'h2: begin
							Data_Out_Opcode<=32'b0_01_111_10_0_010;
							start_counter<=1'h0;
							end
					endcase // case Addr
				end
			
		//384
		5'h8:begin
					case(counter)
						4'h1: Data_Out_Opcode<=16'b0_00_111_10_0_000;
						4'h2: Data_Out_Opcode<=32'b0_01_111_10_0_010;
				      4'h3: begin
							Data_Out_Opcode<=32'b0_10_111_10_0_100;
							start_counter<=1'h0;
							end
					endcase // case Addr
			end
		
		
		
		
		endcase //always 
	end
		
		always @(posedge clk) begin
				if(start_counter)
					counter<=counter+1'h1;
				else         //reset counter
					counter<=6'h0;   
			end
	 
endmodule
