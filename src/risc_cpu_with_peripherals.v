// 带有外设（ROM、RAM、地址译码器）的CPU模块
module risc_cpu_with_prepherals(
    // 最简化，对外只暴露两个必要的接口（时钟输入、复位）
    input clk,
    input rst_n
);

    // 取指令信号
    wire fetch;
    // 操作数
    wire [2:0] operation;
    // 数据总线
    wire [7:0] data;
    // 地址总线
    wire [12:0] addr;
    // 程序计数器地址
    wire [12:0] pc_addr;
    // 指令寄存器地址，或指令地址
    wire [12:0] ir_addr;
    // RAM使能
    wire ram_en;
    // ROM使能
    wire rom_en;
    // 读信号
    wire rd;
    // 写信号
    wire wr;
    
    // CPU模块
    risc_cpu cpu(
        .clk(clk),
		.rst_n(rst_n),
		.rd(rd),
		.wr(wr),
		.addr(addr),
		.data(data)
    );

    // RAM模块
    ram ram(
        .clk(clk),
        .en(ram_en),
	    .rd(rd),
	    .wr(wr),
	    .addr(addr),
	    .data(data)
    );

    // ROM模块
    rom rom(
		.en(rom_en),
        .rd(rd),
		.addr(addr),
		.data(data)
    );

    // 地址译码器模块
    address_decoder address_decoder(
        .addr(addr),
		.rom_en(rom_en),
		.ram_en(ram_en)
    );

endmodule