#!/usr/bin/env perl
$|++;

use strict;
use warnings;

use feature qw( say );

my %path;
while (<>) {
    s/://g;
    my ($source, @dest) = split;
    push @{ $path{$source} }, $_ for @dest;
}

my $n = 0;
my @p = ();

# Cheat developed by plotting the graph
my @paths = (
    [['dac'], ['out']],
    [[qw(ktw wgs cvs mrc hri)], ['dac']],
    [[qw(rpb nhi bhv uej qbc)], [qw(ktw wgs cvs mrc hri)]],
    [[qw(fip lzo owc ppc)], [qw(rpb nhi bhv uej qbc)]],
    [['fft'], [qw(fip lzo owc ppc)]],
    [[qw(bme qxa spk nha)], ['fft']],
    [['svr'], [qw(bme qxa spk nha)]],
);

my %new_graph = ();

my $res = 1;
my %blacklist = ();
for my $path (@paths) {
    my %dests = map { ($_, 1) } @{$path->[1]};
    my %visited = ();
    
    $blacklist{$_}++ for @{$path->[1]};
    my $c = 0;
    for my $src (@{$path->[0]}) {
        for my $dest (@{$path->[1]}) {
            delete $blacklist{$dest};
            my $r = count_paths($src, $dest, \%blacklist, \%visited);
            push @{$new_graph{$src}}, { d => $dest, score => $r };
            $blacklist{$dest}++;
            printf "%6d %s -> %s\n", $r, $src, $dest;
        }
    }

    $blacklist{$_}++ for keys %visited;
}

say mult_paths('svr');

sub mult_paths {
    my $start = shift;
    if (! exists $new_graph{$start}) {
        return 1;
    }
    my $n = 0;
    for my $p (@{ $new_graph{$start} }) {
        $n += $p->{score} * mult_paths($p->{d});
    }
    return $n;
}

say "TOTAL: $res";

sub count_paths {
    my ($source, $dest, $quick_kill, $visited) = @_;
    if ( $source eq $dest ) {
        return 1;
    }
    if ( exists $quick_kill->{$source} ) {
        #say "QUICK KILL!";
        return 0;
    }
    $visited->{$source}++;
    my $c = 0;
    return 0 unless exists $path{$source};
    for my $d (@{ $path{$source} } ) {
        $c += count_paths($d, $dest, $quick_kill);
    }
    return $c;
}
