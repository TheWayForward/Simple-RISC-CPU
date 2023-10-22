`timescale 1ns / 1ps

module risc_cpu(
	input clk,
	input rst_n,
	output rd,
	output wr,
	output [12:0] addr,
	output [12:0] pc_addr, ir_addr,
	output [2:0] operation,
	output fetch,
	output halt,
	output [7:0] sm_state, clkgen_state,
	inout [7:0] data
);

	wire alu_en, module_clk;
	wire zero;
	wire load_ir, load_pc, load_acc, pc_inc, datacontrol_en;
	wire [7:0] accum, alu_out;
	
	clk_generator cpu_clkgen(
		.clk(clk),
		.rst_n(rst_n),
		.alu_en(alu_en),
		.fetch(fetch),
		.state(clkgen_state)
	);
	
	instruction_register cpu_ir(
		.clk(clk),
		.rst_n(rst_n),
		.en(load_ir),
		.data(data),
		.operation(operation),
		.ir_addr(ir_addr)
	);
	
	accumulator cpu_accu(
		.clk(clk),
		.rst_n(rst_n),
		.en(load_acc),
		.data(alu_out),
		.accu(accum)
	);
	
	alu cpu_alu(
		.clk(clk),
		.rst_n(rst_n),
		.en(alu_en),
		.accum(accum),
		.data(data),
		.operation(operation),
		.zero(zero),
		.alu_out(alu_out)
	);
	
	state_machine cpu_sm(
		.clk(clk),
		.rst_n(rst_n),
		.zero(zero),
		.operation(operation),
		.en(fetch),
		.pc_inc(pc_inc),
		.rd(rd),
		.wr(wr),
		.load_acc(load_acc),
		.load_ir(load_ir),
		.load_pc(load_pc),
		.datacontrol_en(datacontrol_en),
		.halt(halt),
		.state(sm_state)
	);
	
	data_controller cpu_dc(
		.en(datacontrol_en),
		.data_in(alu_out),
		.data_out(data)
	);
	
	address_multiplexer cpu_am(
		.fetch(fetch),
		.ir_addr(ir_addr),
		.pc_addr(pc_addr),
		.addr(addr)
	);
	
	program_counter cpu_pc(
		.rst_n(rst_n),
		.load_pc(load_pc),
		.pc_inc(pc_inc),
		.ir_addr(ir_addr),
		.pc_addr(pc_addr)
	);

endmodule
