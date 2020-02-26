set_host_options -max_cores 8
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true

set design      [getenv DESIGN]
set node        [getenv NODE]

  define_design_lib WORK -path ./work
  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

 analyze -format sverilog  ../../Results/$design/$node/${design}_eco.v
 elaborate $design

 create_clock -name VCLK  -period 10  -waveform {0 5}

  set input_ports  [all_inputs]
  set output_ports [all_outputs]

  set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
  set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK

  set_output_delay -max 1 [get_ports $output_ports ] -clock VCLK
  set_output_delay -min 0 [get_ports $output_ports ] -clock VCLK

ungroup -all -flatten
compile

change_name -rules verilog -hierarchy
set bus_naming_style "%s_%d"
define_name_rules verilog -target_bus_naming_style "%s_%d" -remove_port_bus
change_names -rules verilog -hier

write_file -hierarchy -format verilog -output ../../Results/$design/$node/${design}_eco_compile.v

exit
