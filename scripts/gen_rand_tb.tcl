
set compile_seqmap_propagate_constants     false

set design [getenv "DESIGN"]
set search_path [concat * $search_path]
sh rm -rf ./work/work_${design}
define_design_lib WORK -path ./work/work_${design}
set target_library { /home/projects/capstone_SFLL/lib/Nangate_Library_typical.db}
set link_library   { /home/projects/vlsi/libraries/65lpe/ref_lib/arm/std_cells/hvt/timing_lib/nldm/db/sc9_cmos10lpe_base_hvt_ss_nominal_max_1p08v_125c.db }

read_verilog -netlist ./synth_fll_key_$design/netlist/${design}_no_opt.v

current_design $design

set in_width  [sizeof_collection [get_ports * -filter "direction == in && full_name !~ *fll*" ]]
set key_width [sizeof_collection [get_ports * -filter "direction == in && full_name =~ *fll*" ]]
set out_width [sizeof_collection [get_ports * -filter "direction == out"]]

echo "//INWIDTH $in_width OUTWIDTH $out_width"                           >  ./${design}_rand_tb.v
echo "`timescale 1 ns/1 ps"                                              >> ./${design}_rand_tb.v
echo "module ${design}_rand_tb ();"                                      >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "reg  \[$in_width-1  :0] inports;"                                  >> ./${design}_rand_tb.v
echo "reg  \[$key_width-1  :0] keyports;"                                >> ./${design}_rand_tb.v
echo "wire \[$out_width-1 :0] outports;"                                 >> ./${design}_rand_tb.v
echo "wire \[$out_width-1 :0] outports_mod;"                             >> ./${design}_rand_tb.v
echo "reg  \[$out_width-1 :0] hd;"                                       >> ./${design}_rand_tb.v
echo "integer                sum;"                                       >> ./${design}_rand_tb.v
echo "integer                accum;"                                     >> ./${design}_rand_tb.v
echo "integer                i;"                                         >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "localparam  CLK_PERIOD   = 5;"                                     >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "reg CLK;"                                                          >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v 
echo "  keyports = \$random;"                                            >> ./${design}_rand_tb.v
echo "  CLK      = 1'b0;"                                                >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v 
echo ""                                                                  >> ./${design}_rand_tb.v
echo "always begin"                                                      >> ./${design}_rand_tb.v
echo "  #(CLK_PERIOD/2) CLK = ~CLK;"                                     >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_rand_tb.v
echo "    @(posedge CLK);"                                               >> ./${design}_rand_tb.v
echo "      inports = \$random;"                                         >> ./${design}_rand_tb.v
echo "  end"                                                             >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v
echo "  accum = 0;"                                                      >> ./${design}_rand_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_rand_tb.v
echo "    sum = 0;"                                                      >> ./${design}_rand_tb.v
echo "    @(negedge CLK);"                                               >> ./${design}_rand_tb.v
echo "      hd = outports ^ outports_mod;"                               >> ./${design}_rand_tb.v
echo "      for (i = 0; i < $out_width; i = i +1) begin"                 >> ./${design}_rand_tb.v
echo "        if (hd\[i] == 1'b1) begin"                                 >> ./${design}_rand_tb.v
echo "          sum = sum + 1;"                                          >> ./${design}_rand_tb.v
echo "        end"                                                       >> ./${design}_rand_tb.v
echo "      end"                                                         >> ./${design}_rand_tb.v
echo "      accum = accum + sum;"                                        >> ./${design}_rand_tb.v
echo "  end"                                                             >> ./${design}_rand_tb.v
echo "      accum = accum / 1000;"                                       >> ./${design}_rand_tb.v
echo "  \$display (\"Current value of accum is %d\", i);"                >> ./${design}_rand_tb.v
echo "  \$finish;"                                                       >> ./${design}_rand_tb.v 
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v


echo "$design u_${design}_inst ("                                        >> ./${design}_rand_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name !~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name =~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (keyports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}



set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports[$x]),"                                       >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}
echo "  .dummy_port ()"                                                  >> ./${design}_rand_tb.v
echo ");"                                                                >> ./${design}_rand_tb.v


