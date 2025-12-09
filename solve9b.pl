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
TRY:
for my $ci (0..$#coords-3) {
    my @cs = @coords[$ci..$ci+3];
    my $size = (1+abs($cs[0][0] - $cs[2][0])) * (1+abs($cs[0][1] - $cs[2][1]));
    if ( $size > $max ) {
        for my $p (@coords) {
            if (inside($p, $cs[0], $cs[2])) {
                next TRY;
            }
        }
        $max = $size;
    }
}
say $max;

sub inside {
    my ($p, @cs) = @_;
    
    if ( $p->[0] > $cs[0][0] && $p->[0] < $cs[1][0] ) {
        if ( $p->[1] > $cs[0][1] && $p->[1] < $cs[1][1] ) {
            return 1;
        }
    }
    return '';
}
