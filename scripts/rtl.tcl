## ORIGINAL DESIGN SYNTHESIS
set design   [getenv DESIGN]

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

puts "THE ORIGINAL DESIGN SYNTHESIS"
read_verilog -rtl ../../files/benchfiles/${design}.v
#analyze -library WORK -format sverilog ../../files/$design.v
#analyze -library WORK -format sverilog ../../files/benchfiles/${design}_temp.v
#elaborate $design

current_design $design

create_clock -name VCLK -period 10  -waveform {0 5}
#create_clock -name VCLK [get_ports CK] -period 10 -waveform {0 5}

set input_ports  [all_inputs]
set output_ports [all_outputs]

set_input_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $input_ports]
set_output_delay -clock [get_clocks VCLK] -add_delay 1 [get_ports $output_ports]


#set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
#set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK
#
#set_output_delay -max 1 [get_ports $output_ports ] -clock VCLK
#set_output_delay -min 0 [get_ports $output_ports ] -clock VCLK
check_design

compile_ultra
write -format verilog -output ../../files/benchfiles/${design}_syn.v
#read_verilog -netlist ../../files/benchfiles/${design}_syn.v
#report_timing
#report_area
#report_power

exit
