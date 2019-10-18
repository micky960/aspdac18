set design [getenv "DESIGN"]
set node [getenv "NODE"]
set compile_seqmap_propagate_constants     false

source ../../Results/${design}/${node}/key.tcl

set count_zero [expr {[llength [split $KEY "0"]]-1}]
set count_one [expr {[llength [split $KEY "1"]]-1}]

if {$count_zero > 30 && $count_one > 30 } {
	puts "YES"
	echo "YES" > ../../Results/${design}/${node}/key_dist_rpt
} else {
	puts "NOT"
	echo "NOT" > ../../Results/${design}/${node}/key_dist_rpt

}

exit
