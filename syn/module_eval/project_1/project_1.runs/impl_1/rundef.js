//
// PlanAhead(TM)
// rundef.js: a PlanAhead-generated Runs Script for WSH 5.1/5.6
// Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
//

echo "This script was generated under a different operating system."
echo "Please update the PATH variable below, before executing this script"
exit

var WshShell = new ActiveXObject( "WScript.Shell" );
var ProcEnv = WshShell.Environment( "Process" );
var PathVal = ProcEnv("PATH");
if ( PathVal.length == 0 ) {
  PathVal = "/data/tools/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/bin/lin64;/data/tools/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/lib/lin64;/data/tools/Xilinx/14.7/ISE_DS/PlanAhead/bin;";
} else {
  PathVal = "/data/tools/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/bin/lin64;/data/tools/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/data/tools/Xilinx/14.7/ISE_DS/common/lib/lin64;/data/tools/Xilinx/14.7/ISE_DS/PlanAhead/bin;" + PathVal;
}

ProcEnv("PATH") = PathVal;

var RDScrFP = WScript.ScriptFullName;
var RDScrN = WScript.ScriptName;
var RDScrDir = RDScrFP.substr( 0, RDScrFP.length - RDScrN.length - 1 );
var ISEJScriptLib = RDScrDir + "/ISEWrap.js";
eval( EAInclude(ISEJScriptLib) );


ISEStep( "ngdbuild",
         "-intstyle ise -p xc7vx690tffg1930-2 -dd _ngo -uc \"mux16_w8.ucf\" \"mux16_w8.edf\"" );
ISEStep( "map",
         "-intstyle pa -w \"mux16_w8.ngd\"" );
ISEStep( "par",
         "-intstyle pa \"mux16_w8.ncd\" -w \"mux16_w8_routed.ncd\"" );
ISEStep( "trce",
         "-intstyle ise -o \"mux16_w8.twr\" -v 30 -l 30 \"mux16_w8_routed.ncd\" \"mux16_w8.pcf\"" );
ISEStep( "xdl",
         "-secure -ncd2xdl -nopips \"mux16_w8_routed.ncd\" \"mux16_w8_routed.xdl\"" );



function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
