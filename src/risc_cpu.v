// CPU顶层模块
module risc_cpu(
    // 时钟输入
	input clk,
    // 复位
	input rst_n,
    // 读信号，用于从RAM/ROM读取数据
	output rd,
    // 写信号，用于向RAM写入数据
	output wr,
    // 地址总线
	output [12:0] addr,
    // 数据总线
	inout [7:0] data
);
    
    // ALU使能
	wire alu_en;
    // “运算结果为0”标志
	wire zero;
    // IR使能
	wire load_ir; 
    // PC装载
    wire load_pc; 
    // 累加器使能
    wire load_acc;
    // PC自增
    wire pc_inc;
    // 数据控制器使能
    wire datacontrol_en;
    // 当前操作数
    wire [2:0] operation;
    // 累加器输出
	wire [7:0] accu;
    // ALU输出
    wire [7:0] alu_out;
    // PC地址
    wire [12:0] pc_addr;
    // IR地址
    wire [12:0] ir_addr;
	
    // PC：提供指令地址
	program_counter cpu_pc(
		.rst_n(rst_n),
		.load_pc(load_pc),
		.pc_inc(pc_inc),
		.ir_addr(ir_addr),
		.pc_addr(pc_addr)
	);

    // IR：在时钟信号的驱动下，将数据总线送来的指令存入其内部的寄存器
	instruction_register cpu_ir(
		.clk(clk),
		.rst_n(rst_n),
		.en(load_ir),
		.data(data),
		.operation(operation),
		.ir_addr(ir_addr)
	);
	
    // 累加器：存放当前的结果
	accumulator cpu_accu(
		.clk(clk),
		.rst_n(rst_n),
		.en(load_acc),
		.data(alu_out),
		.accu(accu)
	);
	
    // ALU：根据操作数，进行算数或逻辑操作
	alu cpu_alu(
		.clk(clk),
		.rst_n(rst_n),
		.en(alu_en),
		.accu(accu),
		.data(data),
		.operation(operation),
		.zero(zero),
		.alu_out(alu_out)
	);
	
    // 状态机：根据当前状态与指令，产生各模块控制信号，控制各模块实现程序预期功能
	state_machine cpu_sm(
		.clk(clk),
		.rst_n(rst_n),
		.zero(zero),
		.operation(operation),
        .fetch(fetch),
        .alu_en(alu_en),
		.pc_inc(pc_inc),
		.rd(rd),
		.wr(wr),
		.load_acc(load_acc),
		.load_ir(load_ir),
		.load_pc(load_pc),
		.datacontrol_en(datacontrol_en)
	);
	
    // 数据控制器：控制累加器的数据输出
	data_controller cpu_dc(
		.en(datacontrol_en),
		.data_in(alu_out),
		.data_out(data)
	);
	
    // 地址多路器：选择输出的地址为程序地址或数据地址
	address_multiplexer cpu_am(
		.fetch(fetch),
		.ir_addr(ir_addr),
		.pc_addr(pc_addr),
		.addr(addr)
	);

endmodule
