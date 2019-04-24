// rename this file
tclmode
set design $::env(DESIGN)
set node $::env(NODE)
//set lib    $env(LIB)
//read_library -Both -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
//read_design ../../Results/${design}/final/${design}.v  -golden
read_design ../../Results/${design}/${node}/${design}.v  -golden

read_design ../../files/${design}.v -revised
set_system_mode lec
add_compared_points -all
compare > /home/projects/aspdac18/Results/$design/$node/lec_report
exit
