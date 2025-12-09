#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my @coords;
while (<>) {
    chomp;
    push @coords, [split /,/];
}
