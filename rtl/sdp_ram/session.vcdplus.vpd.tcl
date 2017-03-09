# Begin_DVE_Session_Save_Info
# DVE view(Wave.1 ) session
# Saved on Thu Mar 9 21:54:11 2017
# Toplevel windows open: 2
# 	TopLevel.1
# 	TopLevel.2
#   Wave.1: 16 signals
# End_DVE_Session_Save_Info

# DVE version: H-2013.06
# DVE build date: May 30 2013 23:12:01


#<Session mode="View" path="/home/rbshi/swin_bram/rtl/sdp_ram/session.vcdplus.vpd.tcl" type="Debug">

#<Database>

#</Database>

# DVE View/pane content session: 

# Begin_DVE_Session_Save_Info (Wave.1)
# DVE wave signals session
# Saved on Thu Mar 9 21:54:11 2017
# 16 signals
# End_DVE_Session_Save_Info

# DVE version: H-2013.06
# DVE build date: May 30 2013 23:12:01


#Add ncecessay scopes
gui_load_child_values {tb_sdp_ram.u_sdp_ram}

gui_set_time_units 1ps

set _wave_session_group_1 Group1
if {[gui_sg_is_group -name "$_wave_session_group_1"]} {
    set _wave_session_group_1 [gui_sg_generate_new_name]
}
set Group1 "$_wave_session_group_1"

gui_sg_addsignal -group "$_wave_session_group_1" { {V1:tb_sdp_ram.u_sdp_ram.clk} {V1:tb_sdp_ram.u_sdp_ram.rst_n} {V1:tb_sdp_ram.u_sdp_ram.rd_addr} {V1:tb_sdp_ram.u_sdp_ram.wr_addr} {V1:tb_sdp_ram.u_sdp_ram.wr_data_in} {V1:tb_sdp_ram.u_sdp_ram.wr_data_mask} {V1:tb_sdp_ram.u_sdp_ram.wr_data_en} {V1:tb_sdp_ram.u_sdp_ram.rd_data_out} }

set _wave_session_group_2 Group2
if {[gui_sg_is_group -name "$_wave_session_group_2"]} {
    set _wave_session_group_2 [gui_sg_generate_new_name]
}
set Group2 "$_wave_session_group_2"

gui_sg_addsignal -group "$_wave_session_group_2" { {V1:tb_sdp_ram.clk} {V1:tb_sdp_ram.rst_n} {V1:tb_sdp_ram.rd_addr} {V1:tb_sdp_ram.wr_addr} {V1:tb_sdp_ram.wr_data_in} {V1:tb_sdp_ram.wr_data_mask} {V1:tb_sdp_ram.wr_data_en} {V1:tb_sdp_ram.rd_data_out} }
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
gui_wv_zoom_timerange -id ${Wave.1} 905235 1132564
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group1}]
gui_list_add_group -id ${Wave.1} -after {New Group} [list ${Group2}]
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
gui_list_set_insertion_bar  -id ${Wave.1} -group ${Group2}  -position below

gui_marker_move -id ${Wave.1} {C1} 1005000
gui_view_scroll -id ${Wave.1} -vertical -set 0
gui_show_grid -id ${Wave.1} -enable false
#</Session>

