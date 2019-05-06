#!/usr/bin/perl -wnl

print "$1,$2,$3,$4" if ($_ =~ /<a href="\/players\/[A-Z]{1}\/(.+)\.htm"[^\>]*>([^<]+)<\/a>.*<a[^\>]*>([A-Z]{3})<\/a>,(.+)/) 
