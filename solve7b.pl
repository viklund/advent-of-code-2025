#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my %counts;

my $MAX = 0;
my @p;
while (<>) {
    chomp;
    s/S/\|/g; # We don't need no start....
    my @r = split //;
    if (!@p) {
        @p = @r;
        for my $i (0..$#r) {
            if ( $p[$i] eq '|' ) {
                $counts{ coord($., $i) } = 1;
            }
        }
        next;
    }

    for my $i (0..$#r) {
        next if $p[$i] eq '.';
        if ($p[$i] eq '|') {
            if ($r[$i] ne '^') {
                $r[$i] = '|';
                $counts{ coord($.,$i) } += $counts{ coord($.-1, $i) };
            }
            elsif ($r[$i] eq '^') {
                $r[$i-1] = '|';
                $r[$i+1] = '|';

                $counts{ coord($.,$i-1) } += $counts{ coord($.-1, $i) };
                $counts{ coord($.,$i+1) } += $counts{ coord($.-1, $i) };
            }
        }
    }
    $MAX = $.;
    @p = @r;
}

my @ENDS = grep /^$MAX,/, keys %counts;

my $n = 0;
for my $end ( sort sorter @ENDS ) {
    my $c = $counts{$end};
    printf "C: %5s  %2d\n", $end, $c;
    $n += $c;
}
say $n;


sub sorter {
    my($a1,$a2) = split /,/,$a;
    my($b1,$b2) = split /,/,$b;
    return $a1<=>$b1 || $a2<=>$b2;
}

sub coord {
    my ($x,$y) = @_;
    sprintf "%d,%d", $x, $y;
}
