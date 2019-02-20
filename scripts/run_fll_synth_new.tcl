
date
set_host_options -max_cores 8
set compile_seqmap_propagate_constants     false
set compile_seqmap_propagate_high_effort   false
set compile_enable_register_merging        false
set write_sdc_output_net_resistance        false
set timing_separate_clock_gating_group     true

set design     [getenv DESIGN]
set vecsize    80
#set clkin      [getenv DESIGN_CLK]
#echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
#echo  "!!!!!: DESIGN Clock is set to $design_clk"
#echo  "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

set run_dir  synth_fll_key_$design

if {[file exist $run_dir]} {
sh rm -rf $run_dir
}

sh mkdir -p $run_dir/reports
sh mkdir -p $run_dir/netlist

  set search_path [concat * $search_path]

  define_design_lib WORK -path ./work
  set target_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db}
  set link_library { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/ccs/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }


  read_verilog -rtl  ./extra_cells.v
  current_design AO211_cell
  compile
  current_design AO221_cell
  compile
  read_verilog -netlist  ../Results/$design/final/${design}_final_combo.v
  source ./${design}_scoap_list.tcl
  set i 0
  set j 0
date

foreach_in_collection abcd $scoap_list {
  if {$i == $vecsize} {
    break
  }
  set abc    [get_attribute $abcd full_name]
  set keyval [string index $fllkey_val $i]
  set pqr    [get_attribute [get_cells $abc] ref_name]
  echo "------------------Cell $j : Now working on $abc with ref cell $pqr for key value $keyval------------------"
     
      set j [expr $j + 1]
  
  if {$keyval == "1"} {
    if {[string match "NAND2_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set            bnet  [all_connected [get_pins $abc/B]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND2_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "NOR2_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OR2_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "XOR2_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XNOR2_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "XNOR2_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "AOI22_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A0]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/A1]]
      set             cnet  [all_connected [get_pins $abc/B0]]
      set             dnet  [all_connected [get_pins $abc/B1]]
      disconnect_net $anet $abc/A0
      disconnect_net $bnet $abc/A1
      disconnect_net $cnet $abc/B0
      disconnect_net $dnet $abc/B1
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AO22_X1P4M_A9TH
      connect_net    $anet $abc/A0
      connect_net    $bnet $abc/A1
      connect_net    $cnet $abc/B0
      connect_net    $dnet $abc/B1
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "OAI22_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A0]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/A1]]
      set             cnet  [all_connected [get_pins $abc/B0]]
      set             dnet  [all_connected [get_pins $abc/B1]]
      disconnect_net $anet $abc/A0
      disconnect_net $bnet $abc/A1
      disconnect_net $cnet $abc/B0
      disconnect_net $dnet $abc/B1
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OA22_X1P4M_A9TH
      connect_net    $anet $abc/A0
      connect_net    $bnet $abc/A1
      connect_net    $cnet $abc/B0
      connect_net    $dnet $abc/B1
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "OAI211_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A0]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/A1]]
      set             cnet  [all_connected [get_pins $abc/B0]]
      set             dnet  [all_connected [get_pins $abc/C0]]
      disconnect_net $anet $abc/A0
      disconnect_net $bnet $abc/A1
      disconnect_net $cnet $abc/B0
      disconnect_net $dnet $abc/B1
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OA211_X1P4M_A9TH
      connect_net    $anet $abc/A0
      connect_net    $bnet $abc/A1
      connect_net    $cnet $abc/B0
      connect_net    $dnet $abc/C0
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "AOI221_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A0]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/A1]]
      set             cnet  [all_connected [get_pins $abc/B0]]
      set             dnet  [all_connected [get_pins $abc/B1]]
      set             enet  [all_connected [get_pins $abc/C0]]
      disconnect_net $anet $abc/A0
      disconnect_net $bnet $abc/A1
      disconnect_net $cnet $abc/B0
      disconnect_net $dnet $abc/B1
      disconnect_net $enet $abc/C0
      remove_cell    $abc
      create_cell    $abc AO221_cell
      connect_net    $anet $abc/A0
      connect_net    $bnet $abc/A1
      connect_net    $cnet $abc/B0
      connect_net    $dnet $abc/B1
      connect_net    $enet $abc/C0
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "AOI211_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A0]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/A1]]
      set             cnet  [all_connected [get_pins $abc/B0]]
      set             dnet  [all_connected [get_pins $abc/C0]]
      disconnect_net $anet $abc/A0
      disconnect_net $bnet $abc/A1
      disconnect_net $cnet $abc/B0
      disconnect_net $dnet $abc/C0
      remove_cell    $abc
      create_cell    $abc AO211_cell
      connect_net    $anet $abc/A0
      connect_net    $bnet $abc/A1
      connect_net    $cnet $abc/B0
      connect_net    $dnet $abc/C0
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "NAND4_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      set             cnet  [all_connected [get_pins $abc/C]]
      set             dnet  [all_connected [get_pins $abc/D]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      disconnect_net $cnet $abc/C
      disconnect_net $dnet $abc/D
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND4_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $cnet $abc/C
      connect_net    $dnet $abc/D
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
  } elseif {[string match "AND4_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      set             cnet  [all_connected [get_pins $abc/C]]
      set             dnet  [all_connected [get_pins $abc/D]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      disconnect_net $cnet $abc/C
      disconnect_net $dnet $abc/D
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NAND4_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $cnet $abc/C
      connect_net    $dnet $abc/D
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
  } elseif {[string match "NAND3_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      set             cnet  [all_connected [get_pins $abc/C]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      disconnect_net $cnet $abc/C
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/AND3_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $cnet $abc/C
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
  } elseif {[string match "NOR3_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      set             cnet  [all_connected [get_pins $abc/C]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      disconnect_net $cnet $abc/C
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/OR3_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $cnet $abc/C
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
  } elseif {[string match "OR3_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      set             bnet  [all_connected [get_pins $abc/B]]
      set             cnet  [all_connected [get_pins $abc/C]]
      disconnect_net $anet $abc/A
      disconnect_net $bnet $abc/B
      disconnect_net $cnet $abc/C
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/NOR3_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $bnet $abc/B
      connect_net    $cnet $abc/C
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "INV_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/BUF_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } elseif {[string match "BUF_*" $pqr]} {
      set anet   [all_connected [get_pins $abc/A]]
      set ynet   [all_connected [get_pins $abc/Y]]
      set xornet xor_$abc
      echo "------------------Now working on $abc with ref cell $pqr------------------"
      create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
      create_port    fllkey_${i}_$keyval 
      create_net     fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
      connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
      disconnect_net $ynet                $abc/Y
      connect_net    $ynet                UXOR2fllkey$i/Y
      create_net     $xornet
      connect_net    $xornet              UXOR2fllkey$i/A
      remove_cell    $abc
      create_cell    $abc sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/INV_X1P4M_A9TH
      connect_net    $anet $abc/A
      connect_net    $xornet        $abc/Y
      set i [expr $i + 1]
    } else {
    }
  } else {
     set ynet   [all_connected [get_pins $abc/Y]]
     set xornet xor_$abc
     echo "------------------Now working on $abc with ref cell $pqr------------------"
     create_cell    UXOR2fllkey$i   sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/XOR2_X1P4M_A9TH
     create_port    fllkey_${i}_$keyval 
     create_net     fllkey_${i}_$keyval
     connect_net    fllkey_${i}_$keyval  fllkey_${i}_$keyval
     connect_net    fllkey_${i}_$keyval  UXOR2fllkey$i/B 
     disconnect_net $ynet                $abc/Y
     connect_net    $ynet                UXOR2fllkey$i/Y
     create_net     $xornet
     connect_net    $xornet              UXOR2fllkey$i/A
     connect_net    $xornet              $abc/Y
     set i [expr $i + 1]
  }
    
}

ungroup -all -flatten
change_name -rules verilog -hierarchy
set bus_naming_style "%s_%d"
define_name_rules verilog -target_bus_naming_style "%s_%d" -remove_port_bus
change_names -rules verilog -hier

write_file -hierarchy -format verilog -output "$run_dir/netlist/${design}_no_opt.v"
# set_wire_load_model -name Medium
# set_max_area 0
#
# create_clock -name VCLK  -period 4  -waveform {0 2}
#
#  set input_ports  [all_inputs]
#  set output_ports [all_outputs]
#
#  set_input_delay -max 1 [get_ports $input_ports ] -clock VCLK
#  set_input_delay -min 0 [get_ports $input_ports ] -clock VCLK
#
#  set_output_delay -max 1 [get_ports $output_ports ] -clock VCLK
#  set_output_delay -min 3 [get_ports $output_ports ] -clock VCLK
#
#
#
#set_dont_use  [get_lib_cells sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c/*X0P*]
#date
#compile_ultra -no_autoungroup -no_seq_output_inversion -no_boundary_optimization -incremental
#date
#
#
#   report_timing -delay max  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_max.rpt
#   report_timing -delay min  -nosplit -input -nets -cap -max_path 10 -nworst 10    > $run_dir/reports/report_timing_min.rpt
#   report_constraint -all_violators -verbose  -nosplit                             > $run_dir/reports/report_constraint.rpt
#   check_design -nosplit                                                           > $run_dir/reports/check_design.rpt
#   report_design                                                                   > $run_dir/reports/report_design.rpt
#   report_area                                                                     > $run_dir/reports/report_area.rpt
#   report_timing -loop                                                             > $run_dir/reports/timing_loop.rpt
#   report_power -analysis_effort high                                              > $run_dir/reports/report_power.rpt
#   report_qor                                                                      > $run_dir/reports/report_qor.rpt
#
#
#change_name -rules verilog -hierarchy
#set bus_naming_style "%s_%d"
#define_name_rules verilog -target_bus_naming_style "%s_%d" -remove_port_bus
#change_names -rules verilog -hier
#
#write_file -hierarchy -format verilog -output "$run_dir/netlist/$design.v"
#write_sdc "$run_dir/netlist/$design.sdc"


exit
