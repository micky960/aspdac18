#iwb_clk_i
create_port iwb_clk_i
create_net  iwb_clk_i
connect_net iwb_clk_i iwb_clk_i
disconnect_net [all_connected iwb_biu_wb_bte_o_reg_1_/CK] iwb_biu_wb_bte_o_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_bte_o_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_cyc_o_reg/CK] iwb_biu_wb_cyc_o_reg/CK
connect_net    iwb_clk_i      iwb_biu_wb_cyc_o_reg/CK
disconnect_net [all_connected iwb_biu_wb_we_o_reg/CK] iwb_biu_wb_we_o_reg/CK
connect_net    iwb_clk_i      iwb_biu_wb_we_o_reg/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_0_/CK] iwb_biu_wb_adr_o_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_0_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_1_/CK] iwb_biu_wb_adr_o_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_0_/CK] iwb_biu_wb_dat_o_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_0_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_31_/CK] iwb_biu_wb_dat_o_reg_31_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_31_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_30_/CK] iwb_biu_wb_dat_o_reg_30_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_30_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_29_/CK] iwb_biu_wb_dat_o_reg_29_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_29_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_28_/CK] iwb_biu_wb_dat_o_reg_28_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_28_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_27_/CK] iwb_biu_wb_dat_o_reg_27_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_27_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_26_/CK] iwb_biu_wb_dat_o_reg_26_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_26_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_25_/CK] iwb_biu_wb_dat_o_reg_25_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_25_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_24_/CK] iwb_biu_wb_dat_o_reg_24_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_24_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_23_/CK] iwb_biu_wb_dat_o_reg_23_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_23_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_22_/CK] iwb_biu_wb_dat_o_reg_22_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_22_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_21_/CK] iwb_biu_wb_dat_o_reg_21_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_21_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_20_/CK] iwb_biu_wb_dat_o_reg_20_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_20_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_19_/CK] iwb_biu_wb_dat_o_reg_19_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_19_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_18_/CK] iwb_biu_wb_dat_o_reg_18_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_18_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_17_/CK] iwb_biu_wb_dat_o_reg_17_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_17_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_16_/CK] iwb_biu_wb_dat_o_reg_16_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_16_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_15_/CK] iwb_biu_wb_dat_o_reg_15_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_15_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_14_/CK] iwb_biu_wb_dat_o_reg_14_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_14_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_13_/CK] iwb_biu_wb_dat_o_reg_13_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_13_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_12_/CK] iwb_biu_wb_dat_o_reg_12_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_12_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_11_/CK] iwb_biu_wb_dat_o_reg_11_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_11_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_10_/CK] iwb_biu_wb_dat_o_reg_10_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_10_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_9_/CK] iwb_biu_wb_dat_o_reg_9_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_9_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_8_/CK] iwb_biu_wb_dat_o_reg_8_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_8_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_7_/CK] iwb_biu_wb_dat_o_reg_7_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_7_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_6_/CK] iwb_biu_wb_dat_o_reg_6_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_6_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_5_/CK] iwb_biu_wb_dat_o_reg_5_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_5_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_4_/CK] iwb_biu_wb_dat_o_reg_4_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_4_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_3_/CK] iwb_biu_wb_dat_o_reg_3_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_3_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_2_/CK] iwb_biu_wb_dat_o_reg_2_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_2_/CK
disconnect_net [all_connected iwb_biu_wb_dat_o_reg_1_/CK] iwb_biu_wb_dat_o_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_dat_o_reg_1_/CK
disconnect_net [all_connected iwb_biu_burst_len_reg_1_/CK] iwb_biu_burst_len_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_burst_len_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_31_/CK] iwb_biu_wb_adr_o_reg_31_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_31_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_30_/CK] iwb_biu_wb_adr_o_reg_30_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_30_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_29_/CK] iwb_biu_wb_adr_o_reg_29_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_29_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_28_/CK] iwb_biu_wb_adr_o_reg_28_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_28_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_27_/CK] iwb_biu_wb_adr_o_reg_27_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_27_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_26_/CK] iwb_biu_wb_adr_o_reg_26_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_26_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_25_/CK] iwb_biu_wb_adr_o_reg_25_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_25_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_24_/CK] iwb_biu_wb_adr_o_reg_24_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_24_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_23_/CK] iwb_biu_wb_adr_o_reg_23_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_23_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_22_/CK] iwb_biu_wb_adr_o_reg_22_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_22_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_21_/CK] iwb_biu_wb_adr_o_reg_21_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_21_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_20_/CK] iwb_biu_wb_adr_o_reg_20_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_20_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_19_/CK] iwb_biu_wb_adr_o_reg_19_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_19_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_18_/CK] iwb_biu_wb_adr_o_reg_18_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_18_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_17_/CK] iwb_biu_wb_adr_o_reg_17_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_17_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_16_/CK] iwb_biu_wb_adr_o_reg_16_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_16_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_15_/CK] iwb_biu_wb_adr_o_reg_15_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_15_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_14_/CK] iwb_biu_wb_adr_o_reg_14_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_14_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_13_/CK] iwb_biu_wb_adr_o_reg_13_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_13_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_12_/CK] iwb_biu_wb_adr_o_reg_12_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_12_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_11_/CK] iwb_biu_wb_adr_o_reg_11_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_11_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_10_/CK] iwb_biu_wb_adr_o_reg_10_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_10_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_9_/CK] iwb_biu_wb_adr_o_reg_9_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_9_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_8_/CK] iwb_biu_wb_adr_o_reg_8_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_8_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_7_/CK] iwb_biu_wb_adr_o_reg_7_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_7_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_6_/CK] iwb_biu_wb_adr_o_reg_6_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_6_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_5_/CK] iwb_biu_wb_adr_o_reg_5_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_5_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_4_/CK] iwb_biu_wb_adr_o_reg_4_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_4_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_3_/CK] iwb_biu_wb_adr_o_reg_3_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_3_/CK
disconnect_net [all_connected iwb_biu_wb_adr_o_reg_2_/CK] iwb_biu_wb_adr_o_reg_2_/CK
connect_net    iwb_clk_i      iwb_biu_wb_adr_o_reg_2_/CK
disconnect_net [all_connected iwb_biu_wb_err_cnt_reg/CK] iwb_biu_wb_err_cnt_reg/CK
connect_net    iwb_clk_i      iwb_biu_wb_err_cnt_reg/CK
disconnect_net [all_connected iwb_biu_wb_bte_o_reg_0_/CK] iwb_biu_wb_bte_o_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_bte_o_reg_0_/CK
disconnect_net [all_connected iwb_biu_burst_len_reg_3_/CK] iwb_biu_burst_len_reg_3_/CK
connect_net    iwb_clk_i      iwb_biu_burst_len_reg_3_/CK
disconnect_net [all_connected iwb_biu_burst_len_reg_0_/CK] iwb_biu_burst_len_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_burst_len_reg_0_/CK
disconnect_net [all_connected iwb_biu_burst_len_reg_2_/CK] iwb_biu_burst_len_reg_2_/CK
connect_net    iwb_clk_i      iwb_biu_burst_len_reg_2_/CK
disconnect_net [all_connected iwb_biu_wb_fsm_state_cur_reg_1_/CK] iwb_biu_wb_fsm_state_cur_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_fsm_state_cur_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_ack_cnt_reg/CK] iwb_biu_wb_ack_cnt_reg/CK
connect_net    iwb_clk_i      iwb_biu_wb_ack_cnt_reg/CK
disconnect_net [all_connected iwb_biu_wb_fsm_state_cur_reg_0_/CK] iwb_biu_wb_fsm_state_cur_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_fsm_state_cur_reg_0_/CK
disconnect_net [all_connected iwb_biu_wb_sel_o_reg_3_/CK] iwb_biu_wb_sel_o_reg_3_/CK
connect_net    iwb_clk_i      iwb_biu_wb_sel_o_reg_3_/CK
disconnect_net [all_connected iwb_biu_wb_sel_o_reg_2_/CK] iwb_biu_wb_sel_o_reg_2_/CK
connect_net    iwb_clk_i      iwb_biu_wb_sel_o_reg_2_/CK
disconnect_net [all_connected iwb_biu_wb_sel_o_reg_1_/CK] iwb_biu_wb_sel_o_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_sel_o_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_sel_o_reg_0_/CK] iwb_biu_wb_sel_o_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_sel_o_reg_0_/CK
disconnect_net [all_connected iwb_biu_wb_cti_o_reg_1_/CK] iwb_biu_wb_cti_o_reg_1_/CK
connect_net    iwb_clk_i      iwb_biu_wb_cti_o_reg_1_/CK
disconnect_net [all_connected iwb_biu_wb_cti_o_reg_0_/CK] iwb_biu_wb_cti_o_reg_0_/CK
connect_net    iwb_clk_i      iwb_biu_wb_cti_o_reg_0_/CK
disconnect_net [all_connected iwb_biu_wb_cti_o_reg_2_/CK] iwb_biu_wb_cti_o_reg_2_/CK
connect_net    iwb_clk_i      iwb_biu_wb_cti_o_reg_2_/CK
disconnect_net [all_connected iwb_biu_wb_stb_o_reg/CK] iwb_biu_wb_stb_o_reg/CK
connect_net    iwb_clk_i      iwb_biu_wb_stb_o_reg/CK

