	`timescale 1ns / 1ps
	//////////////////////////////////////////////////////////////////////////////////
	// Company: 
	// Engineer: 
	// 
	// Create Date:    09:51:19 06/27/2014 
	// Design Name: 
	// Module Name:    testt 
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
	

	
 
	
	module mul_8_module(
    		input  wire clk,
    		input  wire [7:0] mul_A,
    		input  wire [7:0] mul_B,
    		output reg  [15:0] mul_out,
			input wire In_Busy,
			output reg Out_Busy
    );
		wire [7:0] A, B;
      wire [15:0] d0 , d1 , d2 , d3 , d4 , d5 , d6 , d7 ;
		
		assign A=mul_A;
		assign B=mul_B;

    assign d0[7:0] = A[7:0];
    assign d0[15:8]=8'b0;

    assign d1 = B[0]?d0:8'b0;
    assign d2 = B[1]?d1^d0<<1:d1;
    assign d3 = B[2]?d2^d0<<2:d2;
    assign d4 = B[3]?d3^d0<<3:d3;
    assign d5 = B[4]?d4^d0<<4:d4;
    assign d6 = B[5]?d5^d0<<5:d5;
    assign d7 = B[6]?d6^d0<<6:d6;

    //assign mul_out = 
	//always @(posedge clk) begin
		//A <= mul_A;
		//B <= mul_B;
	//end
	
	always @(posedge clk) begin
		mul_out<=B[7]?d7^d0<<7:d7;
		if(!In_Busy)
			Out_Busy<=1'h0;
		else
			Out_Busy<=1'h1;
	end
	
	endmodule
  

module mul_16_module(
		 input       clk,
		 input[15:0] A,
		 input[15:0] B,
		 output[31:0] mul_16,
		 input wire In_Busy,
		 output wire Out_Busy
		 );
		wire[15:0] d0,d1,d2,d7;
		wire Out_Busy1,Out_Busy2,Out_Busy3;
		assign Out_Busy=Out_Busy1;
		
		mul_8_module mul1(
			.clk(clk),
			.mul_A(A[7:0]),
			.mul_B(B[7:0]),
			.mul_out(d0),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy1)
			);
		
		mul_8_module mul2(
			.clk(clk),
			.mul_A(A[7:0]^A[15:8]),
			.mul_B(B[7:0]^B[15:8]),
			.mul_out(d1),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy2)
			);
		
		mul_8_module mul3(
			.clk(clk),
			.mul_A(A[15:8]),
			.mul_B(B[15:8]),
			.mul_out(d2),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy3)
			);
		
			assign d7 = d1^d2^d0;
			assign mul_16[31:0] = {d2[15:8],((d2[7:0])^(d7[15:8])),((d0[15:8])^(d7[7:0])),d0[7:0]};
	
	endmodule

	
	
	module mul_32_module(
	    input wire         clk,
		 input  wire [31:0] A,
		 input  wire [31:0] B,
		 output wire [63:0] mul_32,
		 input wire In_Busy,
		 output wire Out_Busy
		 );
		wire[31:0] d0,d1,d2,d7;
		
		wire Out_Busy1,Out_Busy2,Out_Busy3;
		assign Out_Busy=Out_Busy1;
		
		mul_16_module mul1(
				.clk(clk),
				.A(A[15:0]),
				.B(B[15:0]),
				.mul_16(d0),
				.In_Busy(In_Busy),
				.Out_Busy(Out_Busy1)
				);
		
		mul_16_module mul2(
				.clk(clk),
				.A(A[15:0]^A[31:16]),
				.B(B[15:0]^B[31:16]),
				.mul_16(d1),
				.In_Busy(In_Busy),
				.Out_Busy(Out_Busy2)
				);
		
		mul_16_module mul3(
			.clk(clk),
			.A(A[31:16]),
			.B(B[31:16]),
			.mul_16(d2),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy3)
			);
		
			assign d7 = d1^d2^d0;
			assign mul_32[63:0] = {d2[31:16],((d2[15:0])^(d7[31:16])),((d0[31:16])^(d7[15:0])),d0[15:0]};
	
	endmodule
	
	
	module mul_64_module(
	    input  wire        clk,
		 input  wire [63:0] A,
		 input  wire [63:0] B,
		 output wire [127:0] mul_64,
		 input wire In_Busy,
		 output wire Out_Busy
		 
		 );
		wire[63:0] d0,d1,d2,d7;
		
		wire Out_Busy1,Out_Busy2,Out_Busy3;
		assign Out_Busy=Out_Busy1;
		
		mul_32_module mul1(
			 .clk(clk),
			.A(A[31:0]),
			.B(B[31:0]),
			.mul_32(d0),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy1)
			);
		
		mul_32_module mul2(
			.clk(clk),
			.A(A[31:0]^A[63:32]),
			.B(B[31:0]^B[63:32]),
			.mul_32(d1),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy2)
			);
		
		mul_32_module mul3(
			.clk(clk),
			.A(A[63:32]),
			.B(B[63:32]),
			.mul_32(d2),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy3)
			);
		
			assign d7 = d1^d2^d0;
			assign mul_64[127:0] = {d2[63:32],((d2[31:0])^(d7[63:32])),((d0[63:32])^(d7[31:0])),d0[31:0]};
	
	endmodule
	
	
	
	
	module mul_128_module(
		 input               clk,
		 input  wire [127:0] A,
		 input  wire [127:0] B,
		 output wire [255:0] mul_128,
		 input  wire         In_Busy,
		 output wire         Out_Busy
		 );
		 
		wire[127:0] d0,d1,d2,d7;
		
		wire Out_Busy1,Out_Busy2,Out_Busy3;
		assign Out_Busy=Out_Busy1;
		
		mul_64_module mul_641(
			.clk(clk),
			.A(A[63:0]),
			.B(B[63:0]),
			.mul_64(d0),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy1)
			);
		
		mul_64_module mul_642(
			.clk(clk),
			.A(A[63:0]^A[127:64]),
			.B(B[63:0]^B[127:64]),
			.mul_64(d1),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy2)
			);
		
		mul_64_module mul_643(
			.clk(clk),
			.A(A[127:64]),
			.B(B[127:64]),
			.mul_64(d2),
			.In_Busy(In_Busy),
			.Out_Busy(Out_Busy3)
			);
	
	assign d7 = d1^d2^d0;
		assign mul_128[255:0] = {d2[127:64],((d2[63:0])^(d7[127:64])),((d0[127:64])^(d7[63:0])),d0[63:0]};
	
	endmodule

