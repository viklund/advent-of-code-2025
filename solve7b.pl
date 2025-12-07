#!/usr/bin/env perl

use strict;
use warnings;

use feature qw( say );

my %path;

my $MAX = 0;
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
                $r[$i] = '|';
                push @{$path{ coord($., $i) }}, coord($.-1, $i);
            }
            elsif ($r[$i] eq '^') {
                $r[$i-1] = '|';
                $r[$i+1] = '|';

                push @{$path{ coord($., $i-1) }}, coord($.-1, $i);
                push @{$path{ coord($., $i+1) }}, coord($.-1, $i);
            }
        }
    }
    $MAX = $.;
    @p = @r;
}

#print_path();

my @ENDS = grep /^$MAX,/, keys %path;

my $n = 0;
for my $end ( sort sorter @ENDS ) {
    my $c = count_paths( $end );
    printf "C: %5s  %2d\n", $end, $c;
    $n += count_paths( $end );
}
say $n;


sub sorter {
    my($a1,$a2) = split /,/,$a;
    my($b1,$b2) = split /,/,$b;
    return $a1<=>$b1 || $a2<=>$b2;
}

sub count_paths {
    my $coord = shift;
    return 1 unless exists $path{$coord};

    my $up = $path{ $coord };
    if ( @$up == 1 ) {
        return count_paths($up->[0]);
    }

    my $n = 0;
    for (@$up) {
        $n += count_paths($_);
    }
    return $n;
}

sub print_path {
    for my $k (sort sorter keys %path) {
        printf "    %5s => %s\n", $k, join(' ', map { sprintf "%5s", $_ } @{$path{$k}});
    }
}

sub coord {
    my ($x,$y) = @_;
    sprintf "%d,%d", $x, $y;
}
