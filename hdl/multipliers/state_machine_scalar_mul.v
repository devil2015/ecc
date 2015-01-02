`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:56:23 10/17/2014 
// Design Name: 
// Module Name:    state-machine_scalar_mul 
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

module state_machine_scalar_mul #(
		parameter Data=255,
		parameter Addr=5)(

		input  wire             clk,
		input  wire             a_w,
		input  wire   [Addr:0]  a_adbus,           //Address Bus
		input  wire   [Data:0]  a_data_in,         //Data bus for taking input
		output wire   [Data:0]  a_data_out        //Data bus for taking output
	 );
	 
	 reg [5:0]    address_bus;
	 reg [1:0]    no_of_chunks;
	 reg [Data:0] Data_Polynomial;
	 reg [9:0]    Data_len_Polynomial;
	 reg [2:0]    fsm;
	 reg [3:0]    count;
	 reg         start;
	 reg [5:0]   start_address;
	 wire [Data:0] status;
	 wire [Data:0] command;             
	 
	 initial begin
		start <= 1'h0;
		count <= 2'h0; 
		start_address<=6'h14;
		$dumpfile("test.vcd");
		$dumpvars();
	
	 end
	 

	 wire [Data:0]  data_out_outer;
	 reg  [575:0]   private_key;
	 
	  always @(posedge clk) begin         //calculating Polynomial and length of polynomial
			if(command==256'h2) begin
				address_bus<=start_address;
				count<=2'h1;
				end
			 if(count[0]) begin
				count<=3'h0;
				fsm<=3'h1;
				 address_bus<=start_address+1'h1;
				end
				
			case (fsm)
			
			3'h1:begin
				Data_Polynomial<=data_out_outer;
				address_bus<=start_address+2'h2;
				fsm<=3'h2;
				end
					
			3'h2:begin
				fsm<=3'h3;
				Data_len_Polynomial<=Data_Polynomial[41:32];
				no_of_chunks=(Data_Polynomial[41:32]/9'h100+1'h1);
				private_key[575:512]<=data_out_outer[63:0];
				address_bus<=start_address+2'h3;				
				end
				
			3'h3:begin
				fsm<=3'h4;
				private_key[511:256]<=data_out_outer;				
				end
				
			3'h4:begin
				fsm<=3'h5;
				private_key[255:0]<=data_out_outer;
				end				
        endcase				
		end
	
		
	assign adbus_outer1 = (transfer_running)?adbus_outer_transfer:address_bus;
	wire [Addr:0]  adbus_outer1;
	
	
	Ram_interface_scalar_mul Ram_interface_scalar_mul (
	
			.clk(clk), 	//data coming from testbench			
			.a_w(a_w), 
			.a_adbus(a_adbus), 
			.a_data_in(a_data_in),     
			.a_data_out(a_data_out),		
			
			.b_w(b_outer), //ram-interface which inturn interfaces with scalar multiplication module
			.b_adbus(adbus_outer1), 
			.b_data_in(data_in_to_outer), 
			.b_data_out(data_out_outer),
			.command(command),
			.status(status)
			);		

	wire [5:0]    adbus_outer_transfer,adbus_inner;
	wire [Data:0] data_in_to_outer,data_in_inner,data_out_frm_inner;	
	
	wire cmd_transfer_scalar_mul,interupt_trensfer;
	wire w_inner,transfer_running,read_write_command_scalar_mul,interupt_transfer;
	wire b_outer;
	
	Ram_transfer_scalar_mul Ram_transfer_scalar_mul (
		.clk(clk), 
		.b_w(b_outer), 
		.b_adbus(adbus_outer_transfer), 				
		.b_data_in(data_in_to_outer), 
		.b_data_out(data_out_outer),
		
		.a_w(w_inner), 
		.a_adbus(adbus_inner), 
		.a_data_in(data_in_inner), 
		.a_data_out(data_out_frm_inner),


		.read_write_command(read_write_command_scalar_mul),
		.read_address(read_address),
		.write_address(write_address),
		.no_of_chunks(no_of_chunks),
		.command_transfer(cmd_transfer_scalar_mul),
		.interupt_transfer(interupt_transfer),
		.transfer_running(transfer_running)
	);
	
 wire interupt_point_double,interupt_point_addition;
		state_machine_point_add state_machine_add_double (
				.clk(clk), 
				.w_RAM_outer_PORT(w_inner), 
				.adbus_RAM_outer_PORT(adbus_inner), 
				.data_in_RAM_outer_PORT(data_in_inner), 
				.data_out_RAM_outer_PORT(data_out_frm_inner), 
				.no_of_chunks(no_of_chunks),
				.command(command_add_double),
				.Data_len_Polynomial(Data_len_Polynomial),
				.Data_Polynomial(Data_Polynomial),
				.interupt_point_double(interupt_point_double),
				.interupt_point_addition(interupt_point_addition)
			);
	
	wire [5:0] read_address, write_address;		
	wire [1:0] command_add_double;

	// Instantiate the Unit Under Test (UUT)
	scalar_multiplication_module scalar_multiplication_module (	
		.clk(clk), 
		
		.interupt_point_add(interupt_point_addition), 
		.interupt_point_double(interupt_point_double), 
		.interupt_ram_transfer(interupt_transfer), 
		.command(command),
		.read_write_command(read_write_command_scalar_mul), 
		
		.read_address(read_address), 
		.write_address(write_address),
		.cmd_transfer(cmd_transfer_scalar_mul),
		.command_add_double(command_add_double),
		.scalar_multiplication(private_key),
		.status(status)
		);
		
endmodule
