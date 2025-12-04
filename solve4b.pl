#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my @map;
while (<>) {
    chomp;
    push @map, [split //];
}

my $DIMR = $#map;
my $DIMC = $#{ $map[0] };

my $answer = 0;
START:
for my $ri (0..$#map) {
    for my $ci (0..$#{$map[$ri]}) {
        next if $map[$ri][$ci] ne '@';
        my @adj = generate_adjacent_positions($ri, $ci);
        my $count=0;
        for my $adj (@adj) {
            $count++ if $map[$adj->[0]][$adj->[1]] eq '@';
        }
        if ( $count < 4 ) {
            $answer++;
            $map[$ri][$ci] = '.';
            goto START;
        }
    }
}
say $answer;

sub generate_adjacent_positions {
    my ($r,$c) = @_;
    my @out;
    for my $ri (-1,0,1) {
        next if $r + $ri < 0;
        next if $r + $ri > $DIMR;
        for my $ci (-1,0,1) {
            next if $c + $ci < 0;
            next if $c + $ci > $DIMC;
            next if $ri == 0 && $ci == 0;
            push @out, [$r+$ri, $c+$ci];
        }
    }
    return @out;
}

sub print_map {
    for my $r (@map) {
        say join ' ', @$r;
    }
}
