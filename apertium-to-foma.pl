#!/usr/local/bin/perl

## apertium-to-foma.pl
## Author: Septina Dian Larasati
## septina.larasati@gmail.com
## 28th May 2010

## Change the output of Foma into a input format of apertium-transfer
## Usage: echo [OUTPUT] | perl apertium-to-foma.pl [BINFILE]

my $OUTPUT = <STDIN>;
my $BINFILE = $ARGV[0];
my $SENTENCE = "";

# the commands: echo "^perangkat<BareNoun>$ ^perangkat<BareNoun>$" | sed -e 's/^/load xfst-id.bin /;s/.\^/\napply down /g;s/[\$>]//g;s/</\+/g' | foma | tail -n+10 | sed -n '1h;1!H;${;g;s/.foma\[1\]://g;s/^foma\[1\]: //g;p;}'
open( STATUS, "| sed -e 's/^/load $BINFILE /;s/.\\^/\\napply down /g;s/[\\\$>]//g;s/</\\+/g' | foma | tail -n+10 | sed -n '1h;1!H;\${;g;s/.foma\\[1\\]://g;s/^foma\\[1\\]: //g;p;}'" );

print STATUS $OUTPUT;
close STATUS;


