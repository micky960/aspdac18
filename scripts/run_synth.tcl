date
set_host_options -max_cores 8
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true

set design     [getenv DESIGN]
#set clkin      [getenv DESIGN_CLK]
#echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#echo  "!!!!!: DESIGN Clock is set to $design_clk"
#echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

set run_dir  synth4_tmax_$design

if {[file exist $run_dir]} {
sh rm -rf $run_dir
}

sh mkdir -p $run_dir/reports
sh mkdir -p $run_dir/netlist

  set search_path [concat * $search_path]

  define_design_lib WORK -path ./work
  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }


  read_verilog -netlist  ../Results/$design/final/${design}_final_combo.v

date
  set_dont_use  [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*]
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NAND2_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NOR2_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XNOR2_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/INV_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/BUF_*] dont_use false
  set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/DFF*Q_*] dont_use false
  set_dont_use  [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*X0P*]

 
 set_wire_load_model -name Medium
 set_max_area 0

 create_clock -name VCLK  -period 4  -waveform {0 2}

  set input_ports  [all_inputs]
  set output_ports [all_outputs]

  set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
  set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK

  set_output_delay -max 1 [get_ports $output_ports ] -clock VCLK
  set_output_delay -min 3 [get_ports $output_ports ] -clock VCLK



date
compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
date


   report_timing -delay max  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_max.rpt
   report_timing -delay min  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_min.rpt
   report_constraint -all_violators -verbose  -nosplit                             > $run_dir/reports/report_constraint.rpt
   check_design -nosplit                                                           > $run_dir/reports/check_design.rpt
   report_design                                                                   > $run_dir/reports/report_design.rpt
   report_area                                                                     > $run_dir/reports/report_area.rpt
   report_timing -loop                                                             > $run_dir/reports/timing_loop.rpt
   report_power -analysis_effort high                                              > $run_dir/reports/report_power.rpt
   report_qor                                                                      > $run_dir/reports/report_qor.rpt


change_name -rules verilog -hierarchy
set bus_naming_style "%s_%d"
define_name_rules verilog -target_bus_naming_style "%s_%d" -remove_port_bus
change_names -rules verilog -hier

write_file -hierarchy -format verilog -output "$run_dir/netlist/$design.v"
write_sdc "$run_dir/netlist/$design.sdc"


#exit
