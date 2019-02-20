
create_port iwb_clk_i
create_net iwb_clk_i
connect_net iwb_clk_i iwb_clk_i
foreach_in_collection abc [get_pins iwb_biu_wb*/CK] {
  set pqr [get_attribute $abc full_name]
  disconnect_net [all_connected $pqr] $pqr
  connect_net iwb_clk_i $pqr
}
create_port dwb_clk_i
create_net dwb_clk_i
connect_net dwb_clk_i dwb_clk_i
foreach_in_collection abc [get_pins dwb_biu_wb*/CK] {
  set pqr [get_attribute $abc full_name]
  disconnect_net [all_connected $pqr] $pqr
  connect_net dwb_clk_i $pqr
}



