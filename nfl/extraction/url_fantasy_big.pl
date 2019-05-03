#!/usr/bin/perl -s
# Usage: url_fantasy.pl -season=2018
use strict;
use warnings;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname abs_path $0;
use functions qw(pfr_domain);

our ($season);
my $domain = pfr_domain();
my $base = "https://$domain";

my $query = "/years/$season/fantasy.htm";
print $base . $query;