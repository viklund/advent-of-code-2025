#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my @map;
while (<>) {
    chomp;
    push @map, [split //];
}

for my $r (@map) {
    say join ' ', @$r;
}
