#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my %fresh;
while (<>) {
    chomp;
    say "Freshing $_";
    last unless $_;
    my ($start, $end) = split /-/;
    $fresh{$_}++ for $start..$end;
}

say " -> Checking";
my $n;
while (<>) {
    chomp;
    $n++ if exists $fresh{$_};
}

say $n;
