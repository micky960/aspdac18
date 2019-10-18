set design   [getenv DESIGN]
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set timing_separate_clock_gating_group     true

set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db\
                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db    \
                     /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db \
                   }
set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*]
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NAND2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XNOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/INV_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/BUF_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/DFF*Q_*] dont_use false

#read_verilog -netlist ../../Results/$design/final/${design}_final_combo.v
analyze -library WORK -format sverilog ../../Results/$design/final/${design}_final_combo.v
elaborate $design

set key_ports [get_attribute [get_ports sfllKey_*] full_name]

source ../../Results/$design/final/key.tcl
puts $KEY
#puts [lindex $KEY 2]
set len [llength $KEY]
for {set i 1} {$i <= $len} {incr i} {
	set key_bit [lindex $KEY $i-1]
	set_case_analysis $key_bit sfllKey_${i}_logic_${key_bit}
	#puts [lindex $KEY $i-1]
}
create_clock -name VCLK -period 10  -waveform {0 5}
#create_clock -name VCLK [get_ports CK] -period 10 -waveform {0 5}
set input_ports  [all_inputs]
set output_ports [all_outputs]
set_input_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $input_ports]
set_output_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $output_ports]


#set_dont_touch $design
#source ../../Results/$design/final/${design}_final_combo.sdc
puts "THE LOCKED DESIGN SYNTHESIS"
check_design
compile_ultra 
report_timing > ../../Results/$design/final/locked_timing.rpt
report_area   > ../../Results/$design/final/locked_area.rpt
report_power  > ../../Results/$design/final/locked_power.rpt


remove_design -hier *
puts "THE ORIGINAL DESIGN SYNTHESIS"
analyze -library WORK -format sverilog ../../files/benchfiles/$design.v
elaborate $design

#current_design $design

create_clock -name VCLK -period 10  -waveform {0 5}
#create_clock -name VCLK [get_ports CK] -period 10 -waveform {0 5}

set input_ports  [all_inputs]
set output_ports [all_outputs]

set_input_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $input_ports]
set_output_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $output_ports]

#set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
#set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK

#set_output_delay -max 2 [get_ports $output_ports ] -clock VCLK
#set_output_delay -min 1 [get_ports $output_ports ] -clock VCLK

check_design
compile_ultra
write -format verilog -output ../../files/benchfiles/${design}_syn.v
read_verilog -netlist ../../files/benchfiles/${design}_syn.v
report_timing  > ../../Results/$design/final/orig_timing.rpt
report_area    > ../../Results/$design/final/orig_area.rpt
report_power   > ../../Results/$design/final/orig_power.rpt

exit

