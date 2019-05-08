#!/usr/bin/perl -wnl

(/,(RB|WR|QB|TE),[0-9]{2},([0-9]{1,2})/ && $2 > 3) and print;
