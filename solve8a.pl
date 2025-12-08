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

my $conns = 0;
for my $dist ( @dists ) {
    last if $conns == 1000;
    my ($ii,$jj,$d) = @$dist;
    if (! exists $group_of{$ii} and ! exists $group_of{$jj}) {
        #say "NEW GROUP $groupN ($ii, $jj)";
        $group_of{$ii} = $group_of{$jj} = $groupN++;
        $conns++;
        next;
    }
    if ( ! exists $group_of{$ii} ) {
        #say " -> 1 Just adding $ii to $group_of{$jj} (($jj))";
        $group_of{$ii} = $group_of{$jj};
        $conns++;
        next;
    }
    if ( ! exists $group_of{$jj} ) {
        #say " -> 2 Just adding $jj to $group_of{$ii} (($ii))";
        $group_of{$jj} = $group_of{$ii};
        $conns++;
        next;
    }

    # Already connected
    if ( $group_of{$ii} == $group_of{$jj} ) {
        #say " -> 3 Already same $jj and $ii, $group_of{$ii}";
        $conns++;
        next;
    }

    # Always merge towards $ii
    my @jj_groups = grep { $group_of{$_} == $group_of{$jj} } keys %group_of;
    for my $jg (@jj_groups) {
        $group_of{$jg} = $group_of{$ii};
    }
    #say " -> 4 Merging, $group_of{$jj}(@jj_groups) => $group_of{$ii}";
    $conns++;
}

my %group_counts;
for my $k (keys %group_of) {
    $group_counts{$group_of{$k}}++;
}


my @group_order = sort {$group_counts{$b} <=> $group_counts{$a} } keys %group_counts;
#say "SIZE $_: $group_counts{$_}" for @group_order;

say $group_counts{$group_order[0]} * $group_counts{$group_order[1]} * $group_counts{$group_order[2]};

#for my $dist (@dists[0..10]) {
#    printf "%3d %3d %6.1f\n", @$dist;
#}


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