echo "${design}_mod u_${design}_mod_inst ("                              >> ./${design}_rand_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports_mod[$x]),"                                   >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}
  echo "  .dummy_port ()"                                                >> ./${design}_rand_tb.v
echo ");"                                                                >> ./${design}_rand_tb.v


echo ""                                                                  >> ./${design}_rand_tb.v
echo "endmodule"                                                         >> ./${design}_rand_tb.v


echo "//INWIDTH $in_width OUTWIDTH $out_width"                           >  ./${design}_rand_tb.v
echo "`timescale 1 ns/1 ps"                                              >> ./${design}_rand_tb.v
echo "module ${design}_tb ();"                                           >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "reg  \[$in_width-1  :0] inports;"                                  >> ./${design}_rand_tb.v
echo "reg  \[$key_width-1  :0] keyports;"                                 >> ./${design}_rand_tb.v
echo "wire \[$out_width-1 :0] outports;"                                 >> ./${design}_rand_tb.v
echo "wire \[$out_width-1 :0] outports_mod;"                             >> ./${design}_rand_tb.v
echo "reg  \[$out_width-1 :0] hd;"                                       >> ./${design}_rand_tb.v
echo "integer                sum;"                                       >> ./${design}_rand_tb.v
echo "integer                accum;"                                     >> ./${design}_rand_tb.v
echo "integer                i;"                                         >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "localparam  CLK_PERIOD   = 5;"                                     >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "reg CLK;"                                                          >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v 
echo "  keyports = \$random;"                                            >> ./${design}_rand_tb.v
echo "  CLK      = 1'b0;"                                                >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v 
echo ""                                                                  >> ./${design}_rand_tb.v
echo "always begin"                                                      >> ./${design}_rand_tb.v
echo "  #(CLK_PERIOD/2) CLK = ~CLK;"                                     >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_rand_tb.v
echo "    @(posedge CLK);"                                               >> ./${design}_rand_tb.v
echo "      inports = \$random;"                                         >> ./${design}_rand_tb.v
echo "  end"                                                             >> ./${design}_rand_tb.v
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v
echo "initial begin"                                                     >> ./${design}_rand_tb.v
echo "  accum = 0;"                                                      >> ./${design}_rand_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_rand_tb.v
echo "    sum = 0;"                                                      >> ./${design}_rand_tb.v
echo "    @(negedge CLK);"                                               >> ./${design}_rand_tb.v
echo "      hd = outports ^ outports_mod;"                               >> ./${design}_rand_tb.v
echo "      for (i = 0; i < $out_width; i = i +1) begin"                 >> ./${design}_rand_tb.v
echo "        if (hd\[i] == 1'b1) begin"                                 >> ./${design}_rand_tb.v
echo "          sum = sum + 1;"                                          >> ./${design}_rand_tb.v
echo "        end"                                                       >> ./${design}_rand_tb.v
echo "      end"                                                         >> ./${design}_rand_tb.v
echo "      accum = accum + sum;"                                        >> ./${design}_rand_tb.v
echo "  end"                                                             >> ./${design}_rand_tb.v
echo "      accum = accum / 1000;"                                       >> ./${design}_rand_tb.v
echo "  \$display (\"Current value of accum is %d\", i);"                >> ./${design}_rand_tb.v
echo "  \$finish;"                                                       >> ./${design}_rand_tb.v 
echo "end"                                                               >> ./${design}_rand_tb.v
echo ""                                                                  >> ./${design}_rand_tb.v


echo "$design u_${design}_inst ("                                        >> ./${design}_rand_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name !~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name =~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (keyports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}



set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports[$x]),"                                       >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}
echo "  .dummy_port ()"                                                  >> ./${design}_rand_tb.v
echo ");"                                                                >> ./${design}_rand_tb.v


echo "${design}_mod u_${design}_mod_inst ("                              >> ./${design}_rand_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports_mod[$x]),"                                   >> ./${design}_rand_tb.v
  set x [expr $x + 1]
}
  echo "  .dummy_port ()"                                                >> ./${design}_rand_tb.v
echo ");"                                                                >> ./${design}_rand_tb.v


echo ""                                                                  >> ./${design}_rand_tb.v
echo "endmodule"                                                         >> ./${design}_rand_tb.v


