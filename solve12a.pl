#!/usr/bin/env perl
$|++;

use strict;
use warnings;

use feature qw( say );
use List::Util qw( sum );

my @shapes;
my @shape;
while (<>) {
    chomp;
    if ( /^\d+:/ ) {
        next;
    }
    if ( /^\s*$/ && @shape) {
        my $w = sum map { s/#/#/g } @shape;
        push @shapes, { s => [@shape], w => $w };
        @shape = ();
        next;
    }
    if ( /^\.|#/ ) {
        push @shape, $_;
        next;
    }
    if ( /^(\d+)x(\d+): (.*)$/ ) {
        my ($sizex, $sizey, $spec) = ($1, $2, $3);
        my @spec = split /\s+/, $spec;
        my $min_space = 0;
        for my $idx (0..$#spec) {
            $min_space += $spec[$idx] * $shapes[$idx]{w};
        }
        my $area = $sizex*$sizey;
        if ( $min_space > $area ) {
            say "$area - $min_space ($sizex ** $sizey -- ", join(' || ', @spec), ")";
        }
    }
}

sub greedy_pack {
    my ($area, $shape) = @_;
    my @all_versions = generate_all_rotations_and_flips( $shape );
}

sub generate_all_rotations_and_flips {
    my $shape = shift;

}

#for my $s (@shapes) {
#say $s->{w}, "  :  ", join(' - ', @{$s->{s}});
#}
