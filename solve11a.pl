#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my %path;
while (<>) {
    s/://g;
    my ($source, @dest) = split;
    push @{ $path{$source} }, $_ for @dest;
}

say count_paths('you');

sub count_paths {
    my $source = shift;
    return 1 if $source eq 'out';
    my $c = 0;
    for my $d (@{ $path{$source} } ) {
        $c += count_paths($d);
    }
    return $c;
}
