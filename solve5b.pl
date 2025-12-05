#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my @fresh;
while (<>) {
    chomp;
    last unless $_;
    my ($start, $end) = split /-/;
    push @fresh, [$start, $end];
}

@fresh = sort {$a->[0] <=> $b->[0]} @fresh;
my @merged_ranges = shift @fresh;

FRESH:
for my $r (@fresh) {
    for my $m ( @merged_ranges ) {
        if ( $r->[0] >= $m->[0] && $r->[0] <= $m->[1] ) {
            next FRESH if $r->[1] <= $m->[1]; # Completely contained
            $m->[1] = $r->[1];
            next FRESH;
        }
    }
    push @merged_ranges, $r;
}

my $n = 0;
for my $m (@merged_ranges) {
    $n += $m->[1] - $m->[0] + 1;
}
say $n;
