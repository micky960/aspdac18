tclmode
//set design $env(DESIGN)
//set lib    $env(LIB)

set design $::env(DESIGN)

read_library -Revised -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
read_design ../../files/$design.v        			-golden
read_design ../../Results/$design/final/${design}_final_combo.v -revised

vpxmode
dofile ../../Results/$design/final/new_key_constraint.do

set system mode lec
add compared points -all
compare -NONEQ_stop 1
report compare data  -Summary > ../../Results/$design/final/lec_key_constraint_log
exit -force