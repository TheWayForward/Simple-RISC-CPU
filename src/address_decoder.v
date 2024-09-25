// 地址译码器：根据不同的操作数，使能ROM或RAM
module address_decoder(
    // 地址总线
	input [12:0] addr,
    // ROM使能
	output reg rom_en,
    // RAM使能
	output reg ram_en
);
    // 监听地址总线传来的数据
    always @(addr) begin
        casex(addr)
            // 最高位为0，ROM使能，RAM关闭
	        13'b0_xxxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b10; 
            // 最高位为1，RAM使能，ROM关闭
	        13'b1_xxxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b01;
            // 其他情形，ROM、RAM均关闭
            default: {rom_en, ram_en} <= 2'b00;
        endcase
    end
  
endmodule