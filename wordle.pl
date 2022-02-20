#!usr/bin/perl

use strict;
use warnings;

our $tries = 6; 
our $win = 0;

print "-------------------\n0 means not in word\n1 means in word, wrong position\n2 means in right position\n-------------------\n";
print "Enter 5 letter word:\n";

my $filePath = 'wordle-answers-alphabetical.txt';

my @wordList;
my $target;

# my $testArg = $ARGV[0];

open my $file, '<', $filePath or die "$!";
while(<$file>){
    chomp $_;
    push(@wordList, $_);
}

my $count = scalar(@wordList);
my $lineWanted = int(rand($count));

for (my $i = 0; $i < $count; $i++){
    if ($i == $lineWanted){
	$target = $wordList[$i];
    }
}

# if ($testArg = 1){
print "$target\n";
# }

sub takeInput{
print "Guess: \n";
my $input = <>;
chomp $input;
parseInput($input);
}

sub parseInput{
    my $input = shift;

    my $len = length($input); 
    my @positions;

    if ( $len != 5 ){
        print "Please enter a 5 letter word\n";
        takeInput();
        exit;
    }elsif(!grep( /^$input$/, @wordList)){
	    print "Word not in word list\n";
	    takeInput();
	    exit;
        }
    
    for (my $i = 0; $i < $len; $i++){
        my $targetChar = substr($target, $i, 1);    
        my $inputChar = substr($input, $i, 1);
        $positions[$i] = 0;

        if (index($target, $inputChar) >= 0){
            $positions[$i]++;
        }
        if ($inputChar eq $targetChar){
            $positions[$i]++;
        }
    }

    print "@positions\n";

    my $total = 0;
    foreach (@positions){
        $total += $_;
    }
    if ($total >= scalar(@positions) * 2){
        print "Congrats, you guess the word\n";
        $win = 1; 
    }else{
        $tries--;
    }
}

while ($tries > 0 and $win != 1){
takeInput();

if ($tries == 0){
    print "Out of guesses! The word was $target! Better luck next time!\n";
}
}
