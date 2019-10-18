//// This file compares the original file with fault removed file stored in the nodes folder.

tclmode
set design $::env(DESIGN)
set node $::env(NODE)
//set lib    $env(LIB)
//read_library -Both -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
//read_design ../../Results/${design}/final/${design}.v  -golden

//read_design ../../files/benchfiles/${design}.v -golden
read_design ../../Results/${design}/${node}/${design}.v  -golden
read_design ../../files/benchfiles/${design}.v -revised

set_system_mode lec
add_compared_points -all

compare


//analyze_eco -Effort ultra -REPLACE ../../Results/${design}/final/${design}_patch.v
analyze_eco -Effort ultra -REPLACE ../../Results/${design}/${node}/${design}_patch.v

set_system_mode setup
//read_design ../../Results/${design}/final/${design}_patch.v  -Append
read_design ../../Results/${design}/${node}/${design}_patch.v  -Append

apply_patch ${design} ${design}_eco
//write_design -ALL ../../Results/${design}/final/${design}_eco.v -rep
write_design -ALL ../../Results/${design}/${node}/${design}_eco.v -rep

//// Verifying whether the new design is 100 % same as the original


//write_eco_design  -NEWFILE ../synth/netlist/CORTEX_M0_eco.v -Replace
exit //-force

//read library -Both -Replace  -sensitive  -Statetable  -Liberty /home/projects/lec_eco/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib -nooptimize   
//read design /home/projects/lec_eco/netlist/${design}.v -Verilog -Golden   -sensitive         -continuousassignment Bidirectional   -nokeep_unreach   -nosupply 
//read design /home/projects/lec_eco/netlist/${design}_mod.v -Verilog -Revised   -sensitive         -continuousassignment Bidirectional   -nokeep_unreach   -nosupply 
//set system mode lec
//add com p -a
//com
//analyze eco ../netlist/${design}_eco.v -replace
//set system mode setup
//read design  ../netlist/${design}_patch.v -append
//apply patch -revised ${design} ${design}_eco
