tclmode
set design $::env(DESIGN)
//set node $::env(NODE)
read_library -Both -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
read_design ../../files/benchfiles/${design}.v -golden
read_design ../../Results/$design/final/${design}_sfll_rem.v -revised
vpxmode
setenv design $DESIGN
//setenv node $NODE
dofile ../../Results/$design/final/key_constraints_final.do
set system mode lec
add compared points -all
compare
//set system mode setup
exit -force
