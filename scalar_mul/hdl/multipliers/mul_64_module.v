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
    input[7:0] mul_A,
    input[7:0] mul_B,
    output[15:0] mul_out
    );
    wire [15:0] d0 , d1 , d2 , d3 , d4 , d5 , d6 , d7 ;

    assign d0[7:0] = mul_A[7:0];
    assign d0[15:8]=8'b0;

    assign d1 = mul_B[0]?d0:8'b0;
    assign d2 = mul_B[1]?d1^d0<<1:d1;
    assign d3 = mul_B[2]?d2^d0<<2:d2;
    assign d4 = mul_B[3]?d3^d0<<3:d3;
    assign d5 = mul_B[4]?d4^d0<<4:d4;
    assign d6 = mul_B[5]?d5^d0<<5:d5;
    assign d7 = mul_B[6]?d6^d0<<6:d6;

    assign mul_out = mul_B[7]?d7^d0<<7:d7;

	endmodule
  
	module mul_32_module(
		 input[31:0] A,
		 input[31:0] B,
		 output[63:0] mul_32
		 );
	wire[15:0] d0,d1,d2,d3,f1,f0,f,c0,c1,c2,c3,c5,c4,c6,g1,g2,g3,g4,g5,g6;//;wire[5:0] d7;wire[7:0] d2;
	mul_8_module mul1(
	(A[7:0]),
	(B[7:0]),
	(d0));
	
	mul_8_module mul2(
	(A[15:8]),
	(B[15:8]),
	(d1));
	
	mul_8_module mul3(
	(A[23:16]),
	(B[23:16]),
	(d2));
	
	mul_8_module mul4(
	(A[31:24]),
	(B[31:24]),
	(d3));
	
	assign f1 = d3^d2;
	assign  f0 = d1^d0;
	assign c6=d3;
	//assign f=f1^f0;
	mul_8_module mul5(
	(A[31:24])^A[23:16],
	(B[31:24])^B[23:16],
	g5);
	
	assign c5=g5^f1;
	mul_8_module mul6(
	(A[15:8])^A[31:24],
	(B[15:8])^B[31:24],
	g4);
	assign c4=g4^f1^d1;

	mul_8_module mul7(
	(A[7:0])^A[23:16],
	(B[7:0])^B[23:16],
	g2);
	assign c2=g2^f0^d2;

	mul_8_module mul8(
	(A[7:0])^A[15:8],
	(B[7:0])^B[15:8],
	g1);
	
	assign c1 =g1^f0;
	assign c0=d0;

	mul_8_module mul9(
	A[7:0]^A[23:16]^A[31:24]^A[15:8],
	B[7:0]^B[23:16]^B[31:24]^B[15:8],
	g3);
	
	assign c3=g3^c1^c2^c4^c5^c6^c0;


	assign mul_32 = {c6[15:8],c6[7:0]^c5[15:8],c5[7:0]^c4[15:8],c4[7:0]^c3[15:8],c3[7:0]^c2[15:8],c2[7:0]^c1[15:8],c1[7:0]^c0[15:8],c0[7:0]};     
	endmodule
	
	
	module mul_64_module(
		 input[63:0] A,
		 input[63:0] B,
		 output[127:0] mul_64
		 );
		wire[63:0] d0,d1,d2,d7;//;wire[5:0] d7;wire[7:0] d2;
		mul_32_module mul5(
		(A[31:0]),
		(B[31:0]),
		(d0));
		
		mul_32_module mul6(
		(A[31:0]^A[63:32]),
		(B[31:0]^B[63:32]),
		(d1));
		
		mul_32_module mul7(
		A[63:32],
		B[63:32],
		(d2));
		
			assign d7 = d1^d2^d0;
			assign mul_64[127:0] = {d2[63:32],((d2[31:0])^(d7[63:32])),((d0[63:32])^(d7[31:0])),d0[31:0]};
	
	endmodule
	
	
	
	
	module mul_128_module(
		 input[127:0] A,
		 input[127:0] B,
		 output[255:0] mul_128
		 );
		wire[127:0] d0,d1,d2,d7;//;wire[5:0] d7;wire[7:0] d2;
		mul_64_module mul_641(
		(A[63:0]),
		(B[63:0]),
		(d0));
		
		mul_64_module mul_642(
		(A[63:0]^A[127:64]),
		(B[63:0]^B[127:64]),
		(d1));
		
		mul_64_module mul_643(
		A[127:64],
		B[127:64],
		(d2));
	
	assign d7 = d1^d2^d0;
		assign mul_128[255:0] = {d2[127:64],((d2[63:0])^(d7[127:64])),((d0[127:64])^(d7[63:0])),d0[63:0]};
	
	endmodule

