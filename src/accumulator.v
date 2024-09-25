// 累加器：存放当前的结果，该结果可能来自读取的数据、运算的结果等
module accumulator(
    // 时钟输入
	input clk,
    // 复位
	input rst_n,
    // 使能
	input en,
    // 数据总线输入
	input [7:0] data,
    // 累加结果输出
	output reg [7:0] accu
);
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) accu <= 8'd0;
		else
        // 使能时，累加器保存数据总线传来的数据（来自ALU）
		if(en) accu <= data;
        // 否则保存的数据不变
		else accu <= accu;
	end

endmodule
