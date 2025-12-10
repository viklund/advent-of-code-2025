#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my @cs;
my ($minx, $miny, $maxx, $maxy);
while(<>) {
    chomp;
    my (@c) = split /,/;
    $c[0] /= 100;
    $c[1] /= 100;
    if (!$minx) {
        ($minx, $miny) = @c;
        ($maxx, $maxy) = @c;
    }
    if ($c[0] < $minx) {
        $minx = $c[0];
    }
    elsif ($c[0] > $maxx) {
        $maxx = $c[0];
    }
    if ($c[1] < $miny) {
        $miny = $c[1];
    }
    elsif ($c[1] > $maxy) {
        $maxy = $c[1];
    }
    push @cs, \@c;
}

say STDERR "$minx  $miny";
say STDERR "$maxx  $maxy";

say qq{<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">};

for my $ci (0..$#cs-1) {
    printf qq{    <line x1="%d" y1="%d" x2="%d" y2="%d" stroke="black" stroke-width="2" />\n},
        @{ $cs[$ci] }, @{ $cs[$ci+1] };
}
say qq{</svg>};
