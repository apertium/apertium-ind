#!/usr/local/bin/perl

## foma-to-apertium.pl
## Author: Septina Dian Larasati
## septina.larasati@gmail.com
## 28th May 2010

## Change the output of Foma into a input format of apertium-transfer
## Usage: echo [SENTENCE] | perl foma-to-apertium.pl [BINFILE]

my $SENTENCE = <STDIN>;
my $BINFILE = $ARGV[0];
my $OUTPUT = "";

# the commands: echo "perangkat" | sed -e 's/ /\napply up /g; s/^/load xfst-id.bin\napply up /' | foma | tail -n+10 | sed -n '1h;1!H;${;g;s/.foma\[1\]: /\$ \^/g;s/\n/\//g;s/foma\[1\]: /\^/;s/ \^$//;p;}' | perl -pe 's/\+([^\+\$\/]+)/<\1>/g'
open( STATUS, "| sed -e 's/ /\\napply up /g; s/^/load $BINFILE\\napply up /' | foma | tail -n+10 | sed -n '1h;1!H;\${;g;s/.foma\\[1\\]: /\\\$ \\^/g;s/\\n/\\//g;s/foma\\[1\\]: /\\^/;s/ \\^\$//;p;}' | perl -pe 's/\\+([^\\+\\\$\\/]+)/<\\1>/g'" );

print STATUS $SENTENCE;
close STATUS;


