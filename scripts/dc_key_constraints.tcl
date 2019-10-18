set design [getenv "DESIGN"]
set node [getenv "NODE"]
set compile_seqmap_propagate_constants     false

#set search_path [concat * $search_path]
#sh rm -rf ./work/work_${design}
#define_design_lib WORK -path ./work/work_${design}
set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
set link_library   { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

#read_verilog -rtl ../../Results/${design}/final/${design}_eco.v
read_verilog -rtl ../../Results/${design}/${node}/${design}_eco.v

current_design $design
set x 0
foreach_in_collection pqr [get_nets *sfllKey*] {
#     if {$x < 128} {
        set x [expr $x + 1]
	set net_name [get_attribute $pqr full_name]
     	set tie_net  [get_attribute [all_fanin -to  $net_name -flat] full_name]
     	set tie_net_split [split $tie_net "\*\*"]
     	set tie_net_val   [lindex $tie_net_split 2]
     	create_port sfllKey_${x}_${tie_net_val}
     	connect_net $net_name sfllKey_${x}_${tie_net_val}
#     	} else {
#	break
#     }
}
set x 0
foreach_in_collection nvm_pins [get_pins nvm*/*] {
	set x [expr $x + 1]
	set port [get_attribute [get_ports sfllKey_${x}_*] full_name]
	disconnect_net [all_connected $port] $nvm_pins
}
remove_cell nvm*

current_design $design
check_design

  create_clock -name VCLK -period 10  -waveform {0 5}
  set input_ports  [all_inputs]
  set output_ports [all_outputs]

  set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
  set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK

  set_output_delay -max 2 [get_ports $output_ports ] -clock VCLK
  set_output_delay -min 1 [get_ports $output_ports ] -clock VCLK

ungroup -all -flatten
compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
#write -output  ../../Results/$design/final/${design}_final_combo.v -hierarchy -format verilog

#Modified 25/04
write -output  ../../Results/$design/${node}/${design}_temp.v -hierarchy -format verilog

#write_sdc "../../Results/$design/final/${design}_final_combo.sdc"

#Uncommented 25/04
#write_sdc "../../Results/$design/${node}/${design}_final_combo.sdc"

foreach_in_collection abc [get_ports sfllKey*] { 
  set abc [get_attribute $abc full_name]
  set pqr [split $abc "_"]
  set key_val [lindex $pqr 3]
   echo "add pin constraint $key_val $abc -Revised"
} > ../../Results/$design/${node}/key_constraints.do

foreach_in_collection abc [get_ports sfllKey*] {
  set abc [get_attribute $abc full_name]
  set pqr [split $abc "_"]
  set key_val [lindex $pqr 3]
   echo "$key_val"
} > ../../Results/$design/${node}/key_values.do

#write_file -hierarchy -format verilog -output "$run_dir/netlist/$design.v"

########### BEGIN AREA, POWER, AND DELAY CALCULATION ##############
#read_verilog -netlist ../../Results/$design/final/${design}_final_combo.v
#read_verilog -netlist ../../Results/$design/${node}/${design}_final_combo.v

#set_dont_touch $design
#source ../../Results/$design/final/${design}_final_combo.sdc
#source ../../Results/$design/${node}/${design}_final_combo.sdc

#compile_ultra 
#report_timing
#report_area > ../../Results/$design/${node}/area.rpt
#report_power

exit
