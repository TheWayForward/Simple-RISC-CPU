`timescale 1ns / 1ps

module accumulator(
	input clk,
	input rst_n,
	input en,
	input [7:0] data,
	output reg [7:0] accu
);
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) accu <= 8'd0;
		else
		if(en) accu <= data;
		else accu <= accu; 
	end

endmodule
