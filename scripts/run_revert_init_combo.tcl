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
set clk      [getenv DESIGN_CLK]
set run_dir  synth_revert_init_combo_$design

if {[file exist $run_dir]} {
sh rm -rf $run_dir
}

sh mkdir -p $run_dir/reports
sh mkdir -p $run_dir/netlist

set search_path [concat * $search_path]

sh rm -rf ./work
define_design_lib WORK -path ./work

  set_svf $design.svf

  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db\
                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db    \
                     /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db \
                   }

#read_verilog -netlist ./synth_fll_key_$design/netlist/$design.v

  read_verilog -rtl  ../files/${design}.v  

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
#../Results/$design/final/${design}_final_combo.v

create_port $clk
create_net  $clk
connect_net $clk $clk
foreach_in_collection abc [get_ports *_DFXLAB_* -filter "direction == in"] {
  set port_name  [get_attribute $abc full_name]
  set pqr        [regsub -all {_DFXLAB_} $port_name :]
  set inst_split [split $pqr ":"]
  set libcell    [lindex $inst_split 0]
  set inst_name  [lindex $inst_split 1]
  set rs_pin     [lindex $inst_split 2]
  set q_net      [lindex $inst_split 3]
  create_cell    $inst_name sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/$libcell 
  set q_net_size [sizeof_collection [all_connected $port_name]]
  if {$q_net_size > 1} {
    connect_net    *${port_name}* $inst_name/Q
    remove_port    $port_name
  } else {
    connect_net    [all_connected *${port_name}*] $inst_name/Q
    remove_port    $port_name
 }
  connect_net    $clk $inst_name/CK
}

foreach_in_collection abc [get_ports *_DFXLAB_* -filter "direction == out && (full_name =~ *_D_* || full_name =~ *_Q_*)"] {
  set port_name  [get_attribute $abc full_name]
  set pqr        [regsub -all {_DFXLAB_} $port_name :]
  set inst_split [split $pqr ":"]
  set libcell    [lindex $inst_split 0]
  set inst_name  [lindex $inst_split 1]
  set rs_pin     [lindex $inst_split 2]
  set d_net      [lindex $inst_split 3]
  set d_net_size [sizeof_collection [all_connected $port_name]]
  if {$d_net_size > 1} {
    connect_net    *${port_name}* $inst_name/D
    remove_port    $port_name
  } else {
    connect_net    [all_connected *${port_name}*] $inst_name/D
    remove_port    $port_name
 }
}

foreach_in_collection abc [get_ports *_DFXLAB_* -filter "direction == out && (full_name =~ *_R_* || full_name =~ *_S_*)"] {
  set port_name  [get_attribute $abc full_name]
  set pqr        [regsub -all {_DFXLAB_} $port_name :]
  set inst_split [split $pqr ":"]
  set libcell    [lindex $inst_split 0]
  set inst_name  [lindex $inst_split 1]
  set rs_pin     [lindex $inst_split 2]
  set rs_net     [lindex $inst_split 3]
  set rs_net_size [sizeof_collection [all_connected $port_name]]
  if {$rs_net_size > 1} {
    connect_net    *${port_name}* $inst_name/${rs_pin}*
    remove_port    $port_name
  } else {
    connect_net    [all_connected *${port_name}*] $inst_name/${rs_pin}*
    remove_port    $port_name
 }
}

if {[file exist ${design}_clk_connect.tcl]} {
source ${design}_clk_connect.tcl
}
#set_fix_multiple_port_nets -all -buffer_constant
change_name -rules verilog -hierarchy
set bus_naming_style "%s_%d"
define_name_rules verilog -target_bus_naming_style "%s_%d" -remove_port_bus
change_names -rules verilog -hier

write_file -hierarchy -format verilog -output "$run_dir/netlist/$design.v"
write_sdc "$run_dir/netlist/$design.sdc"
