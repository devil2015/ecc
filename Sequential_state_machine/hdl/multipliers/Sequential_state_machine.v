`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Deepak Kapoor
// 
// Create Date:    16:22:39 12/05/2014 
// Design Name: 
// Module Name:    Sequential_state_machine 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:\ 
//
//////////////////////////////////////////////////////////////////////////////////
module Sequential_state_machine#(
	parameter Data=256,
	parameter Addr=2,
	parameter Command_len=6,
	parameter Opcode_Size=32,
	parameter Mul=1,
	parameter Sqr=2,
	parameter Inv=3,
	parameter Xor=4,
	parameter Red=5,
	parameter A=3'b001,
	parameter B=3'b010,
	parameter C=3'b011,
	parameter D=3'b100,
	parameter E=3'b101,
	parameter Fifo=3'b110,
	parameter  Ram_C=3'b111
		)(
		input wire	                 clk, 
  
		output wire	[Addr-1:0]       adbus_A,
		input wire	[Data-1:0]       data_in_A,	

		output wire	[Addr-1:0]       adbus_B,
		input wire	[Data-1:0]       data_in_B,	

		output wire	                 w_C,  
		output reg	[Addr-1:0]       adbus_C,	
		output reg	[Data-1:0]       data_out_C,

		output wire	                 w_D,  
		output wire	[Addr-1:0]       adbus_D,	
		output wire	[Data-1:0]       data_out_D,

		input wire	[63:0]            Data_Polynomial,
		input wire	[Command_len-1:0] Command
    );

				
		wire                 Out_Busy_Core2_Output,In_Busy_Core2_Inp,In_Busy_Core2_Cmd,Fifo_In_Busy_Core2_Inp;
		wire                 rd_en_Core2,wr_en_Core2_Cmd,wr_en_Core2_Inp,wr_en_Core2;
			 
		wire [1:0]           Data_in_Core2_Cmd,Data_in_Core1_Cmd;
		wire [Data-1:0]      Data_in_Core1_Msb,Data_in_Core1_Lsb,Data_Out_Core2,Data_Out_Core1;
		wire [127:0]         Data_in_Core2_A,Data_in_Core2_B;

	
		wire                   Cmmd_Transfer;
		wire [Opcode_Size-1:0] Data_Opcode,Opcode;
											  
		wire                   rd_en_temp,In_Busy_temp,Out_Busy_temp,wr_en_temp;
		
		wire [Data-1:0]        Data_Out_temp;
		
		//Temp reg to store final result of square and multiplication
	   reg  [Data-1:0]         temp_A,temp_B,temp_C,temp_D,temp_E;
		reg [Data-1:0]          Data_Out_Core1_Buffer;
		wire  [Data-1:0]         Data_In_temp;
		reg [Opcode_Size-1:0]   Delay_Opcode;
							
		assign adbus_A=Opcode[2:1];
		
		assign Data_in_Core1_Lsb[127:0]=(Delay_Opcode[4]?(Delay_Opcode[3]?
		                                (Delay_Opcode[5]?data_in_B[255:128]:data_in_B[127:0])
		                                :(Delay_Opcode[5]?Data_Out_Core1_Buffer[255:128]:Data_Out_Core1_Buffer[127:0]))
												  :(Delay_Opcode[3]?(Delay_Opcode[5]?Data_Out_temp[255:128]:Data_Out_temp[127:0])
												  :(Delay_Opcode[5]?data_in_A[255:128]:data_in_A[127:0])));

		assign Data_in_Core1_Lsb[255:128]=(Delay_Opcode[7]?(Delay_Opcode[6]?
		                                (Delay_Opcode[8]?data_in_B[255:128]:data_in_B[127:0])
		                                :(Delay_Opcode[8]?Data_Out_Core1_Buffer[255:128]:Data_Out_Core1_Buffer[127:0]))
												  :(Delay_Opcode[6]?(Delay_Opcode[8]?Data_Out_temp[255:128]:Data_Out_temp[127:0])
												  :(Delay_Opcode[8]?data_in_A[255:128]:data_in_A[127:0])));
												  
		assign Data_in_Core1_Cmd =Delay_Opcode[0]?2'b10:Delay_Opcode[5:4];
		assign adbus_B=Opcode[10:9];
		
		assign Data_in_Core1_Msb[127:0]=(Delay_Opcode[12]?(Delay_Opcode[11]?
		                                (Delay_Opcode[13]?data_in_B[255:128]:data_in_B[127:0])
		                                :(Delay_Opcode[13]?Data_Out_Core2[255:128]:Data_Out_Core2[127:0]))
												  :(Delay_Opcode[11]?(Delay_Opcode[13]?Data_Out_temp[255:128]:Data_Out_temp[127:0])
												  :(Delay_Opcode[13]?data_in_A[255:128]:data_in_A[127:0])));
												  
		assign Data_in_Core1_Msb[255:128]=(Delay_Opcode[15]?(Delay_Opcode[14]?
		                                (Delay_Opcode[16]?data_in_B[255:128]:data_in_B[127:0])
		                                :(Delay_Opcode[16]?Data_Out_Core2[255:128]:Data_Out_Core2[127:0]))
												  :(Delay_Opcode[14]?(Delay_Opcode[16]?Data_Out_temp[255:128]:Data_Out_temp[127:0])
												  :(Delay_Opcode[16]?data_in_A[255:128]:data_in_A[127:0])));
												  
     assign Data_in_Core2_A =	      Delay_Opcode[18]?(Delay_Opcode[17]?(Delay_Opcode[19]?
											   data_in_B[255:128]:data_in_B[127:0]):(Delay_Opcode[19]?
											   Data_Out_Core1_Buffer[255:128]:Data_Out_Core1_Buffer[127:0]))
										      :(Delay_Opcode[17]?(Delay_Opcode[19]?Data_Out_temp[255:128]
												:Data_Out_temp[127:0]):(Delay_Opcode[19]?data_in_A[255:128]
												:data_in_A[127:0]));

	  assign Data_in_Core2_B =	     	Delay_Opcode[21]?(Delay_Opcode[20]?(Delay_Opcode[22]?
											   data_in_B[255:128]:data_in_B[127:0]):(Delay_Opcode[22]?
											   Data_Out_Core1_Buffer[255:128]:Data_Out_Core1_Buffer[127:0]))
										      :(Delay_Opcode[20]?(Delay_Opcode[22]?Data_Out_temp[255:128]
												:Data_Out_temp[127:0]):(Delay_Opcode[22]?data_in_A[255:128]
												:data_in_A[127:0]));
												
	assign Data_In_temp            =Delay_Opcode[25]?(Delay_Opcode[24]?data_in_B:Data_Out_Core2):
											  Delay_Opcode[24]?Data_Out_Core1_Buffer:data_in_A;
												
	assign wr_en_Core2_Inp        =Delay_Opcode[23];	
	assign wr_en_Core2_Cmd        =Delay_Opcode[23];
	
	assign Data_in_Core2_Cmd      ={1'h0,Delay_Opcode[23]};
	

	
	assign rd_en_temp              =(Opcode[4])&(~Opcode[3])|(Opcode[7])&(~Opcode[6])|(Opcode[12])&
	                                (~Opcode[11])|(Opcode[15])&(~Opcode[14])|(Opcode[18]&(~Opcode[17]))
											  |(Opcode[21]&(~Opcode[20]))|(Opcode[31])|(Opcode[30]&Opcode[29]);
	
	assign rd_en_Core2             =(Opcode[4]&Opcode[3])|(Opcode[7]&Opcode[6])|(Opcode[12]&Opcode[11])|
	                                (Opcode[15]&Opcode[14])|(Opcode[18]&Opcode[17])|(Opcode[29]&(~Opcode[30]))
											  |(Opcode[24]&(~Opcode[25]));
		

			Fifo_Core_module Fifo_Core_Interface(
			
				.clk(clk),	
				// Core 1 Square ,Xor
				.Core1_Inp_A(Data_in_Core1_Msb),
				.Core1_Inp_B(Data_in_Core1_Lsb),   //input
            .Core1_Cmd(Data_in_Core1_Cmd),   //command
            .Data_Out_Core1(Data_Out_Core1),  //Output
				
				//Core 2 Fifo Multiplication
				.wr_en_Core2_Inp(wr_en_Core2_Inp),
				.Data_in_Core2_A(Data_in_Core2_A),
				.Data_in_Core2_B(Data_in_Core2_B),
				.In_Busy_Core2_Inp(In_Busy_Core2_Inp),  //Fifo Busy
         //command Fifo core2
				.wr_en_Core2_Cmd(wr_en_Core2_Cmd),
				.Data_in_Core2_Cmd(Data_in_Core2_Cmd),
				.In_Busy_Core2_Cmd(In_Busy_Core2_Cmd),
			//Data out Fifo 
				.rd_en_Core2_Output(rd_en_Core2),
				.Data_Out_Core2_Output(Data_Out_Core2),
				.Out_Busy_Core2_Output(Out_Busy_Core2_Output)
				);
							
			
			Rom Rom(
				.clk(clk),
				.command(Command),
				.Data_Out_Opcode(Opcode)
				);
				
				
				
				//storing intermeditiate result
		Fifo#(256,8) Fifo_temp_reg(
				.clk(clk),
				.wr_en(wr_en_temp),           //write enable
				.rd_en(rd_en_temp),            //read _enable
				.Data_in(Data_In_temp),
				.Data_out(Data_Out_temp),
				.In_Busy(In_Busy_temp),         //interupt indicate fifo full
				.Out_Busy(Out_Busy_temp) 
				);
				
		
		
		
		assign wr_en_temp=Delay_Opcode[25]|Delay_Opcode[24]|(~Delay_Opcode[24])|(~Delay_Opcode[25]);
													
		assign w_C       =Delay_Opcode[28]&Delay_Opcode[27]&Delay_Opcode[26];
		
	
		always @(posedge clk) begin
			Data_Out_Core1_Buffer<=Data_Out_Core1;
			
			Delay_Opcode<=Opcode;
			
			case(Opcode[28:26])
			A:begin
				temp_A<=Delay_Opcode[31]?(Delay_Opcode[30]?(Delay_Opcode[29]?
				       {Data_Out_temp[255:128],Data_Out_Core1_Buffer[255:128]}
				       :{Data_Out_temp[127:0],Data_Out_Core1_Buffer[255:128]})
						 :(Delay_Opcode[29]?Data_Out_temp:{Data_Out_Core1_Buffer[255:128],Data_Out_temp[255:128]}))
						 :(Delay_Opcode[30]?(Delay_Opcode[29]?{Data_Out_Core1_Buffer[127:0],Data_Out_temp[255:128]}
						 :Data_Out_Core1_Buffer):Delay_Opcode[29]?Data_Out_Core2:256'hz);
				end
			B:begin
				temp_B<=Delay_Opcode[31]?(Delay_Opcode[30]?(Delay_Opcode[29]?
				       {Data_Out_temp[255:128],Data_Out_Core1_Buffer[255:128]}
				       :{Data_Out_temp[127:0],Data_Out_Core1_Buffer[255:128]})
						 :(Delay_Opcode[29]?Data_Out_temp:{Data_Out_Core1_Buffer[255:128],Data_Out_temp[255:128]}))
						 :(Delay_Opcode[30]?(Delay_Opcode[29]?{Data_Out_Core1_Buffer[127:0],Data_Out_temp[255:128]}
						 :Data_Out_Core1_Buffer):Delay_Opcode[29]?Data_Out_Core2:256'hz);
				end
			C:begin
				temp_C<=Delay_Opcode[31]?(Delay_Opcode[30]?(Delay_Opcode[29]?
				       {Data_Out_temp[255:128],Data_Out_Core1_Buffer[255:128]}
				       :{Data_Out_temp[127:0],Data_Out_Core1_Buffer[255:128]})
						 :(Delay_Opcode[29]?Data_Out_temp:{Data_Out_Core1_Buffer[255:128],Data_Out_temp[255:128]}))
						 :(Delay_Opcode[30]?(Delay_Opcode[29]?{Data_Out_Core1_Buffer[127:0],Data_Out_temp[255:128]}
						 :Data_Out_Core1_Buffer):Delay_Opcode[29]?Data_Out_Core2:256'hz);
				end
			D:begin
				temp_D<=Delay_Opcode[31]?(Delay_Opcode[30]?(Delay_Opcode[29]?
				       {Data_Out_temp[255:128],Data_Out_Core1_Buffer[255:128]}
				       :{Data_Out_temp[127:0],Data_Out_Core1_Buffer[255:128]})
						 :(Delay_Opcode[29]?Data_Out_temp:{Data_Out_Core1_Buffer[255:128],Data_Out_temp[255:128]}))
						 :(Delay_Opcode[30]?(Delay_Opcode[29]?{Data_Out_Core1_Buffer[127:0],Data_Out_temp[255:128]}
						 :Data_Out_Core1_Buffer):Delay_Opcode[29]?Data_Out_Core2:256'hz);
				end
			E:begin
				temp_E<=Delay_Opcode[31]?(Delay_Opcode[30]?(Delay_Opcode[29]?
				       {Data_Out_temp[255:128],Data_Out_Core1_Buffer[255:128]}
				       :{Data_Out_temp[127:0],Data_Out_Core1_Buffer[255:128]})
						 :(Delay_Opcode[29]?Data_Out_temp:{Data_Out_Core1_Buffer[255:128],Data_Out_temp[255:128]}))
						 :(Delay_Opcode[30]?(Delay_Opcode[29]?{Data_Out_Core1_Buffer[127:0],Data_Out_temp[255:128]}
						 :Data_Out_Core1_Buffer):Delay_Opcode[29]?Data_Out_Core2:256'hz);
				end
			Ram_C:begin
				data_out_C<=Data_Out_Core1_Buffer;
				end
			endcase
			end
		
endmodule
