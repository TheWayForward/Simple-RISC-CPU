`timescale 1ns / 1ps

module program_counter(
	input rst_n,
	input load_pc,
	input pc_inc,
	input [12:0] ir_addr,
	output reg [12:0] pc_addr
);

	always@(posedge pc_inc or negedge rst_n) begin
		if(!rst_n) pc_addr <= 13'd0;
		else begin
			if(load_pc) pc_addr <= ir_addr;
			else pc_addr <= pc_addr + 1'b1;
		end
	end

endmodule
