#!/usr/bin/perl -s
# Usage: game_url.pl -team=ram -season=2018
use strict;
use warnings;
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname abs_path $0;
use functions qw(pfr_domain);

our ($team, $season);
my $domain = pfr_domain();
my $base = "https://$domain/play-index/tgl_finder.cgi?";

my $query = "request=1&match=game&year_min=$season&year_max=$season&game_type=R&game_num_min=0&game_num_max=99";
$query .= "&week_num_min=0&week_num_max=99&temperature_gtlt=lt&team_id=$team";
$query .= "&c1stat=vegas_line&c1comp=gte&c1val=-50&c2stat=points&c2comp=gte&c3stat=pass_cmp&c3comp=gte&c4stat=rush_att";
$query .= "&c4comp=gte&c5stat=tot_yds&c5comp=gte&c5val=1.0&order_by=game_date&order_by_asc=Y";
print $base . $query;