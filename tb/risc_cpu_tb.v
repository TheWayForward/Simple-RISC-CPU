`timescale 1ns/1ns

`define CLK_PERIOD 100

module risc_cpu_tb;
    
    // 时钟
    reg clk;
    // 复位
    reg rst_n;
    
    // 时钟生成
    always #(`CLK_PERIOD / 2) clk = ~clk;

    // 实例化CPU及其外设模块
    risc_cpu_with_peripherals rcwp(
        .clk(clk),
        .rst_n(rst_n)
    );

    // 使用ASCII表示的操作数
    reg [23:0] mnemonic;

    // 按你的需求，自定义观察的信号
    wire [7:0] state;
    wire [2:0] operation;
    wire [7:0] accu;
    wire [7:0] data;
    wire [7:0] alu_out;
    wire ram_en;
    wire wr;
    wire [12:0] addr;
    wire [7:0] result;

    assign state = rcwp.cpu.cpu_sm.state;
    assign operation = rcwp.cpu.operation;
    assign accu = rcwp.cpu.accu;
    assign data = rcwp.cpu.data;
    assign alu_out = rcwp.cpu.alu_out;
    assign ram_en = rcwp.ram_en;
    assign wr = rcwp.wr;
    assign addr = rcwp.addr;
    assign result = rcwp.ram.mem[8'h01];

    initial begin
        // 设置时间输出格式：-9（精确到纳秒）、1（小数点后保留1位）、"ns"（输出的时间单位为ns）、12（输出结果的最小长度）
        $timeformat(-9, 1, "ns", 12);
        // 将变量载入RAM
        load_ram;
        // 将指令载入ROM
        load_rom;
        // 系统复位
        reset;
        // 监听并输出计算结果的变化
        $monitor("%t %d", $time, rcwp.ram.mem[10'h2]);
        // 运行90000时间单位后，暂停仿真
        #90000 $stop;
    end

    // 将operation显示为ASCII指令助记符
    always @(operation) begin
        show_operation_mnemoic(operation);
    end

    // 使用$readmemb()将预先写好的二进制文件读取至RAM、ROM中
    task load_ram;
        begin
            $display("Loading RAM");
            $readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/bin/test_ram.dat", rcwp.ram.mem); 
            $display("RAM Load Success");
        end
    endtask

    task load_rom;
        begin
            $display("Loading ROM");
            $readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/bin/test_rom.dat", rcwp.rom.mem); 
            $display("ROM Load Success");
        end
    endtask

    // 复位任务
    task reset;
        begin
            clk = 1;
            $display("Resetting");
            rst_n = 0;
            #(`CLK_PERIOD * 2) rst_n = 1;
            $display("Reset Finished");
        end
    endtask

    // 将operation显示为ASCII指令助记符的任务
    task show_operation_mnemoic;
        input [2:0] operation;
        begin
            case(operation)
                3'h0: mnemonic="MOV";
			    3'h1: mnemonic="SKZ";
			    3'h2: mnemonic="ADD";
			    3'h3: mnemonic="AND";
			    3'h4: mnemonic="XOR";
			    3'h5: mnemonic="LDA";
			    3'h6: mnemonic="STO";
			    3'h7: mnemonic="JMP"; 
			    default: mnemonic="???"; 
            endcase
        end
    endtask

endmodule