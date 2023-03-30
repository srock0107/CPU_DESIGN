transcript on
if ![file isdirectory cpu_top_iputf_libs] {
	file mkdir cpu_top_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "C:/Users/KB245-1-2/Desktop/1101/cputop/PLL_sim/PLL.vo"

vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/StatusRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/cpu_top.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/RegisterFile.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/ProgramCounter.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/InstrunctionRegister.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/DataPath.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/control.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/ArithmeticUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/AddressLogic.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/AddressingUnit.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/RAM_CORE.v}
vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop {C:/Users/KB245-1-2/Desktop/1101/cputop/ram.v}

vlog -vlog01compat -work work +incdir+C:/Users/KB245-1-2/Desktop/1101/cputop/simulation/modelsim {C:/Users/KB245-1-2/Desktop/1101/cputop/simulation/modelsim/cpu_top.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  cpu_top_vlg_tst

add wave *
view structure
view signals
run -all
