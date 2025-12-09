#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my @coords;
while (<>) {
    chomp;
    push @coords, [split /,/];
}

my $center = calculate_center();

my %remove = ();

for my $ci (0..$#coords-1) {
    for my $cj ($ci+1..$#coords) {
        if (is_outside($coords[$ci], $coords[$cj]) ) {
            $remove{$cj}++;
        }
    }
}

my @chosen = ();
for my $ci (0..$#coords) {
    push @chosen, $coords[$ci] unless $remove{$ci};
}

my $max = 0;
for my $ci (0..$#chosen-1) {
    for my $cj ($ci+1..$#chosen) {
        my $size = (1+abs($chosen[$ci][0]-$chosen[$cj][0])) * (1+abs($chosen[$ci][1]-$chosen[$cj][1]));
        if ($size > $max) {
            $max = $size;
        }
    }
}

say $max;


#for my $c (@coords) {

sub is_outside {
    my ($c1, $c2) = @_;
    # Lower right
    if (lower_right($c1)) {
        return '' unless lower_right($c2);
        if ( $c1->[0] >= $c2->[0] && $c1->[1] >= $c2->[1] ) {
            return 1;
        }
    }
    if (upper_right($c1)) {
        return '' unless upper_right($c2);
        if ( $c1->[0] >= $c2->[0] && $c1->[1] <= $c2->[1] ) {
            return 1;
        }
    }
    if (upper_left($c1)) {
        return '' unless upper_left($c2);
        if ( $c1->[0] <= $c2->[0] && $c1->[1] <= $c2->[1] ) {
            return 1;
        }
    }
    if (lower_left($c1)) {
        return '' unless lower_left($c2);
        if ( $c1->[0] <= $c2->[0] && $c1->[1] >= $c2->[1] ) {
            return 1;
        }
    }
    return '';
}

sub lower_right {
    my ($c) = @_;
    return $c->[0] > $center->[0] && $c->[1] > $center->[1];
}
sub upper_right {
    my ($c) = @_;
    return $c->[0] > $center->[0] && $c->[1] < $center->[1];
}
sub upper_left {
    my ($c) = @_;
    return $c->[0] < $center->[0] && $c->[1] < $center->[1];
}
sub lower_left {
    my ($c) = @_;
    return $c->[0] < $center->[0] && $c->[1] > $center->[1];
}

sub calculate_center {
    my $x = 0;
    my $y = 0;
    for my $c (@coords) {
        $x+=$c->[0];
        $y+=$c->[1];
    }
    return [$x/@coords, $y/@coords];
}
