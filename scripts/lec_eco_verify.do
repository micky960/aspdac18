// This code compares the eco file with the original file

tclmode
set design $::env(DESIGN)
set node $::env(NODE)
read_design ../../Results/${design}/${node}/${design}_eco.v  -golden
read_design ../../files/benchfiles/${design}.v -revised

set_system_mode lec
add_compared_points -all
compare
exit