echo "//INWIDTH $in_width OUTWIDTH $out_width"                           >  ./${design}_pattack_tb.v
echo "`timescale 1 ns/1 ps"                                              >> ./${design}_pattack_tb.v
echo "module ${design}_pattack_tb ();"                                   >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "reg  \[$in_width-1  :0] inports;"                                  >> ./${design}_pattack_tb.v
echo "reg  \[$in_width-1  :0] keyports;"                                 >> ./${design}_pattack_tb.v
echo "wire \[$out_width-1 :0] outports;"                                 >> ./${design}_pattack_tb.v
echo "wire \[$out_width-1 :0] outports_mod;"                             >> ./${design}_pattack_tb.v
echo "reg  \[$out_width-1 :0] hd;"                                       >> ./${design}_pattack_tb.v
echo "integer                sum;"                                       >> ./${design}_pattack_tb.v
echo "integer                accum;"                                     >> ./${design}_pattack_tb.v
echo "integer                i;"                                         >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "localparam  CLK_PERIOD   = 5;"                                     >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "reg CLK;"                                                          >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v 
echo "  keyports = \$random;"                                            >> ./${design}_pattack_tb.v
echo "  CLK      = 1'b0;"                                                >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v 
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "always begin"                                                      >> ./${design}_pattack_tb.v
echo "  #(CLK_PERIOD/2) CLK = ~CLK;"                                     >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_pattack_tb.v
echo "    @(posedge CLK);"                                               >> ./${design}_pattack_tb.v
echo "      inports = \$random;"                                         >> ./${design}_pattack_tb.v
echo "  end"                                                             >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v
echo "  accum = 0;"                                                      >> ./${design}_pattack_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_pattack_tb.v
echo "    sum = 0;"                                                      >> ./${design}_pattack_tb.v
echo "    @(negedge CLK);"                                               >> ./${design}_pattack_tb.v
echo "      hd = outports ^ outports_mod;"                               >> ./${design}_pattack_tb.v
echo "      for (i = 0; i < $out_width; i = i +1) begin"                 >> ./${design}_pattack_tb.v
echo "        if (hd\[i] == 1'b1) begin"                                 >> ./${design}_pattack_tb.v
echo "          sum = sum + 1;"                                          >> ./${design}_pattack_tb.v
echo "        end"                                                       >> ./${design}_pattack_tb.v
echo "      end"                                                         >> ./${design}_pattack_tb.v
echo "      accum = accum + sum;"                                        >> ./${design}_pattack_tb.v
echo "  end"                                                             >> ./${design}_pattack_tb.v
echo "      accum = accum / 1000;"                                       >> ./${design}_pattack_tb.v
echo "  \$display (\"Current value of accum is %d\", i);"                >> ./${design}_pattack_tb.v
echo "  \$finish;"                                                       >> ./${design}_pattack_tb.v 
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v


echo "$design u_${design}_inst ("                                        >> ./${design}_pattack_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name !~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name =~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (keyports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}



set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports[$x]),"                                       >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}
echo "  .dummy_port ()"                                                  >> ./${design}_pattack_tb.v
echo ");"                                                                >> ./${design}_pattack_tb.v


echo "${design}_mod u_${design}_mod_inst ("                              >> ./${design}_pattack_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports_mod[$x]),"                                   >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}
  echo "  .dummy_port ()"                                                >> ./${design}_pattack_tb.v
echo ");"                                                                >> ./${design}_pattack_tb.v


echo ""                                                                  >> ./${design}_pattack_tb.v
echo "endmodule"                                                         >> ./${design}_pattack_tb.v


