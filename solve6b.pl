#!/usr/bin/env perl
use strict;
use warnings;

use feature qw( say );

my @stuff;
while (<>) {
    chomp;
    my @c = split //;
    push @stuff, \@c;
}

my %ops = (
    '+' => sub { return $_[0] + $_[1] },
    '*' => sub { return $_[0] * $_[1] },
);

my $last = 0;
my $s = 0;
my $op;
my $res;
BIGLOOP:
while (1) {
    my $value = '';
    for my $r (@stuff) {
        if (!@$r) {
            $last = 1;
            $value = '  ';
            last;
        }
        my $s = shift @$r;
        $value .= $s;
    }
    if ($value =~ /^\s+$/) {
        $s += $res;
        $op = '';
        $res = 0;
        last BIGLOOP if $last;
        next;
    }
    if ( $value =~ s/^\s*(\d+)\s*(\+|\*)$//g ) {
        $op = $2;
        $res = $1;
        next;
    }
    $value =~ s/^\s*$//g;
    $res = $ops{$op}->($res, $value);
}

say $s;
