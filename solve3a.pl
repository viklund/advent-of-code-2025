#!/usr/bin/env perl -ln

my ($n1,$n2,@r)=split//;
for (@r) {
    if ($n2>$n1) {
        ($n1,$n2) = ($n2, $_);
    }
    elsif ($_>$n2) {
        $n2 = $_;
    }
}
$S+=$n1*10+$n2;
END {
    print "$S";
}
