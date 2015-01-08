#!/bin/awk -f
function remove_tab(line)
{
     gsub("\t","/",$0); print;
}

BEGIN { print " - Mesages - " }
{ if ( !/make/ && !/mkdir/ && !/iverilog/ && !/ln/ && !/gcc/ && !/PYTHONPATH/ && !/TESTCASE/ && !/vvp/) 
	remove_tab($0); }

END { print " - DONE - " }
