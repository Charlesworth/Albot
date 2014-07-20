# Copyright (C) 1991-2011 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.


# Quartus II Version 11.0 Build 208 07/03/2011 Service Pack 1 SJ Full Version
# File: signalprobe_qsf.tcl
# Generated on: Mon Oct 22 11:20:53 2012

# Note: This file contains a Tcl script generated from the SignalProbe Gui.
#       You can use this script to restore SignalProbes after deleting the DB
#       folder; at the command line use "quartus_cdb -t signalprobe_qsf.tcl".

package require ::quartus::chip_planner
package require ::quartus::project
project_open VGA-Camera-2006 -revision VGA-Camera-2006
read_netlist
set had_failure 0

############
# Index: 1 #
############
set result [ make_sp  -src_name "J1_pin4" -loc PIN_3 -pin_name "J1_pin4_signalProbe" -io_std "3.3-V LVTTL" ] 
if { $result == 0 } { 
	 puts "FAIL (J1_pin4_signalProbe): make_sp  -src_name \"J1_pin4\" -loc PIN_3 -pin_name \"J1_pin4_signalProbe\" -io_std \"3.3-V LVTTL\""
} else { 
 	 puts "SET  (J1_pin4_signalProbe): make_sp  -src_name \"J1_pin4\" -loc PIN_3 -pin_name \"J1_pin4_signalProbe\" -io_std \"3.3-V LVTTL\""
} 

