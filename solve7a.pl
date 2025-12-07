#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my $n = 0;
my @p;
while (<>) {
    chomp;
    s/S/\|/g; # We don't need no start....
    my @r = split //;
    if (!@p) {
        @p = @r;
        next;
    }
    for my $i (0..$#r) {
        next if $p[$i] eq '.';
        if ($p[$i] eq '|') {
            if ($r[$i] eq '.') {
                $r[$i] = $p[$i];
            }
            elsif ($r[$i] eq '^') {
                $n++;
                $r[$i-1] = '|';
                $r[$i+1] = '|';
            }
        }
    }
    @p = @r;
}

say $n;
