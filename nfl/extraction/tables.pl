#!/usr/bin/perl
use strict;
use HTML::TableExtract;

my $html_string = do { local $/; <STDIN> };

my $te = HTML::TableExtract->new( );
$te->parse($html_string);
 
foreach my $ts ($te->tables) {
  my $table_coords = "Table (" . join(',', $ts->coords) . ")";
  print "$table_coords\n";
  foreach my $row ($ts->rows) {
     print join(',', @$row), "\n";
  }
  print "/$table_coords\n";
}