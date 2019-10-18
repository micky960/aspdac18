set design [getenv "DESIGN"]
set node [getenv "NODE"]

set compile_seqmap_propagate_constants     false
set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
set link_library   { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

set_dont_use [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*]
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NAND2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XNOR2_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/INV_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/BUF_*] dont_use false
set_attribute [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/DFF*Q_*] dont_use false

#read_verilog -rtl ../../Results/${design}/${node}/${design}_eco.v

read_verilog -netlist ../../Results/${design}/${node}/${design}_temp.v
#current_design $design


set sfll_inp [get_attribute [get_ports *sfllKey*] full_name]

set myfile ../../Results/$design/$node/key_constraints_final.do
set a [open $myfile]
set lines [split [read $a] "\n"]
close $a

set sfll_key 0
foreach line $lines {
	set ind [lindex $line 4]
	lappend sfll_key $ind
}

set sfll_key [lreplace $sfll_key 0 0]
puts $sfll_key

#### ADDED BY NIMISHA 30th JULY
#set not_keys 0
#foreach in_port $sfll_inp {
#	
#        if {[regexp $in_port $sfll_key]} {
#                puts $in_port
#        } else {
#                lappend not_keys $in_port
#        }
#
#}



set not_keys 0
foreach in_port $sfll_inp {
	if {[regexp $in_port $sfll_key]} {
		puts $in_port
	} else {
		lappend not_keys $in_port
	}

}
 
set not_keys [lreplace $not_keys 0 0]
#puts $not_keys
#remove_port $not_keys

set verilog_file ../../Results/${design}/${node}/${design}_temp.v
set b [open $verilog_file r]
set verilog_lines [split [read $b] "\n"]
close $b


set verilog_write ../../Results/$design/${node}/${design}_temp_v1.v
set c [open $verilog_write "a"]

foreach ver $verilog_lines {
	if {[regexp "assign*" $ver]} {
		puts $ver
		set wire [lindex $ver 3] 
		regsub {;} $wire {\1} wire
		puts $wire
		if {[regexp $wire $not_keys]} {
			set pqr [split $wire "_"]
			set key_val [lindex $pqr 3]
			set assign_val "1'b${key_val}"	
			regsub $wire $ver $assign_val ver
			puts "		REPLACED	"
			puts $ver
		}
	}
	puts $c $ver
}

close $c

read_verilog -netlist ../../Results/${design}/${node}/${design}_temp_v1.v

remove_port $not_keys


check_design
create_clock -name VCLK -period 10  -waveform {0 5}
set input_ports  [all_inputs]
set output_ports [all_outputs]

set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK

set_output_delay -max 2 [get_ports $output_ports ] -clock VCLK
set_output_delay -min 1 [get_ports $output_ports ] -clock VCLK

ungroup -all -flatten
compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization
write -output  ../../Results/$design/${node}/${design}_final_combo.v -hierarchy -format verilog
write_sdc "../../Results/$design/${node}/${design}_final_combo.sdc"

exit
