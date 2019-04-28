tclmode
read_library -Revised -Lib /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/lib/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.lib
read_design ../../files/benchfiles/b14_C.v -golden
read_design ../../Results/b14_C/final/b14_C_final_combo.v -revised
dofile ../../Results/b14_C/U3147/key_constraints_final.do 
set_system_mode lec
add_compared_points -all
compare

