#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use feature qw(say);
use File::Basename qw(dirname);
use Cwd  qw(abs_path);
use lib dirname abs_path $0;

my $fantasy_reference = "https://www.pro-football-reference.com/play-index/psl_finder.cgi?request=1&match=single&year_min=2018&year_max=2018&season_start=1&season_end=-1&pos%5B%5D=qb&pos%5B%5D=rb&pos%5B%5D=wr&pos%5B%5D=te&c1stat=g&c1comp=gt&c1val=8&order_by=fantasy_points_ppr_per_game";
my $fantasysearch = `perl url_fantasy.pl -season=2018 `;

my $game_reference = "https://www.pro-football-reference.com/play-index/tgl_finder.cgi?request=1&match=game&year_min=2018&year_max=2018&game_type=R&game_num_min=0&game_num_max=99&week_num_min=0&week_num_max=99&temperature_gtlt=lt&team_id=crd&c1stat=vegas_line&c1comp=gte&c1val=-50&c2stat=points&c2comp=gte&c3stat=pass_cmp&c3comp=gte&c4stat=rush_att&c4comp=gte&c5stat=tot_yds&c5comp=gte&c5val=1.0&order_by=game_date&order_by_asc=Y";
my $gamesearch = `perl url_game.pl -team=crd -season=2018 `;

is ($fantasysearch, $fantasy_reference);
is ($gamesearch, $game_reference);

done_testing();