set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db                         /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db                    }
setenv design [getenv DESIGN]
read_verilog -netlist ../../Results/$design/final/${design}_final_combo.v
elaborate $design
check_design
set output_ports [get_attribute [all_outputs ] full_name]
set all_nets [get_attribute [get_nets *] full_name ]

set x 0
foreach net $all_nets {
        set conn [get_attribute [all_fanout -from $net] full_name]
        set cnt [sizeof_collection [all_fanout -from $net]]
	if { $cnt < 2} {
		#puts "POSSIBLE PORT"
		#puts $net
		if { [regexp $conn $output_ports] == 0 } {
	                puts $conn
        	        puts "NOT FOUND"
     		} else {
                	set x [expr $x + 1]
             		puts $x
                
        	}

	}
}
foreach out $output_ports {
	set out_conn [get_attribute [all_fanin -to $out] full_name]
	set cnt [sizeof_collection [all_fanin -to $out] ]
	if {$cnt < 2} {
		puts $out
	}
}
	if { [regexp $conn $output_ports] } {
	        puts $conn
		puts "FOUND"
        } else {
        	puts $conn
		puts "NOT FOUND"
		
        }
}

