#!/usr/bin/perl

## ------------------------------------------------------
## Apertium id-ms
## Capturing compound words
## July 2010
## comp-words.pl
## Author: Septina Dian Larasati
## Email: septina.larasati@gmail.com
## ------------------------------------------------------

## Usage: cat [input file] | perl comp-words.pl [compound words list]
## Example: cat "piranti lunak" | perl comp-words.pl IDCOMPLIST.txt

my $INPUT;
my @DIC;
my $DICFILE;
my $S; $T;


$INPUT = <STDIN>;
$DICFILE = $ARGV[ 0 ];
@DIC = split( /\n/, `cat $DICFILE` );

foreach my $word ( @DIC ){
  ( $S, $T ) = split( /\|\|/, $word );
  $INPUT =~ s/$S/$T/gi;
}

print $INPUT;



