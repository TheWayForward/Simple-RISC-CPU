`timescale 1ns / 1ps

module address_multiplexer(
	input fetch,
	input [12:0] ir_addr,
	input [12:0] pc_addr,
	output [12:0] addr
);
	
	assign addr = fetch ? pc_addr : ir_addr;

endmodule
