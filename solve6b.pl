#!/usr/bin/env perl
use strict;
use warnings;

use feature qw( say );

my $nc = 0;
my @stuff;
while (<>) {
    my @c = split;
    $nc = $#c;
    push @stuff, \@c;
}

@stuff = reverse @stuff;

my %ops = (
    '+' => sub { return $_[0] + $_[1] },
    '*' => sub { return $_[0] * $_[1] },
);

my $s = 0;
for my $i (0..$nc) {
    my $op = $stuff[0][$i];
    my $res = $stuff[1][$i];
    $op = $ops{$op};

    for my $ri (2..$#stuff) {
        $res = $op->($res, $stuff[$ri][$i]);
    }
    $s += $res;
}

say $s;
