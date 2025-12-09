#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;


my @boxes;
while (<>) {
    chomp;
    my @coords = split /,/;
    push @boxes, \@coords;
}

my @dist_matrix;
compute_dist_matrix();
#print_dist_matrix();

my @dists = order_distances();

my %group_of = ();
my $groupN = 0;

my @lastXs = ();
for my $dist ( @dists ) {
    my ($ii,$jj,$d) = @$dist;
    if (! exists $group_of{$ii} and ! exists $group_of{$jj}) {
        #say "NEW GROUP $groupN ($ii, $jj)";
        @lastXs = ($boxes[$ii][0], $boxes[$jj][0]);
        $group_of{$ii} = $group_of{$jj} = $groupN++;
        next;
    }
    if ( ! exists $group_of{$ii} ) {
        #say " -> 1 Just adding $ii to $group_of{$jj} (($jj))";
        @lastXs = ($boxes[$ii][0], $boxes[$jj][0]);
        $group_of{$ii} = $group_of{$jj};
        next;
    }
    if ( ! exists $group_of{$jj} ) {
        #say " -> 2 Just adding $jj to $group_of{$ii} (($ii))";
        @lastXs = ($boxes[$ii][0], $boxes[$jj][0]);
        $group_of{$jj} = $group_of{$ii};
        next;
    }

    # Already connected
    if ( $group_of{$ii} == $group_of{$jj} ) {
        #say " -> 3 Already same $jj and $ii, $group_of{$ii}";
        next;
    }

    # Always merge towards $ii
    @lastXs = ($boxes[$ii][0], $boxes[$jj][0]);
    my @jj_groups = grep { $group_of{$_} == $group_of{$jj} } keys %group_of;
    for my $jg (@jj_groups) {
        $group_of{$jg} = $group_of{$ii};
    }
    #say " -> 4 Merging, $group_of{$jj}(@jj_groups) => $group_of{$ii}";
}

say $lastXs[0] * $lastXs[1];


sub order_distances {
    my @distances = ();
    for my $ii (0..$#boxes-1) {
        for my $jj ($ii+1..$#boxes) {
            push @distances, [$ii, $jj, $dist_matrix[$ii][$jj]];
        }
    }
    return sort { $a->[2] <=> $b->[2] } @distances;
}

sub print_dist_matrix {
    for my $ii (0..$#boxes-1) {
        printf "%4d ", $ii;
        for my $jj ($ii+1..$#boxes) {
            printf "%6.1f ", $dist_matrix[$ii][$jj];
        }
        print "\n";
    }
}

sub compute_dist_matrix {
    for my $ii (0..$#boxes-1) {
        for my $jj ($ii+1..$#boxes) {
            $dist_matrix[$ii][$jj] = compute_distance($boxes[$ii], $boxes[$jj]);
            $dist_matrix[$jj][$ii] = $dist_matrix[$ii][$jj];
        }
    }
}

sub compute_distance {
    my ($x,$y) = @_;
    return sqrt( ($x->[0] - $y->[0])**2 + ($x->[1] - $y->[1])**2 + ($x->[2] - $y->[2])**2);
}
