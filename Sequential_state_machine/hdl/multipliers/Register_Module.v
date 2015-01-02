`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:14 12/08/2014 
// Design Name: 
// Module Name:    Register_Module 
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
module Register_Module#(
parameter Data=256,
parameter Mul=1,
parameter Sqr=2,
parameter Inv=3,
parameter Xor=4)(
input  wire             clk,
input  wire  [2*Data-1:0] Data_in,
input  wire   [2:0]     command,
input  wire             fifo_dump,
output reg   [Data-1:0] Data_Out_A,
output reg   [Data-1:0] Data_Out_B,

input  wire  [9:0]       Polynomial_Length  
    );
	 
	 
   reg [Data-1:0] Input_Mul_A[0:2];
	reg [Data-1:0] Input_Mul_B[0:2];
	
	reg [Data-1:0] Input_Sqr[0:2];
	reg [Data-1:0] Input_Inv[0:2];
	
	reg [Data-1:0] Input_Xor_A[0:2];
	reg [Data-1:0] Input_Xor_B[0:2];
	
	
	//Temporary Register for storing intermidiate result
	reg [Data-1:0] Temp_result_Mul[0:5];
	reg [Data-1:0] Temp_result_Sqr[0:5];
	reg [Data-1:0] Temp_result_Xor[0:2];
	reg [Data-1:0] Temp_result_Inv[0:2];
	reg [2:0] X,Z;
	
	
	wire [Data-1:0] Input_Data_A,Input_Data_B;
	
	assign Input_Data_A=Data_in[255:0];
	assign Input_Data_B=Data_in[511:256];
	
	wire [2:0] Y;
	
	assign Y=(command[2:0]!=3'h0)?command:Y;
	always @(posedge clk) begin
	
	case(command) 
		Mul:begin
			case(X)
				2'h0:begin
					Input_Mul_A[0]<=Input_Data_A;
					Input_Mul_B[0] <=Input_Data_B;
					if(Polynomial_Length[9])
						X<=2'h1;
					else
						X<=2'h3;
					end
				2'h1:begin
					Input_Mul_A[1]<=Input_Data_A;
					Input_Mul_B[1] <=Input_Data_B;
					
					if(Polynomial_Length[5])
						X<=2'h2;
					else
						X<=2'h3;
					end
				2'h2:begin
					Input_Mul_A[2]<=Input_Data_A;
					Input_Mul_B[2] <=Input_Data_B;
					X<=2'h3;
					end
				endcase
			end
		Sqr:begin
			case(X)
				2'h0:begin
					Input_Sqr[0]<=Input_Data_A;
					if(Polynomial_Length[9])
						X<=2'h1;
					else
						X<=2'h4;
					end
				2'h1:begin
					Input_Sqr[1]<=Input_Data_A;	
					if(Polynomial_Length[5])
						X<=2'h2;
					else
						X<=2'h4;
					end
				2'h2:begin
					Input_Sqr[2]<=Input_Data_A;
					X<=2'h4;
					end
				endcase
				end
					
				Inv:begin
					case(X)
						2'h0:begin
							Input_Inv[0]<=Input_Data_A;
							if(Polynomial_Length[9])
								X<=2'h1;
							else
								X<=2'h5;
							end
						2'h1:begin
							Input_Inv[1]<=Input_Data_A;
							if(Polynomial_Length[5])
								X<=2'h1;
							else
								X<=2'h5;
							end
						2'h2:begin
							Input_Inv[2]<=Input_Data_A;
							X<=2'h5;
							end
						endcase
					end
					
				Xor:begin
					case(X)
						2'h0:begin
							Input_Xor_A[0]<=Input_Data_A;
							Input_Xor_B[0]<=Input_Data_B;
							if(Polynomial_Length[9])
								X<=2'h1;
							else
								X<=2'h6;
							end
						2'h1:begin
							Input_Xor_A[1]<=Input_Data_A;
							Input_Xor_B[1]<=Input_Data_B;
							if(Polynomial_Length[5])
								X<=2'h2;
							else
								X<=2'h6;
							end
						2'h2:begin
							Input_Xor_A[2]<=Input_Data_A;
							Input_Xor_B[2]<=Input_Data_B;
							X<=2'h6;
							end
						endcase
					end
					default:begin
						X<=2'h0;
				end	
	endcase
	end //al



		always @(posedge clk) begin
		if(fifo_dump) begin
			case(Y)
			 Mul:begin
				case(Z)
					2'h0:begin
						Data_Out_A<=Input_Mul_A[0];
						Data_Out_B<=Input_Mul_B[0];
						if(Polynomial_Length[9])
						Z<=2'h1;
					else
						Z<=2'h3;
					end
				2'h1:begin
					Data_Out_A<=Input_Mul_A[1];
					Data_Out_B<=Input_Mul_B[1];
					
					if(Polynomial_Length[5])
						Z<=2'h2;
					else
						Z<=2'h3;
					end
				2'h2:begin
					Data_Out_A<=Input_Mul_A[2];
					Data_Out_B<=Input_Mul_B[2];
					Z<=2'h3;
					end
				endcase
			end
		Sqr:begin
			case(Z)
				2'h0:begin
					Data_Out_A<=Input_Sqr[0];
					if(Polynomial_Length[9])
						Z<=2'h1;
					else
						Z<=2'h3;
					end
				2'h1:begin
					Data_Out_A<=Input_Sqr[1];	
					if(Polynomial_Length[5])
						Z<=2'h2;
					else
						Z<=2'h3;
					end
				2'h2:begin
					Data_Out_A<=Input_Sqr[2];
					Z<=2'h3;
					end
				endcase
				end
					
				Inv:begin
					case(Z)
						2'h0:begin
							Data_Out_A<=Input_Inv[0];
							if(Polynomial_Length[9])
								Z<=2'h1;
							else
								Z<=2'h3;
							end
						2'h1:begin
							Data_Out_A<=Input_Inv[1];
							if(Polynomial_Length[5])
								Z<=2'h1;
							else
								Z<=2'h3;
							end
						2'h2:begin
							Data_Out_A<=Input_Inv[2];
							Z<=2'h3;
							end
						endcase
					end
					
				Xor:begin
					case(Z)
						2'h0:begin
							Data_Out_A<=Input_Xor_A[0];
							Data_Out_B<=Input_Xor_B[0];
							if(Polynomial_Length[9])
								Z<=2'h1;
							else
								Z<=2'h3;
							end
						2'h1:begin
							Data_Out_A<=Input_Xor_A[1];
							Data_Out_B<=Input_Xor_B[1];
							if(Polynomial_Length[5])
								Z<=2'h2;
							else
								Z<=2'h3;
							end
						2'h2:begin
							Data_Out_A<=Input_Xor_A[2];
							Data_Out_B<=Input_Xor_B[2];
							Z<=2'h3;
							end
						endcase
					end
					default:begin
						Z<=2'h0;
				end			
		endcase   //case Y
		end   //if
		end  //always
		endmodule
		


 