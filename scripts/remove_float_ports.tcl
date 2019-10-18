set design [getenv "DESIGN"]

set compile_seqmap_propagate_constants     false
set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
set link_library   { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

read_verilog -rtl ../../files/benchfiles/${design}_old.v
foreach_in_collection abc [get_ports * -filter "direction == in"] {
        set pqr [get_attribute $abc full_name]
        set cnt [sizeof_collection [all_connected [get_ports $pqr]]]
        if {$cnt == 0} {remove_port $pqr
        echo "create_port -direction in $pqr" >> ../../Results/$design/create_port_${design}.tcl
        }
}

write -output ../../files/benchfiles/${design}.v -hierarchy -fromat verilog

