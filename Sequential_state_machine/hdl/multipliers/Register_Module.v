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


/// Transfer_Msb------1  Transfer- {128'h0,Data[255:128]}
/// Transfer_Msb------0  Transfer- Data[255:0]
module Register_Module#(
parameter Data=256)(
input  wire               clk,
input  wire               wr_reg,
input  wire  [Data-1:0]   Input_Data_A,
input wire   [Data-1:0]   Input_Data_B,
input  wire               Reg_fifo_In_Core2,
input  wire               Reg_fifo_In_Core1,

input  wire   [1:0]       Addr_Reg_A_1,
input  wire   [1:0]       Addr_Reg_A_2,
input  wire   [1:0]       Addr_Reg_B,

input wire    [1:0]       Data_A_B_Core1,        // 1 both contain data of reg_A. 2 data of Reg_B 0 data from both
input wire                Msb_Core1,             // 1  	Msb and 0 Lsb

input wire                Mul_Msb,

output reg   [Data-1:0]   Data_Out_Core1,
output reg   [Data-1:0]   Data_Out_Core2  
    );
	 
	
   reg [Data-1:0] Register_A[0:5],Register_B[0:5];
	
	reg [2:0]     X;
	
	always @(posedge clk) begin
	
	if(wr_reg)
		X<=2'h0;
	else
		X<=2'hz;
		
			case(X)
				2'h0:begin
					Register_A[0] <= Input_Data_A;
					Register_B[0] <= Input_Data_B;
					X<=2'h1;
					end
				2'h1:begin
					Register_A[1]<=Input_Data_A;
					Register_B[1] <=Input_Data_B;
					X<=2'h2;
					end
				2'h2:begin
					Register_A[2]<= Input_Data_A;
					Register_B[2] <=Input_Data_B;
					X<=2'h3;
					end
				endcase
			end


		always @(posedge clk) begin
		
			case(Data_A_B_Core1)
			2'h0:begin
				if(Msb_Core1)
					Data_Out_Core1<={Register_A[Addr_Reg_A_1][255:128],Register_B[Addr_Reg_A_2][255:128]};
					else
					Data_Out_Core1<={Register_A[Addr_Reg_A_1][127:0],  Register_B[Addr_Reg_A_2][127:0]};
					end
				
			2'h1:begin
					Data_Out_Core1<={Register_A[Addr_Reg_A_1][255:128],Register_A[Addr_Reg_A_2][127:0]};
				end
			2'h2:begin
					Data_Out_Core1<={Register_B[Addr_Reg_A_1][255:128],Register_B[Addr_Reg_A_2][127:0]};
					end
				endcase
				
				if(Mul_Msb)
					Data_Out_Core2<={Register_A[Addr_Reg_B][255:128],Register_B[Addr_Reg_B][255:128]};
					else
					Data_Out_Core2<={Register_A[Addr_Reg_B][127:0],  Register_B[Addr_Reg_B][127:0]};
					end
					
		
		
	endmodule				
	
		


 