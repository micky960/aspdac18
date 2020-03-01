tclmode

set design $::env(DESIGN)
set node $::env(NODE)
read_library -Revised -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
read_design ../../files/benchfiles/$design.v        			-golden
read_design ../../Results/$design/$node/${design}_temp.v -revised

echo $design
vpxmode
setenv design $DESIGN
setenv node $NODE
echo $design
echo  $node

dofile ../../Results/$design/$node/new_key_constraint.do

set system mode lec
add compared points -all
compare -NONEQ_stop 1
report compare data  -Summary > ../../Results/$design/$node/lec_key_constraint_log
exit -force
