// 随机存取存储器：可读可写，保存变量
module ram(
    // 时钟输入
    input clk,
    // 使能
	input en,
    // 读信号
	input rd,
    // 写信号
	input wr,
    // 地址总线
	input [12:0] addr,
    // 数据总线
	inout [7:0] data
);

    // 8 * 256存储单元
	reg [7:0] mem [8'hff:0];
	
    // 使能与读信号均有效时，往数据总线写指定地址存储的数据，否则高阻
	assign data = (en & rd)? mem[addr[7:0]] : 8'bzzzz_zzzz;
	
    // 检测到写信号，将数据总线上的数据存入指定地址
    always @(posedge wr) begin
        mem[addr[7:0]] <= data;
    end

endmodule