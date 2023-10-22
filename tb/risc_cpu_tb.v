`timescale 1ns/100ps
`define PERIOD 100

module risc_cpu_tb;
	reg rst_n, clk;
	integer test;
	reg [23:0] mnemonic;
	reg [12:0] pc_addr, ir_addr;
	wire [7:0] data;
	wire [12:0] addr;
	wire [12:0] cpu_pc_addr, cpu_ir_addr;
	wire [2:0] operation;
	wire fetch;
	wire rd, wr, halt, ram_en, rom_en;
	wire [7:0] cpu_sm_state;
	wire [7:0] cpu_clkgen_state;

	risc_cpu t_cpu(
		.clk(clk),
		.rst_n(rst_n),
		.rd(rd),
		.wr(wr),
		.operation(operation),
		.fetch(fetch),
		.halt(halt),
		.addr(addr),
		.pc_addr(cpu_pc_addr),
		.ir_addr(cpu_ir_addr),
		.data(data),
		.sm_state(cpu_sm_state),
		.clkgen_state(cpu_clkgen_state)
	); 

	ram_test t_ram(
		.en(ram_en),
		.rd(rd),
		.wr(wr),
		.addr(addr),
		.data(data)
	);
	
	rom_test t_rom(
		.rd(rd),
		.en(rom_en),
		.addr(addr),
		.data(data)
	);

	addr_decode t_addr_decode  (
		.addr(addr),
		.rom_en(rom_en),
		.ram_en(ram_en)
	);

	initial begin 
		clk = 1; 
		$timeformat(-9, 1, "ns", 12);
		sys_reset; 
		test3;
		$stop;
	end 

	task test1; 
		begin 
			test = 0; 
			disable MONITOR;
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_1_rom.dat",t_rom.mem); 
			$display("ROM loaded successfully!");
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_1_ram.dat", t_ram.mem);
			$display("RAM loaded successfully!");
			#1 test = 1;
			#14800;
			sys_reset; 
		end 
	endtask

	task test2; 
		begin 
			test = 0; 
			disable MONITOR;
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_2_rom.dat",t_rom.mem); 
			$display("ROM loaded successfully!");
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_2_ram.dat", t_ram.mem);
			$display("RAM loaded successfully!");
			#1 test = 2;
			#11300;
			sys_reset; 
		end 
	endtask

	task test3; 
		begin 
			test = 0; 
			disable MONITOR;
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_3_rom.dat",t_rom.mem); 
			$display("ROM loaded successfully!");
			$readmemb("C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/bin/test_3_ram.dat", t_ram.mem);
			$display("RAM loaded successfully!");
			#1 test = 3;
			#94000;
			sys_reset; 
		end 
	endtask

	task sys_reset; 
			begin 
			rst_n = 1;
			#(`PERIOD * 0.7) rst_n = 0;
			#(1.5 * `PERIOD) rst_n = 1; 
			#300;
		end 
	endtask

	always @ (test) begin: MONITOR 
		case(test)
			1:begin
				$display("\n ** RUNNING Test 1 ***");
				$display("\n TIME PC INSTR ADDR DATA");
				$display("------------------------------------");
				while(test == 1) @(t_cpu.cpu_am.pc_addr)
					if((t_cpu.cpu_am.pc_addr % 2 == 1) && (t_cpu.cpu_am.fetch == 1)) begin
						#60
						pc_addr <= t_cpu.cpu_am.pc_addr - 1; 
						ir_addr <= t_cpu.cpu_am.ir_addr;
						#340
						$display("\n%t %h %s %h %h", $time, pc_addr, mnemonic, ir_addr, data);
					end
			end
			
			2:begin
				$display("\n ** RUNNING Test 2 ***");
				$display("\n TIME PC INSTR ADDR DATA");
				$display("------------------------------------");
				while(test == 2) @(t_cpu.cpu_am.pc_addr) 
					if((t_cpu.cpu_am.pc_addr % 2 == 1) && (t_cpu.cpu_am.fetch == 1)) begin
						#60
						pc_addr <= t_cpu.cpu_am.pc_addr - 1; 
						ir_addr <= t_cpu.cpu_am.ir_addr;
						#340
						$display("%t %h %s %h %h", $time, pc_addr, mnemonic, ir_addr, data);
					end
			end
			
			3:begin
				$display("\n ** RUNNING Test 3 ***");
				$display("***This program should calculate the fibonacci***");
				$display("\n TIME        FIBONACCI NUMBER");
				$display("------------------------------------");
				while (test == 3) begin 
					wait(t_cpu.cpu_alu.operation == 3'h1)
					$display("%t %d", $time, t_ram.mem[10'h2]); 
					wait(t_cpu.cpu_alu.operation != 3'h1); 
				end
			end
		endcase
	end

	always @ (posedge halt) begin
	#500
		$display("\n****************************************");
		$display("*A HALT INSTRUCTION WAS PROCESSED !!!*");
		$display("****************************************\n");
	end

	always #(`PERIOD / 2) clk = ~clk;

	always @ (t_cpu.cpu_alu.operation) begin
		case(t_cpu.cpu_alu.operation)
			3'b000: mnemonic="HLT";
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

endmodule

module ram_test(
	input en,
	input rd,
	input wr,
	input [9:0] addr,
	inout [7:0] data
);

	reg [7:0] mem [10'h3ff:0];
	
	assign data = (rd & en)? mem[addr] : 8'bzzzz_zzzz;
	
	always @ (posedge wr) begin
		mem[addr] <= data;
	end

endmodule

module rom_test(
	input rd,
	input en,
	input [12:0] addr,
	output [7:0] data
);

	reg [7:0] mem [13'h1ff:0];
	assign data = (en & rd) ? mem[addr] : 8'bzzzz_zzzz;

endmodule

module addr_decode(
	input [12:0] addr,
	output reg rom_en,
	output reg ram_en
);

	always @ (addr) begin
		casex(addr)
			13'b1_0xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b10;
			13'b0_0xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b10;
			13'b1_1xxx_xxxx_xxxx: {rom_en, ram_en} <= 2'b01;
			default: {rom_en, ram_en} <= 2'b00;
		endcase
	end
  
endmodule
