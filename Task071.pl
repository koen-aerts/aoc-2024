#!/usr/bin/perl
use warnings;
use strict;

my @type7 = (5,5,5,5,5);
my @type6 = (1,4,4,4,4);
my @type5 = (2,2,3,3,3);
my @type4 = (1,1,3,3,3);
my @type3 = (1,2,2,2,2);
my @type2 = (1,1,1,2,2);
my @type1 = (1,1,1,1,1);

my @hands;
my @ranks;

sub rank {
    my $deckVal = shift(@_);
    my @parts = split /;/, $deckVal;
    my $deck = $parts[0];
    my $bid = $parts[1];
    my @deckVals = (1,1,1,1,1);
    my $val = 0;
    for my $i (0..length($deck)-1) {
        my $char1 = substr($deck, $i, 1);
        if ($char1 eq '2') {
            $val = (100 * $val);
        } elsif ($char1 eq '3') {
            $val = (100 * $val) + 1;
        } elsif ($char1 eq '4') {
            $val = (100 * $val) + 2;
        } elsif ($char1 eq '5') {
            $val = (100 * $val) + 3;
        } elsif ($char1 eq '6') {
            $val = (100 * $val) + 4;
        } elsif ($char1 eq '7') {
            $val = (100 * $val) + 5;
        } elsif ($char1 eq '8') {
            $val = (100 * $val) + 6;
        } elsif ($char1 eq '9') {
            $val = (100 * $val) + 7;
        } elsif ($char1 eq 'T') {
            $val = (100 * $val) + 8;
        } elsif ($char1 eq 'J') {
            $val = (100 * $val) + 9;
        } elsif ($char1 eq 'Q') {
            $val = (100 * $val) + 10;
        } elsif ($char1 eq 'K') {
            $val = (100 * $val) + 11;
        } elsif ($char1 eq 'A') {
            $val = (100 * $val) + 12;
        }
        for my $j (0..length($deck)-1) {
            my $char2 = substr($deck, $j, 1);
            if ($i != $j && $char1 eq $char2) {
                $deckVals[$i]++;
            }
        }
    }
    my @sortedVals = sort @deckVals;
    my $typeLevel;
    if (@sortedVals ~~ @type1) {
        $typeLevel = 1;
    } elsif (@sortedVals ~~ @type2) {
        $typeLevel = 2;
    } elsif (@sortedVals ~~ @type3) {
        $typeLevel = 3;
    } elsif (@sortedVals ~~ @type4) {
        $typeLevel = 4;
    } elsif (@sortedVals ~~ @type5) {
        $typeLevel = 5;
    } elsif (@sortedVals ~~ @type6) {
        $typeLevel = 6;
    } elsif (@sortedVals ~~ @type7) {
        $typeLevel = 7;
    }
    $val = $val + ($typeLevel * 10000000000);
    push(@ranks, "$val" . ";" . $deckVal);
}

open(FH, '<', 'camel.txt') or die $!;
while(<FH>){
    my @parts = split / /, $_;
    push(@hands, $parts[0] . ";" . $parts[1]);
}
close(FH);

for my $i (0..$#hands) {
    rank($hands[$i]);
}

my @sortedRanks = sort @ranks;

my $totBid = 0;

for my $i (0..$#sortedRanks) {
    my @parts = split /;/, $sortedRanks[$i];
    my $bid = $parts[2] * ($i + 1);
    $totBid = $totBid + $bid;
    #print($sortedRanks[$i] . " -- " . $bid . "\n");
}
print("\nTotal bid: " . $totBid . "\n");
