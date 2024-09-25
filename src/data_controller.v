// 数据控制器：控制累加器的数据输出
module data_controller(
    // 使能
	input en,
    // 数据总线输入
	input [7:0] data_in,
    // 地址总线输出
	output [7:0] data_out
);

    // 使能时，将累加器数据输出至地址总线，其余时间呈高阻态
	assign data_out = en ? data_in : 8'bzzzz_zzzz;

endmodule
