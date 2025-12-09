#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my @coords;
while (<>) {
    chomp;
    push @coords, [split /,/];
}
push @coords, $coords[0]; # Wrap around

my $max = 0;
for my $ci (0..$#coords-1) {
    TRY:
    for my $cj ($ci+1..$#coords) {
        my @cs = ($coords[$ci], $coords[$cj]);
        my $size = (1+abs($cs[0][0] - $cs[1][0])) * (1+abs($cs[0][1] - $cs[1][1]));
        if ( $size > $max ) {
            for my $pi (0..$#coords-1) {
                if (line_crossing(@coords[$pi, $pi+1], @cs)) {
                    next TRY;
                }

            }
            $max = $size;
        }
    }
}
say "$max";

sub line_crossing {
    my ($l1, $l2, @cs) = @_;
    my @xs = sort { $a <=> $b } map { $_->[0] } @cs;
    my @ys = sort { $a <=> $b } map { $_->[1] } @cs;
    # X coordinate the same, test vertical
    if ( $l1->[0] == $l2->[0] ) {
        ## Line is outside on sides
        return if $l1->[0] <= $xs[0];
        return if $l1->[0] >= $xs[1];

        my (@ly) = sort { $a <=> $b } ($l1->[1], $l2->[1]);
        ## Line is outside, up or down
        return if $ly[1] <= $ys[0];
        return if $ly[0] >= $ys[1];

        return 1;
    }
    # Y coordinate the same, test horizontal
    if ( $l1->[1] == $l2->[1] ) {
        ## Line is outside above or below
        return if $l1->[1] <= $ys[0];
        return if $l1->[1] >= $ys[1];

        my (@lx) = sort { $a <=> $b } ($l1->[0], $l2->[0]);
        ## Line is outside, left or right
        return if $lx[1] <= $xs[0];
        return if $lx[0] >= $xs[1];

        return 1;
    }
    return;
}
