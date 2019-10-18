set design   [getenv DESIGN]

set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*]
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/INV_*] dont_use false

read_verilog -netlist ../../Results/locked_files/$design.v
#analyze -library WORK -format sverilog ../../Results/locked_files/$design.v
elaborate $design
current_design $design

create_clock -name VCLK -period 10  -waveform {0 5}
set input_ports  [all_inputs]
set output_ports [all_outputs]

set_input_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $input_ports]
set_output_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $output_ports]

check_design

compile_ultra

#compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
write -format verilog -output ../../Results/locked_files/${design}_fall_attack.v

exit