echo "//INWIDTH $in_width OUTWIDTH $out_width"                           >  ./${design}_pattack_tb.v
echo "`timescale 1 ns/1 ps"                                              >> ./${design}_pattack_tb.v
echo "module ${design}_pattack_tb ();"                                   >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "reg  \[$in_width-1  :0] inports;"                                  >> ./${design}_pattack_tb.v
echo "reg  \[$in_width-1  :0] keyports;"                                 >> ./${design}_pattack_tb.v
echo "wire \[$out_width-1 :0] outports;"                                 >> ./${design}_pattack_tb.v
echo "wire \[$out_width-1 :0] outports_mod;"                             >> ./${design}_pattack_tb.v
echo "reg  \[$out_width-1 :0] hd;"                                       >> ./${design}_pattack_tb.v
echo "integer                sum;"                                       >> ./${design}_pattack_tb.v
echo "integer                accum;"                                     >> ./${design}_pattack_tb.v
echo "integer                i;"                                         >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "localparam  CLK_PERIOD   = 5;"                                     >> ./${design}_pattack_tb.v
echo "parameter   KEYVAL       = 0;"                                     >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "reg CLK;"                                                          >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v 
echo "  keyports = KEYVAL;"                                              >> ./${design}_pattack_tb.v
echo "  CLK      = 1'b0;"                                                >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v 
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "always begin"                                                      >> ./${design}_pattack_tb.v
echo "  #(CLK_PERIOD/2) CLK = ~CLK;"                                     >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_pattack_tb.v
echo "    @(posedge CLK);"                                               >> ./${design}_pattack_tb.v
echo "      inports = \$random;"                                         >> ./${design}_pattack_tb.v
echo "  end"                                                             >> ./${design}_pattack_tb.v
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v
echo "initial begin"                                                     >> ./${design}_pattack_tb.v
echo "  accum = 0;"                                                      >> ./${design}_pattack_tb.v
echo "  repeat (1000) begin"                                             >> ./${design}_pattack_tb.v
echo "    sum = 0;"                                                      >> ./${design}_pattack_tb.v
echo "    @(negedge CLK);"                                               >> ./${design}_pattack_tb.v
echo "      hd = outports ^ outports_mod;"                               >> ./${design}_pattack_tb.v
echo "      for (i = 0; i < $out_width; i = i +1) begin"                 >> ./${design}_pattack_tb.v
echo "        if (hd\[i] == 1'b1) begin"                                 >> ./${design}_pattack_tb.v
echo "          sum = sum + 1;"                                          >> ./${design}_pattack_tb.v
echo "        end"                                                       >> ./${design}_pattack_tb.v
echo "      end"                                                         >> ./${design}_pattack_tb.v
echo "      accum = accum + sum;"                                        >> ./${design}_pattack_tb.v
echo "  end"                                                             >> ./${design}_pattack_tb.v
echo "      accum = accum / 1000;"                                       >> ./${design}_pattack_tb.v
echo "  \$display (\"Current value of accum is %d\", i);"                >> ./${design}_pattack_tb.v
echo "  \$finish;"                                                       >> ./${design}_pattack_tb.v 
echo "end"                                                               >> ./${design}_pattack_tb.v
echo ""                                                                  >> ./${design}_pattack_tb.v


echo "$design u_${design}_inst ("                                        >> ./${design}_pattack_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name !~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in && full_name =~ *fll*" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (keyports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}



set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports[$x]),"                                       >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}
echo "  .dummy_port ()"                                                  >> ./${design}_pattack_tb.v
echo ");"                                                                >> ./${design}_pattack_tb.v


echo "${design}_mod u_${design}_mod_inst ("                              >> ./${design}_pattack_tb.v
set x 0;
foreach_in_collection abc [get_ports * -filter "direction == in" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (inports[$x]),"                                        >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}

set x 0;
foreach_in_collection abc [get_ports * -filter "direction == out" ] {
  set pqr [get_attribute $abc full_name]
  echo "  .$pqr   (outports_mod[$x]),"                                   >> ./${design}_pattack_tb.v
  set x [expr $x + 1]
}
  echo "  .dummy_port ()"                                                >> ./${design}_pattack_tb.v
echo ");"                                                                >> ./${design}_pattack_tb.v


echo ""                                                                  >> ./${design}_pattack_tb.v
echo "endmodule"                                                         >> ./${design}_pattack_tb.v



#create_port dummy_port -direction out
#create_net  dummy_net
#connect_net dummy_net dummy_port
#create_cell UTIEHI_CELL_DUMMY NangateOpenCellLibrary/LOGIC1_X1
#connect_net dummy_net UTIEHI_CELL_DUMMY/Z
#
#sh touch ./logs/done_dc_stitch_${design}

exit
