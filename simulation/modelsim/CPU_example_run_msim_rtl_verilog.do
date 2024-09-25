transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/altera/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/altera/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/altera/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/altera/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/altera/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/fiftyfivenm_ver
vmap fiftyfivenm_ver ./verilog_libs/fiftyfivenm_ver
vlog -vlog01compat -work fiftyfivenm_ver {c:/altera/quartus/eda/sim_lib/fiftyfivenm_atoms.v}
vlog -vlog01compat -work fiftyfivenm_ver {c:/altera/quartus/eda/sim_lib/mentor/fiftyfivenm_atoms_ncrypt.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/address_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/risc_cpu_with_peripherals.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/rom.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/ram.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/state_machine.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/risc_cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/program_counter.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/instruction_register.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/data_controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/address_multiplexer.v}
vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/src/accumulator.v}

vlog -vlog01compat -work work +incdir+C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/tb {C:/Users/TrWyFowrd/Desktop/Box/learning/learning_verilog/example/others/cpu/Simple-RISC-CPU/tb/risc_cpu_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  risc_cpu_tb

add wave *
view structure
view signals
run -all