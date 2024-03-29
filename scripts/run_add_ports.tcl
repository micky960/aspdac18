date
set_host_options -max_cores 4
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true
set verilogout_no_tri tru
set html_log_enable true

set design   [getenv DESIGN]
set clkin    [getenv DESIGN_CLK]
set run_dir  synth_add_ports_$design

if {[file exist $run_dir]} {
sh rm -rf $run_dir
}

sh mkdir -p $run_dir/reports
sh mkdir -p $run_dir/netlist

set search_path [concat * $search_path]


sh rm -rf ./work_$design
define_design_lib WORK -path ./work_$design



  set_svf $design.svf

  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db\
                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db    \
                     /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db \
                   }

read_verilog -netlist ./synth_revert_$design/netlist/$design.v

create_cell UTIELO_CELL sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/TIELO_X1M_A9TH
create_cell UTIEHI_CELL sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/TIEHI_X1M_A9TH
create_net logic_net0
create_net logic_net1
connect_net logic_net0 UTIELO_CELL/Y
connect_net logic_net1 UTIEHI_CELL/Y

source ./create_port_${design}.tcl

write_file -hierarchy -format verilog -output "$run_dir/netlist/${design}_pre_opt.v"
report_qor

  set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*X0P*]
  create_clock -name CLK  -period 4  -waveform {0 2} $clkin

  set input_ports [remove_from_collection [all_inputs] {$clkin}]
  set output_ports [all_outputs]

  set_input_delay -max 1 [get_ports $input_ports ] -clock CLK
  set_input_delay -min 0 [get_ports $input_ports ] -clock CLK

  set_output_delay -max 1 [get_ports $output_ports ] -clock CLK
  set_output_delay -min 3 [get_ports $output_ports ] -clock CLK

date
#compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -gate_clock
compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
date
optimize_netlist -area
date
compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -incremental
mem -all -verbose

   change_names -hier -rule verilog

   write_file -hierarchy -format verilog -output "$run_dir/netlist/$design.v"
   write_sdc "$run_dir/netlist/$design.sdc"

set_switching_activity -toggle_rate 0 -period 100  -static_probability 0 [get_ports *fll*]
set_switching_activity -toggle_rate 5 -period 100  -static_probability 0.50 [remove_from_collection [all_inputs] [get_ports *fll*]]

propagate_switching_activity

   report_timing -delay max  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_max.rpt
   report_timing -delay min  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_min.rpt
   report_constraint -all_violators -verbose  -nosplit                             > $run_dir/reports/report_constraint.rpt
   check_design -nosplit                                                           > $run_dir/reports/check_design.rpt
   report_design                                                                   > $run_dir/reports/report_design.rpt
   report_area                                                                     > $run_dir/reports/report_area.rpt
   report_timing -loop                                                             > $run_dir/reports/timing_loop.rpt
   report_power -analysis_effort high                                              > $run_dir/reports/report_power.rpt
   report_qor                                                                      > $run_dir/reports/report_qor.rpt

exit
