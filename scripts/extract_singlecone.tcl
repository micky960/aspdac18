set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}

set link_library   { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

read_verilog -netlist ../../files/benchfiles/c432_v1_syn.v

set OUTPUT G223GAT

## removes all output ports other than $OUTPUT
set output_ports [get_attribute [get_ports * -filter "direction == out"] full_name]
        foreach f $output_ports {
                if {[regexp $OUTPUT $f]} {
                        puts $f
                } else {
                        remove_port [get_ports $f]
                }
        }
## removes all the cells not occuring in the fan-in cone of $OUTPUT

set all_fanin_output [get_attribute [all_fanin -to $OUTPUT -only_cells] full_name]
        foreach_in_collection rem_cell [get_pins  * -filter "direction==out"] {
                set cel_name [get_attribute [get_cells -of_objects $rem_cell] full_name]
                set fout [all_fanout -from [get_attribute $rem_cell full_name] -endpoints_only -flat ]
                set fout_name [get_attribute $fout full_name]
                set flag_fanin 0
                foreach fanin_out $all_fanin_output {
                        if {$cel_name == $fanin_out} {
                                set flag_fanin 1
                        }
                }
                if {$flag_fanin == 0} {
                        remove_cell $cel_name
                }
        }

## removes all input_ports which are not connected

foreach_in_collection rem_port [all_inputs ] {
          set siz [sizeof_collection [all_fanout -from [get_attribute $rem_port full_name] -flat -endpoints_only]]
          if {$siz == 0} {
              remove_port [get_attribute $rem_port full_name]
           }
        }

## removes all the open nets

foreach_in_collection rem_net [get_nets *] {
          set siz [sizeof_collection [all_connected [get_attribute $rem_net full_name]]]
          if {$siz == 0} {
            remove_net [get_attribute $rem_net full_name]
          }
        }

        write -format verilog -hierarchy -output ../../files/benchfiles/c432_singlecones.v

exit


