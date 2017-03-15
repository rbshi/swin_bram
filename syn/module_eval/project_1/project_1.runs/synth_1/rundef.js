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


ISEStep( "xst",
         "-ifn \"swin_wrap.xst\" -ofn \"swin_wrap.srp\" -intstyle ise" );



function EAInclude( EAInclFilename ) {
  var EAFso = new ActiveXObject( "Scripting.FileSystemObject" );
  var EAInclFile = EAFso.OpenTextFile( EAInclFilename );
  var EAIFContents = EAInclFile.ReadAll();
  EAInclFile.Close();
  return EAIFContents;
}
