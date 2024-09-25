// 只读存储器：只读不写，保存指令
module rom(
    // 读信号
	input rd,
    // 使能
	input en,
    // 地址总线
	input [12:0] addr,
    // 数据总线
	output [7:0] data
);

    // 8 * 256存储单元
	reg [7:0] mem [8'hff:0];
    // 使能与读信号均有效时，往数据总线写指定地址存储的数据，否则高阻
	assign data = (en & rd) ? mem[addr[7:0]] : 8'bzzzz_zzzz;

endmodule