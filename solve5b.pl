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

my $n = 0;
while (<>) {
    chomp;
    for my $r (@fresh) {
        last if $_ < $r->[0];

        if ($r->[0] <= $_ && $_ <= $r->[1]) {
            $n++;
            last;
        }
    }
}

say $n;
