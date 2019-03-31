package functions;
use strict;
use warnings FATAL => 'all';
use Exporter qw(import);
use List::Util qw(reduce);

our @EXPORT = qw(delta_compare);
our @EXPORT_OK = qw(pfr_domain);


sub delta_compare {
    my ($actual, $expected, $delta) = @_;
    abs($actual - $expected) < $delta ? 1 : 0;
}

sub pfr_domain {
    return "www.pro-football-reference.com";
}

1;