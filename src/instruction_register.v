// 指令寄存器（简称：IR）：在时钟信号的驱动下，将数据总线送来的指令存入其内部的寄存器
module instruction_register(
    // 时钟输入
	input clk,
    // 复位
	input rst_n,
    // 使能
	input en,
    // 数据总线输入
	input [7:0] data,
    // 指令操作数
	output [2:0] operation,
    // 指令地址
	output [12:0] ir_addr
);
    // 寄存的指令
	reg [15:0] inst_reg;
    // 8位数据总线，16位指令，每条指令需要取2次
    // state的变化表示第1/2次取指令
	reg state;
	
    // 每条指令有16位
    // 前3位为操作数
	assign operation = inst_reg[15:13];
    // 后13位为地址
	assign ir_addr = inst_reg[12:0];

	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			state <= 1'b0;
			inst_reg <= 16'd0;
		end
		else begin
            // 在数据总线传输指令时使能
			if(en)
				casex(state)
					1'b0: begin
                        // 第一次取指，高8位
						inst_reg[15:8] <= data;
						state <= 1'b1;
					end
					1'b1: begin
                        //  第二次取指，低8位
						inst_reg[7:0] <= data;
						state <= 1'b0;
					end
					default: begin
						inst_reg <= 16'bxxxx_xxxx_xxxx_xxxx;
						state <= 1'bx;
					end
				endcase
			else state <= 1'b0;
		end
	end

endmodule
