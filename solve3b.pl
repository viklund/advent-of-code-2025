#!/usr/bin/env perl -ln

my @r=split//;
my @s=splice@r,0,12;
for (@r) {
    @s[12] = $_;
    for $i (0..11) {
        if ($s[$i] < $s[$i+1]) {
            @s[$i..11] = @s[$i+1..12];
            last;
        }
    }
}
my $n = join '', @s[0..11];
$S+=$n;
END {
    print "$S";
}
