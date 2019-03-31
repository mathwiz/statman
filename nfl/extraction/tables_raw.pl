#!/usr/bin/perl
use strict;
use HTML::TableExtract;

#my $html_string = do { local $/; <STDIN> };
#print $html_string; 

my $in_table = 0;
foreach my $line (<>) {
    if ($line =~ /<\/table/) { 
        print $line; 
        $in_table = 0; 
    }
    if ($line =~ /<table/) { 
        $in_table = 1; 
    }
    $in_table and print $line;
}