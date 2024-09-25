// 地址多路器：选择输出的地址为程序地址或数据地址
module address_multiplexer(
    // 取指令信号输入
	input fetch,
    // 指令寄存器地址输入
	input [12:0] ir_addr,
    // 程序计数器地址输入
	input [12:0] pc_addr,
    // 地址输出
	output [12:0] addr
);
	// 取指令信号有效，输出程序地址，否则输出指令中的地址
	assign addr = fetch ? pc_addr : ir_addr;

endmodule
