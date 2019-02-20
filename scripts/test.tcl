source ~/source_lib_gf65lpe.tcl
set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db                     /home/projects/vlsi/libraries/65lpe/ref_lib/aragio/io_pads/timing_lib/nldm/db/rgo_csm65_25v33_lpe_50c_ss_108_297_125.db                         /home/projects/vlsi/libraries/65lpe/ref_lib/arm/memories/sram_sp_hde/timing_lib/USERLIB_ccs_ss_1p08v_1p08v_125c.db               /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/rvt/timing_lib/nldm/db/sc9_cmos10lpe_base_rvt_ss_nominal_max_1p08v_125c.db     }
read_verilog -netlist ./ro_type2.v
link
set i 0
create_cell UTIEHICLEL_inst sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/TIEHI_X1M_A9TH
create_cell UTIELOCLEL_inst sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/TIELO_X1M_A9TH
create_net tielo
create_net tiehi
connect_net tiehi UTIEHICLEL_inst/Y
connect_net tielo UTIELOCLEL_inst/Y


foreach_in_collection abc [all_fanin -to Y -only_cells] {
  set pqr [get_attribute $abc full_name]
  set ref [get_attribute $abc ref_name]
  if {[regexp  "^NOR.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name]} {
          connect_net tiehi $pin_name
        } else {
          connect_net tielo  $pin_name
        }
      }
     }
  } elseif {[regexp  "^OR.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name match]} {
          connect_net tiehi $pin_name
        } else {
          connect_net tielo  $pin_name
        }
      }
    }
  } elseif {[regexp  "^NAND.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name match]} {
          connect_net tielo $pin_name
        } else {
          connect_net tiehi  $pin_name
        }
      }
    }
  } elseif {[regexp  "^AND.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name match]} {
          connect_net tielo $pin_name
        } else {
          connect_net tiehi  $pin_name
        }
      }
    }
  } elseif {[regexp  "^XNOR.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name match]} {
          connect_net tiehi $pin_name
        } else {
          connect_net tielo  $pin_name
        }
      }
    }
  } elseif {[regexp  "^XOR.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        if {[regexp ".*N$" $pin_name match]} {
          connect_net tiehi $pin_name
        } else {
          connect_net tielo  $pin_name
        }
      }
    }
  } elseif {[regexp  "^AO.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 1} {
        set pin_name_c [get_attribute $pin_name full_name]
        if {[regexp ".*N$" $pin_name_c match]} {
          set pin_name_c [string range $pin_name_c 0 end-2]
        } else {
          set pin_name_c [string range $pin_name_c 0 end-1]
        }
      }
    }
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        set pin_name_f [get_attribute $pin_name full_name]
        if {[regexp ".*N$" $pin_name_f match]} {
          set pin_name_f [string range $pin_name_f 0 end-2]
        } else {
          set pin_name_f [string range $pin_name_f 0 end-1]
        }
        echo "$pin_name_f $pin_name_c"
        if {[regexp $pin_name_f $pin_name_c match]} {
          echo "debug: match"
          if {[regexp ".*N$" $pin_name match]} {
            connect_net tielo $pin_name
          } else {
            connect_net tiehi  $pin_name
          }
        } else {
          echo "debug: nomatch $pin_name"
          if {[regexp ".*N$" $pin_name match]} {
            connect_net tiehi $pin_name
          } else {
            connect_net tielo  $pin_name
          }
        }
      }
    }
  } elseif {[regexp  "^OA.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 1} {
        set pin_name_c [get_attribute $pin_name full_name]
        if {[regexp ".*N$" $pin_name_c match]} {
          set pin_name_c [string range $pin_name_c 0 end-2]
        } else {
          set pin_name_c [string range $pin_name_c 0 end-1]
        }
      }
    }
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 0} {
        set pin_name_f [get_attribute $pin_name full_name]
        if {[regexp ".*N$" $pin_name_f match]} {
          set pin_name_f [string range $pin_name_f 0 end-2]
        } else {
          set pin_name_f [string range $pin_name_f 0 end-1]
        }
        echo "$pin_name_f $pin_name_c"
        if {[regexp $pin_name_f $pin_name_c match]} {
          echo "debug: match"
          if {[regexp ".*N$" $pin_name match]} {
            connect_net tiehi $pin_name
          } else {
            connect_net tielo  $pin_name
          }
        } else {
          echo "debug: nomatch $pin_name"
          if {[regexp ".*N$" $pin_name match]} {
            connect_net tielo $pin_name
          } else {
            connect_net tiehi  $pin_name
          }
        }
      }
    }
  } elseif {[regexp  "^MX.*2_.*" $ref  match]} {
	echo $pqr $ref
    foreach_in_collection pins [get_pins -hier $pqr/* -filter "direction == in"] { 
      set pin_name [get_attribute $pins full_name]
      set fin [sizeof_collection [all_connected $pin_name]]
      if {$fin == 1} {
        set pin_name_c [get_attribute $pin_name full_name]
        if {[regexp ".*S0$" $pin_name_c match]} {
          connect_net tielo $pqr/A
          connect_net tiehi $pqr/B
        } elseif {[regexp ".*A$" $pin_name_c match]} {
          connect_net tielo $pqr/S0
          connect_net tielo $pqr/B
        } elseif {[regexp ".*B$" $pin_name_c match]} {
          connect_net tiehi $pqr/S0
          connect_net tielo $pqr/A
        } else {}
        break
      }
    }
  } else {}
}

foreach_in_collection abc [get_pins -hier *] { 
  set pqr [sizeof_collection [all_connected $abc]]
  if {$pqr == 0} {
    create_port const_$i
    create_net const_$i
    connect_net const_$i const_$i
    connect_net const_$i $abc
    set i [expr $i + 1]
  }
}

write -format verilog -hierarchy -output ./ro_type2_const.v


set_case_analysis 1 UTIEHICLEL_inst/Y
set_case_analysis 0 UTIELOCLEL_inst/Y
update_timing

set_case_analysis 1 [get_ports A]
update_timing
set check1 [get_attribute [get_ports Y] case_value]

remove_case_analysis [get_ports *]
set_case_analysis 0 [get_ports A]
update_timing
set check0 [get_attribute [get_ports Y] case_value]

if { ($check0 == 0) && ($check1 == 1) } {
  echo "IT IS A BUFFER"
} elseif { ($check0 == 1) && ($check1 == 0) } {
  echo "IT IS A INVERTER"
} else {
  echo "ERRROOOOOR"
}



