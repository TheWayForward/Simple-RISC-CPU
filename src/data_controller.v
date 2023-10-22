`timescale 1ns / 1ps

module data_controller(
	input en,
	input [7:0] data_in,
	output [7:0] data_out
);

	assign data_out = en ? data_in : 8'bzzzz_zzzz;

endmodule