#dwb_clk_i
create_port dwb_clk_i
create_net dwb_clk_i
connect_net dwb_clk_i dwb_clk_i
disconnect_net [all_connected dwb_biu_wb_stb_o_reg/CK] dwb_biu_wb_stb_o_reg/CK
connect_net    dwb_clk_i      dwb_biu_wb_stb_o_reg/CK
disconnect_net [all_connected dwb_biu_wb_bte_o_reg_1_/CK] dwb_biu_wb_bte_o_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_bte_o_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_cyc_o_reg/CK] dwb_biu_wb_cyc_o_reg/CK
connect_net    dwb_clk_i      dwb_biu_wb_cyc_o_reg/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_27_/CK] dwb_biu_wb_adr_o_reg_27_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_27_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_28_/CK] dwb_biu_wb_adr_o_reg_28_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_28_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_29_/CK] dwb_biu_wb_adr_o_reg_29_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_29_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_30_/CK] dwb_biu_wb_adr_o_reg_30_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_30_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_31_/CK] dwb_biu_wb_adr_o_reg_31_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_31_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_12_/CK] dwb_biu_wb_dat_o_reg_12_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_12_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_13_/CK] dwb_biu_wb_dat_o_reg_13_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_13_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_15_/CK] dwb_biu_wb_dat_o_reg_15_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_15_/CK
disconnect_net [all_connected dwb_biu_burst_len_reg_2_/CK] dwb_biu_burst_len_reg_2_/CK
connect_net    dwb_clk_i      dwb_biu_burst_len_reg_2_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_0_/CK] dwb_biu_wb_dat_o_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_1_/CK] dwb_biu_wb_dat_o_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_2_/CK] dwb_biu_wb_dat_o_reg_2_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_2_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_3_/CK] dwb_biu_wb_dat_o_reg_3_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_3_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_4_/CK] dwb_biu_wb_dat_o_reg_4_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_4_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_6_/CK] dwb_biu_wb_dat_o_reg_6_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_6_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_7_/CK] dwb_biu_wb_dat_o_reg_7_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_7_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_16_/CK] dwb_biu_wb_dat_o_reg_16_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_16_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_17_/CK] dwb_biu_wb_dat_o_reg_17_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_17_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_19_/CK] dwb_biu_wb_dat_o_reg_19_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_19_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_20_/CK] dwb_biu_wb_dat_o_reg_20_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_20_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_22_/CK] dwb_biu_wb_dat_o_reg_22_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_22_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_23_/CK] dwb_biu_wb_dat_o_reg_23_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_23_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_1_/CK] dwb_biu_wb_adr_o_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_4_/CK] dwb_biu_wb_adr_o_reg_4_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_4_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_5_/CK] dwb_biu_wb_adr_o_reg_5_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_5_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_6_/CK] dwb_biu_wb_adr_o_reg_6_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_6_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_7_/CK] dwb_biu_wb_adr_o_reg_7_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_7_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_8_/CK] dwb_biu_wb_adr_o_reg_8_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_8_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_9_/CK] dwb_biu_wb_adr_o_reg_9_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_9_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_10_/CK] dwb_biu_wb_adr_o_reg_10_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_10_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_11_/CK] dwb_biu_wb_adr_o_reg_11_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_11_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_12_/CK] dwb_biu_wb_adr_o_reg_12_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_12_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_13_/CK] dwb_biu_wb_adr_o_reg_13_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_13_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_14_/CK] dwb_biu_wb_adr_o_reg_14_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_14_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_15_/CK] dwb_biu_wb_adr_o_reg_15_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_15_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_16_/CK] dwb_biu_wb_adr_o_reg_16_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_16_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_17_/CK] dwb_biu_wb_adr_o_reg_17_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_17_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_18_/CK] dwb_biu_wb_adr_o_reg_18_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_18_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_19_/CK] dwb_biu_wb_adr_o_reg_19_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_19_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_20_/CK] dwb_biu_wb_adr_o_reg_20_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_20_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_21_/CK] dwb_biu_wb_adr_o_reg_21_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_21_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_22_/CK] dwb_biu_wb_adr_o_reg_22_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_22_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_23_/CK] dwb_biu_wb_adr_o_reg_23_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_23_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_24_/CK] dwb_biu_wb_adr_o_reg_24_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_24_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_25_/CK] dwb_biu_wb_adr_o_reg_25_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_25_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_26_/CK] dwb_biu_wb_adr_o_reg_26_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_26_/CK
disconnect_net [all_connected dwb_biu_wb_we_o_reg/CK] dwb_biu_wb_we_o_reg/CK
connect_net    dwb_clk_i      dwb_biu_wb_we_o_reg/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_5_/CK] dwb_biu_wb_dat_o_reg_5_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_5_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_24_/CK] dwb_biu_wb_dat_o_reg_24_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_24_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_25_/CK] dwb_biu_wb_dat_o_reg_25_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_25_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_26_/CK] dwb_biu_wb_dat_o_reg_26_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_26_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_27_/CK] dwb_biu_wb_dat_o_reg_27_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_27_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_28_/CK] dwb_biu_wb_dat_o_reg_28_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_28_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_29_/CK] dwb_biu_wb_dat_o_reg_29_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_29_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_30_/CK] dwb_biu_wb_dat_o_reg_30_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_30_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_31_/CK] dwb_biu_wb_dat_o_reg_31_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_31_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_9_/CK] dwb_biu_wb_dat_o_reg_9_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_9_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_10_/CK] dwb_biu_wb_dat_o_reg_10_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_10_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_14_/CK] dwb_biu_wb_dat_o_reg_14_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_14_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_0_/CK] dwb_biu_wb_adr_o_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_8_/CK] dwb_biu_wb_dat_o_reg_8_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_8_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_11_/CK] dwb_biu_wb_dat_o_reg_11_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_11_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_18_/CK] dwb_biu_wb_dat_o_reg_18_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_18_/CK
disconnect_net [all_connected dwb_biu_wb_dat_o_reg_21_/CK] dwb_biu_wb_dat_o_reg_21_/CK
connect_net    dwb_clk_i      dwb_biu_wb_dat_o_reg_21_/CK
disconnect_net [all_connected dwb_biu_burst_len_reg_1_/CK] dwb_biu_burst_len_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_burst_len_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_fsm_state_cur_reg_0_/CK] dwb_biu_wb_fsm_state_cur_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_fsm_state_cur_reg_0_/CK
disconnect_net [all_connected dwb_biu_burst_len_reg_3_/CK] dwb_biu_burst_len_reg_3_/CK
connect_net    dwb_clk_i      dwb_biu_burst_len_reg_3_/CK
disconnect_net [all_connected dwb_biu_burst_len_reg_0_/CK] dwb_biu_burst_len_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_burst_len_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_3_/CK] dwb_biu_wb_adr_o_reg_3_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_3_/CK
disconnect_net [all_connected dwb_biu_wb_adr_o_reg_2_/CK] dwb_biu_wb_adr_o_reg_2_/CK
connect_net    dwb_clk_i      dwb_biu_wb_adr_o_reg_2_/CK
disconnect_net [all_connected dwb_biu_wb_bte_o_reg_0_/CK] dwb_biu_wb_bte_o_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_bte_o_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_err_cnt_reg/CK] dwb_biu_wb_err_cnt_reg/CK
connect_net    dwb_clk_i      dwb_biu_wb_err_cnt_reg/CK
disconnect_net [all_connected dwb_biu_wb_fsm_state_cur_reg_1_/CK] dwb_biu_wb_fsm_state_cur_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_fsm_state_cur_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_sel_o_reg_0_/CK] dwb_biu_wb_sel_o_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_sel_o_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_sel_o_reg_1_/CK] dwb_biu_wb_sel_o_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_sel_o_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_ack_cnt_reg/CK] dwb_biu_wb_ack_cnt_reg/CK
connect_net    dwb_clk_i      dwb_biu_wb_ack_cnt_reg/CK
disconnect_net [all_connected dwb_biu_wb_sel_o_reg_2_/CK] dwb_biu_wb_sel_o_reg_2_/CK
connect_net    dwb_clk_i      dwb_biu_wb_sel_o_reg_2_/CK
disconnect_net [all_connected dwb_biu_wb_sel_o_reg_3_/CK] dwb_biu_wb_sel_o_reg_3_/CK
connect_net    dwb_clk_i      dwb_biu_wb_sel_o_reg_3_/CK
disconnect_net [all_connected dwb_biu_wb_cti_o_reg_1_/CK] dwb_biu_wb_cti_o_reg_1_/CK
connect_net    dwb_clk_i      dwb_biu_wb_cti_o_reg_1_/CK
disconnect_net [all_connected dwb_biu_wb_cti_o_reg_0_/CK] dwb_biu_wb_cti_o_reg_0_/CK
connect_net    dwb_clk_i      dwb_biu_wb_cti_o_reg_0_/CK
disconnect_net [all_connected dwb_biu_wb_cti_o_reg_2_/CK] dwb_biu_wb_cti_o_reg_2_/CK
connect_net    dwb_clk_i      dwb_biu_wb_cti_o_reg_2_/CK
