#!/bin/sh

# 
# PlanAhead(TM)
# runme.sh: a PlanAhead-generated Runs Script for UNIX
# Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/data/tools/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/PlanAhead/bin
else
  PATH=/data/tools/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/PlanAhead/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/data/tools/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/lib/lin64
else
  LD_LIBRARY_PATH=/data/tools/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD=`dirname "$0"`
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep ngdbuild -intstyle ise -p xc7vx690tffg1930-2 -dd _ngo -uc "sdp_ram.ucf" "sdp_ram.edf"
EAStep map -intstyle pa -w "sdp_ram.ngd"
EAStep par -intstyle pa "sdp_ram.ncd" -w "sdp_ram_routed.ncd"
EAStep trce -intstyle ise -o "sdp_ram.twr" -v 30 -l 30 "sdp_ram_routed.ncd" "sdp_ram.pcf"
EAStep xdl -secure -ncd2xdl -nopips "sdp_ram_routed.ncd" "sdp_ram_routed.xdl"
