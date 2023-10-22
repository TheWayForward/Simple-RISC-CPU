`timescale 1ns / 1ps

module alu(
	input clk,
	input rst_n,
	input en,
	input [7:0] accum,
	input [7:0] data,
	input [2:0] operation,
	output zero,
	output reg [7:0] alu_out
);
	
	parameter 
	HLT = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STO = 3'b110,
	JMP = 3'b111;
	
	assign zero = !accum;
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) alu_out <= 8'bxxxx_xxxx;
		else
			casex(operation)
				HLT :alu_out <= accum;
				SKZ :alu_out <= accum;
				ADD :alu_out <= data + accum;
				AND :alu_out <= data & accum;
				XOR :alu_out <= data ^ accum;
				LDA :alu_out <= data;
				STO :alu_out <= accum;
				JMP :alu_out <= accum;
				default: alu_out <= 8'bxxxx_xxxx;
			endcase  
	end

endmodule
