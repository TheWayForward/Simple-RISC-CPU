// 算数逻辑运算单元（简称ALU）：根据不同的操作数进行加、与、抑或、跳转等算数或逻辑操作
module alu(
    // 时钟输入
	input clk,
    // 复位
	input rst_n,
    // 使能
	input en,
    // 累加器输入
	input [7:0] accu,
    // 数据总线输入
	input [7:0] data,
    // 操作数输入
	input [2:0] operation,
    // “运算结果为0”标志输出
	output zero,
    // 运算结果输出
	output reg [7:0] alu_out
);
	// 操作数助记符
	parameter 
	MOV = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STO = 3'b110,
	JMP = 3'b111;
	
    // 来自累加器的输入为0，则zero标志有效
	assign zero = !accu;
	
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) alu_out <= 8'bxxxx_xxxx;
		else
            // 如果使能，开始运算
			if (en) begin
				casex(operation)
                    // 8条指令
                    // MOV（传送），单目，直接输出累加器
                    MOV: alu_out <= accu;
                    // SKZ（为零跳转），单目，直接输出累加器
					SKZ :alu_out <= accu;
                    // ADD（相加），双目，累加器结果与数据总线输入的数据相加
					ADD :alu_out <= data + accu;
                    // AND（相与），双目，累加器结果与数据总线输入的数据相与
					AND :alu_out <= data & accu;
                    // XOR（相异或），双目，累加器结果与数据总线输入的数据相异或
					XOR :alu_out <= data ^ accu;
                    // LDA（访存），单目，输出访问到的数据
					LDA :alu_out <= data;
                    // STO（写回），单目，直接输出累加器
					STO :alu_out <= accu;
                    // JMP（无条件跳转），单目，直接输出累加器
					JMP :alu_out <= accu;
					default: alu_out <= 8'bxxxx_xxxx;
				endcase  
			end
	end

endmodule
