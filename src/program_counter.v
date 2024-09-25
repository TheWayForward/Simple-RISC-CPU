// 程序计数器：提供指令地址，CPU由此访问ROM的相应地址，以读取按照地址顺序存放在ROM中的指令
module program_counter(
    // 复位
	input rst_n,
    // 程序计数器装载信号
	input load_pc,
    // 程序计数器自增信号
	input pc_inc,
    // 指令地址
	input [12:0] ir_addr,
    // 程序计数器地址，表示当前执行到的指令
	output reg [12:0] pc_addr
);

	always@(posedge pc_inc or negedge rst_n) begin
		if(!rst_n) pc_addr <= 13'd0;
		else begin
            // 装载信号有效，将指令地址装载至程序计数器中，下一条指令直接从该地址执行
			if(load_pc) pc_addr <= ir_addr;
			// 否则程序计数器自增，指令按序执行
            else pc_addr <= pc_addr + 1'b1;
		end
	end

endmodule
