#!/usr/bin/perl -w

use strict;
use LWP::Simple;

my $url = <STDIN>;
my $doc = get($url);
die "Did not retrieve $url" unless $doc;
print $doc;
