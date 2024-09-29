// 状态机：CPU的控制核心，根据当前状态与指令，产生各模块控制信号，控制各模块实现程序预期功能
module state_machine(
    // 时钟输入
	input clk,
    // 复位
	input rst_n,
    // 来自算数逻辑运算单元的“运算结果为0”标志输入
	input zero,
    // 操作数
	input [2:0] operation,
    // 取指令信号
    output reg fetch,
    // 算数逻辑运算单元使能信号
    output reg alu_en,
    // 程序计数器自增信号
	output reg pc_inc,
    // 读取存储器信号
	output reg rd,
    // 写入存储器信号
	output reg wr,
    // 累加器使能信号
	output reg load_acc,
    // 指令寄存器使能信号
	output reg load_ir,
    // 程序计数器装载使能信号
	output reg load_pc,
    // 数据控制器使能信号
	output reg datacontrol_en
);

    // 当前状态
	reg [7:0] state;

    // 指令助记符
	parameter 
	MOV = 3'b000,
	SKZ = 3'b001,
	ADD = 3'b010,
	AND = 3'b011,
	XOR = 3'b100,
	LDA = 3'b101,
	STO = 3'b110,
	JMP = 3'b111;

    // 定义状态
	parameter 
	IDLE = 8'b0000_0000,
	S1 = 8'b0000_0001,
	S2 = 8'b0000_0010,
	S3 = 8'b0000_0100,
	S4 = 8'b0000_1000,
	S5 = 8'b0001_0000,
	S6 = 8'b0010_0000,
	S7 = 8'b0100_0000,
	S8 = 8'b1000_0000;  
	
    // 次态
	reg [7:0] next_state;
	
    // 三段式状态机-次态逻辑
	always @(*) begin
		case(state)
			IDLE: next_state <= S1;
			S1: next_state <= S2;
			S2: next_state <= S3;
			S3: next_state <= S4;
			S4: next_state <= S5;
			S5: next_state <= S6;
			S6: next_state <= S7;
			S7: next_state <= S8;
			S8: next_state <= S1;
			default: next_state <= IDLE;
		endcase
	end
	
    // 三段式状态机-状态寄存器
	always@(posedge clk or negedge rst_n) begin
		if(!rst_n) state <= IDLE;
		else
			state <= next_state;
	end
	
	// 输出逻辑
	always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {pc_inc, rd, wr, load_acc} <= 4'b0000;
			{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
        end
		else control_cycle;
	end
	
    // 规定每个状态输出的信号
	task control_cycle;
		begin
			case(state)
				S1:begin
					{pc_inc, rd, wr, load_acc} <= 4'b0100;
					{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b10100;
				end

				S2:begin
					{pc_inc, rd, wr, load_acc} <= 4'b1100;
					{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b10100;
				end

				S3:begin
					{pc_inc, rd, wr, load_acc} <= 4'b0000;
					{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
				end

				S4:begin
                    {pc_inc, rd, wr, load_acc} <= 4'b1000;
					{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b01000;
				end

				S5:begin
                    if(operation == JMP) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b01010;
					end
					else if(operation == ADD || operation == AND || operation == XOR || operation == LDA) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0100;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b01000;
					end
					else if(operation == STO) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b01001;
					end
					else begin
                        // MOV or SKZ
						{pc_inc, rd, wr, load_acc} <= 4'b0001;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b01000;
					end

				end

				S6:begin
					if(operation == ADD || operation == AND || operation == XOR || operation == LDA) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0101;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
					else if(operation == SKZ && zero) begin
						{pc_inc, rd, wr, load_acc} <= 4'b1000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
					else if(operation == JMP) begin
						{pc_inc, rd, wr, load_acc} <= 4'b1000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00010;
					end
					else if(operation == STO) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0010;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00001;
					end
					else begin
                        // MOV
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
				end

				S7:begin
					if(operation == ADD || operation == AND || operation == XOR || operation == LDA) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0100;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
					else if(operation == STO) begin
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00001;
					end
					else begin
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
				end

				S8:begin
					if(operation == SKZ && zero) begin
						{pc_inc, rd, wr, load_acc} <= 4'b1000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
					else begin
						{pc_inc, rd, wr, load_acc} <= 4'b0000;
						{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
					end
				end
                
				default:begin
					{pc_inc, rd, wr, load_acc} <= 4'b0000;
					{fetch, alu_en, load_ir, load_pc, datacontrol_en} <= 5'b00000;
				end
			endcase
		end
	endtask

endmodule
