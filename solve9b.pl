#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my @coords;
while (<>) {
    chomp;
    push @coords, [split /,/];
}
push @coords, $coords[0], $coords[1]; # Wrap around

my $max = 0;
for my $ci (0..$#coords-4) {
    my @cs = @coords[$ci..$ci+3];
    for my $c (@cs) {
        printf " >  %d,%d", @$c;
    }
    print "\n";
    my $f = generate_fourth_corner(@cs);
    if ( $f ) {
        my $size = (1+abs($cs[0][0] - $cs[2][0])) * (1+abs($cs[0][1] - $cs[2][1]));
        if ($size > $max) {
            $max = $size;
            print "BIGGER: ";
            for my $c (@cs) {
                printf "  %d,%d", @$c;
            }
            printf "    -> %d,%d", @$f;
            print "\n";
        }
    }
}
say $max;

sub generate_fourth_corner {
    my(@cs) = @_;
    #          # (0,0) is top left
    # X--1---X # X coords increase to the right
    # |      | # Y coords increase downwards
    # 4      2 #
    # |      | #
    # X--3---X #
    #          #

    # CASE 1, First are on same row going right then next must be under 2
    if ($cs[0][1] == $cs[1][1] && $cs[0][0] < $cs[1][0]) {
        say "  > 1";
        return '' if $cs[2][1] < $cs[1][1];
        my $nc = [ $cs[0][0], $cs[2][1] ];
        say "  > 1 NC @$nc";
        return '' if $nc->[0] < $cs[3][0];
        say "  > 1 YES";
        return $nc;
    }
    # CASE 2
    if ($cs[0][0] == $cs[1][0] && $cs[0][1] < $cs[1][1] ) {
        say "  > 2";
        return '' if $cs[2][0] > $cs[1][0];
        my $nc = [ $cs[2][0], $cs[0][1] ];
        say "  > 2 NC @$nc";
        return '' if $nc->[1] < $cs[3][1];
        say "  > 2 YES";
        return $nc;
    }
    # CASE 3
    if ($cs[0][1] == $cs[1][1] && $cs[0][0] > $cs[1][0] ) {
        say "  > 3";
        return '' if $cs[2][1] > $cs[1][1];
        my $nc = [ $cs[0][0], $cs[2][1] ];
        say "  > 3 NC @$nc";
        return '' if $nc->[0] > $cs[3][0];
        say "  > 3 YES";
        return $nc;
    }
    # CASE 4
    if ($cs[0][0] == $cs[1][0] && $cs[0][1] > $cs[1][1]) {
        say "  > 4";
        return '' if $cs[2][0] < $cs[1][0];
        say "  > 4 NC";
        my $nc = [ $cs[2][0], $cs[0][1] ];
        say "  > 4 NC @$nc";
        return '' if $nc->[1] > $cs[3][1];
        say "  > 4 YES";
        return $nc;
    }
    return '';
}
