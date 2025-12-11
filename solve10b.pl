#!/usr/bin/env perl
use strict;
use warnings;

use feature qw/ say /;

my $s = 0;
while (<>) {
    chomp;
    my @fields = split;
    my $indicator = shift @fields;
    my $joltage = pop @fields;
    my @buttons = map { s/[()]//g; [split /,/,$_] } @fields;

    $indicator =~ s/\[|\]//g;
    my @indicator = map { /#/ ? 1 : 0 } split //, $indicator;

    $joltage =~ s/[{}]//g;
    my @joltage = split /,/, $joltage;

    my $n = solve_button_presses(\@joltage, \@buttons);
    printf "%3d/153 [%3.0f%%]   %2d\n", $., $./153*100, $n;
    $s += $n;
}

say $s;

sub solve_button_presses {
    my ($target, $buttons) = @_;
    
    my @current = map { 0 } @$target;

    my $best = 999999;
    #for my $depth (7..20) {
    my $depth=12;
        my $r = _solve_button_presses($target, $buttons, [@current], 0, $depth);
        if ( $r < $best ) {
            return $r;
        }
    #}
    return $best;
}

sub _solve_button_presses {
    my ($target, $buttons, $current, $n, $max_depth) = @_;
    printf "%s  %s   (%3d)  %d(%d)\n", join(',', @$target), join(',', @$current), scalar(@$buttons), $n, $max_depth
        if $n<5;
    if ($n > $max_depth) {
        return 999999;
    }

    for my $idx (0..$#$target) {
        return 999999 if $current->[$idx] > $target->[$idx];
    }

    my $min = 999999;
    BUTTON:
    for my $bi (0..$#$buttons) {
        my $b = $buttons->[$bi];

        next BUTTON unless the_button_is_good($target, $current, $b);

        my $new = _press($b, $current);        
        if (_match_target($target, $new)) {
            return $n+1;
        }

        my $r = _solve_button_presses($target, $buttons, [@$new], $n+1, $max_depth);
        if ( $r < $min ) {
            $min = $r;
        }
    }
    return $min;
}

sub _match_target {
    my ($target, $current) = @_;
    return distance($target, $current) == 0;
}

sub _press {
    my ($button, $current) = @_;
    my @ret = @$current;
    for my $idx (@$button) {
        $ret[$idx]++;
    }
    return \@ret;
}

sub sort_buttons {
    my ($target, $current, $buttons) = @_;
    my @scores = ();
    for my $b (@$buttons) {
        my $new = _press( $b, $current );        
        push @scores, distance($new, $target);
    }
    my @idx_sorted = sort { $scores[$a] <=> $scores[$b] } 0..$#scores;
    return @$buttons[@idx_sorted];
}

# A button is bad if it adds to an already full counter
sub the_button_is_good {
    my ($target, $current, $b) = @_;
    for my $bi (@$b) {
        if ( $target->[$bi] <= $current->[$bi] ) {
            return '';
        }
    }
    return 1
}

sub distance {
    my ($target, $current) = @_;
    my $dist = 0;
    for my $idx (0..$#$target) {
        $dist++ if $target->[$idx] != $current->[$idx];
    }
    return $dist;
}
