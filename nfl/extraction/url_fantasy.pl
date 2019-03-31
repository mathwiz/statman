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
my $base = "https://$domain/play-index/psl_finder.cgi?";

my $query = "request=1&match=single&year_min=$season&year_max=$season";
$query .= "&season_start=1&season_end=-1";
$query .= "&pos%5B%5D=qb&pos%5B%5D=rb&pos%5B%5D=wr&pos%5B%5D=te";
#$query .= "&draft_year_min=1936&draft_year_max=2018&draft_slot_min=1&draft_slot_max=500&draft_pick_in_round=pick_overall";
#$query .= "&conference=any&draft_pos%5B%5D=qb&draft_pos%5B%5D=rb&draft_pos%5B%5D=wr&draft_pos%5B%5D=te";
#$query .= "&draft_pos%5B%5D=e&draft_pos%5B%5D=t&draft_pos%5B%5D=g&draft_pos%5B%5D=c&draft_pos%5B%5D=ol";
#$query .= "&draft_pos%5B%5D=dt&draft_pos%5B%5D=de&draft_pos%5B%5D=dl&draft_pos%5B%5D=ilb&draft_pos%5B%5D=olb";
#$query .= "&draft_pos%5B%5D=lb&draft_pos%5B%5D=cb&draft_pos%5B%5D=s&draft_pos%5B%5D=db&draft_pos%5B%5D=k&draft_pos%5B%5D=p";
$query .= "&c1stat=g&c1comp=gt&c1val=8&order_by=fantasy_points_ppr_per_game";
print $base . $query;