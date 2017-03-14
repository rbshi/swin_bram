# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Tue Mar 14 14:18:56 2017
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 104 signals
# End_DVE_Session_Save_Info

# DVE version: H-2013.06
# DVE build date: May 30 2013 23:12:01


#<Session mode="View" path="/home/rbshi/swin_bram/rtl/wrap/swin_bram_waveview.vcdplus.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Tue Mar 14 14:18:56 2017
# 104 signals
# End_DVE_Session_Save_Info

# DVE version: H-2013.06
# DVE build date: May 30 2013 23:12:01


#Add ncecessay scopes
gui_load_child_values {tb_swin_wrap.u_swin_wrap.u2_bram_group}
gui_load_child_values {tb_swin_wrap.u_swin_wrap.u1_bram_group}
gui_load_child_values {tb_swin_wrap.u_swin_wrap.u0_bram_group}
gui_load_child_values {tb_swin_wrap}

gui_set_time_units 1ps

set _wave_session_group_1 tb
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {V1:tb_swin_wrap.clk} {V1:tb_swin_wrap.data_in_vld} {V1:tb_swin_wrap.data_out_vld} {V1:tb_swin_wrap.pix_data_in} {V1:tb_swin_wrap.pix_data_out} {V1:tb_swin_wrap.rst_n} }

set _wave_session_group_2 decoder
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {V1:tb_swin_wrap.u_swin_wrap.u_decoder.clk} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_addr_ret} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_bram_rd_addr} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_bram_rd_data_out} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_cycle} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_data} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_offset} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_order} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_split} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.data_in_vld} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.data_in_vld_d} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.flag_write} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.flag_write_line_end} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.flag_write_line_start} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en_d0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d2} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.pix_data_in} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.pix_data_in_d0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.pix_data_in_d1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_conf_offset_tail} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_shuf_flag_tail} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_reset} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_s0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_s1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_tail_0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_tail_1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.ret_flag} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.rst_n} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag_d0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp2} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_reset} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_gp} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_end} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_start} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_gp0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_gp1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_gp2} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_group_en} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp0} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp1} {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp2} }
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_bram_rd_addr}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_bram_rd_addr}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_cycle}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_cycle}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_offset}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_offset}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_order}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.conf_order}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en_d0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.group_wr_en_d0}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d0}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d1}
gui_set_radix -radix {decimal} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d2}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.inline_cnt_d2}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_shuf_flag_tail}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_shuf_flag_tail}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_inc_s1}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_reset}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_addr_reset}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_1}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.reg_wr_data_mask_tail_1}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag_d0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.shuf_flag_d0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp1}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp2}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_inc_gp2}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_reset}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_addr_reset}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_gp}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_gp}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_end}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_end}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_start}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_start}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_group_en}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_group_en}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp0}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp0}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp1}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp1}
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp2}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_mask_gp2}

set _wave_session_group_3 bram_gp0
if {[gui_sg_is_group -name "$_wave_session_group_3"]} {
    set _wave_session_group_3 [gui_sg_generate_new_name]
}
set Group3 "$_wave_session_group_3"

gui_sg_addsignal -group "$_wave_session_group_3" { {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.clk} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.cur_addr} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.rd_addr} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.rd_data_out} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.rst_n} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_addr_bram0} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_addr_bram1} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_addr_bram2} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_addr_inc} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_addr_reset} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_data} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_data_group_en} {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_data_mask} }
gui_set_radix -radix {binary} -signals {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_data_mask}
gui_set_radix -radix {unsigned} -signals {V1:tb_swin_wrap.u_swin_wrap.u0_bram_group.wr_data_mask}

set _wave_session_group_4 bram_gp1
if {[gui_sg_is_group -name "$_wave_session_group_4"]} {
    set _wave_session_group_4 [gui_sg_generate_new_name]
}
set Group4 "$_wave_session_group_4"

gui_sg_addsignal -group "$_wave_session_group_4" { {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.clk} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.cur_addr} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.rd_addr} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.rd_data_out} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.rst_n} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_addr_bram0} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_addr_bram1} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_addr_bram2} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_addr_inc} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_addr_reset} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_data} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_data_group_en} {V1:tb_swin_wrap.u_swin_wrap.u1_bram_group.wr_data_mask} }

set _wave_session_group_5 bram_gp2
if {[gui_sg_is_group -name "$_wave_session_group_5"]} {
    set _wave_session_group_5 [gui_sg_generate_new_name]
}
set Group5 "$_wave_session_group_5"

gui_sg_addsignal -group "$_wave_session_group_5" { {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.clk} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.cur_addr} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.rd_addr} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.rd_data_out} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.rst_n} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_addr_bram0} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_addr_bram1} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_addr_bram2} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_addr_inc} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_addr_reset} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_data} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_data_group_en} {V1:tb_swin_wrap.u_swin_wrap.u2_bram_group.wr_data_mask} }
if {![info exists useOldWindow]} { 
	set useOldWindow true
}
if {$useOldWindow && [string first "Wave" [gui_get_current_window -view]]==0} { 
	set Wave.1 [gui_get_current_window -view] 
} else {
	gui_open_window Wave
set Wave.1 [ gui_get_current_window -view ]
}
set groupExD [gui_get_pref_value -category Wave -key exclusiveSG]
gui_set_pref_value -category Wave -key exclusiveSG -value {false}
set origWaveHeight [gui_get_pref_value -category Wave -key waveRowHeight]
gui_list_set_height -id Wave -height 25
set origGroupCreationState [gui_list_create_group_when_add -wave]
gui_list_create_group_when_add -wave -disable
gui_marker_set_ref -id ${Wave.1}  C1
gui_wv_zoom_timerange -id ${Wave.1} 285556 666582
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group3}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group4}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group5}]
gui_list_collapse -id ${Wave.1} ${Group3}
gui_list_collapse -id ${Wave.1} ${Group4}
gui_list_collapse -id ${Wave.1} ${Group5}
gui_list_expand -id ${Wave.1} tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_gp
gui_list_select -id ${Wave.1} {tb_swin_wrap.u_swin_wrap.u_decoder.wr_data_en_line_end }
gui_seek_criteria -id ${Wave.1} {Any Edge}


gui_set_pref_value -category Wave -key exclusiveSG -value $groupExD
gui_list_set_height -id Wave -height $origWaveHeight
if {$origGroupCreationState} {
	gui_list_create_group_when_add -wave -enable
}
if { $groupExD } {
 gui_msg_report -code DVWW028
}
gui_list_set_filter -id ${Wave.1} -list { {Buffer 1} {Input 1} {Others 1} {Linkage 1} {Output 1} {Parameter 1} {All 1} {Aggregate 1} {Event 1} {Assertion 1} {Constant 1} {Interface 1} {Signal 1} {$unit 1} {Inout 1} {Variable 1} }
gui_list_set_filter -id ${Wave.1} -text {*}
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group5}  -position in

gui_marker_move -id ${Wave.1} {C1} 405000
gui_view_scroll -id ${Wave.1} -vertical -set 900
gui_show_grid -id ${Wave.1} -enable false
#</Session>

