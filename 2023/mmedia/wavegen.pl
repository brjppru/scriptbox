#!/usr/bin/perl
# Generate a sine wave at some frequency

$rate="8196";
$pi=3.141;
$seconds=5;
$length= $rate*$seconds;
foreach $f (220) {
    $period= $rate/$f;
    $glob=2*$pi/$period;
    for($s=1;$s<$length;$s++) {
        $out=sin($s*$glob)*127+128;
        printf("%c",$out);
    }
}