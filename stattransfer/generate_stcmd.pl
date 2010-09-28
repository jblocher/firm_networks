#!/usr/bin/perl
# This file generates a StatTransfer .stcmd file since it seems unable to use wildcards
# rather than deal with filehandls, simply run this program and route the output to a file, as such:
# ./generate_stcmd.pl > generate_varlist.stcmd

# first, we define text strings needed to generate our command file
my $cmd = "vars";
my $dir = "/largefs/jabloche/firmnet/";
my $sasprename = "yrqtr";
my $saspostname = ".sas7bdat";
my $txtprename = "varlist";
my $txtpostname = ".txt";

print "
// Author: Jesse Blocher
// Date: September 2010
// Project: Firm Network Corrlations - Market interconnectedness. Whatever
// This file: generate_convert_varlist.stcmd
// Desc: pulls varlist from SAS files so we can get CUSIPs attached to matrices later
// Uses wildcards to convert all of them
//
// to run this program, run this:
// bsub -q week -R Stattransfer -o <outfile>.out st <filename>.stcmd
\n
";


# next, we list the directory and pull out all the filenames
# note the backquotes on the command
@lines = `ls -lh /largefs/jabloche/firmnet/`;
foreach (@lines) {
	#parentheses inside the match store the match in the variable name $1
	if (/yrqtr(\d{6}).sas7bdat/) {
	print "$cmd $dir$sasprename$1$saspostname $txtprename$1$txtpostname \n";
	}
}

print "\nquit \n";