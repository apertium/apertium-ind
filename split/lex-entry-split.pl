#!/usr/bin/perl

# Splitting Lexical Entries
# Input file a sorted lexical entry preceeded by the type and ||
# eg.
# Adjective||dingin@P.POS.v@   InflectionOption ;
# Verb||kirim@P.POS.v@         InflectionOption ;
# Verb||tulis@P.POS.v@         InflectionOption ;


$MAX_NUMBER_OF_ENTRIES = 2000;
$INPUT_MONODIC = "";
$INPUT_CORE = "";
$OUTPUTFILE = "";
@LEXICON_TYPES = ();


$command = `mkdir __temp`;

for( $i = 0; $i <= $#ARGV; $i++ ) {
  if( $ARGV[$i] eq "-inputfile" | $ARGV[$i] eq "-i" )  { $INPUT_MONODIC = $ARGV[++$i]; }
  elsif( $ARGV[$i] eq "-template" | $ARGV[$i] eq "-t" ) { $INPUT_CORE = $ARGV[++$i]; }
  elsif( $ARGV[$i] eq "-outputfile" | $ARGV[$i] eq "-o" ) { $OUTPUT_FILE = $ARGV[++$i]; }
  elsif( $ARGV[$i] eq "-n-entry" | $ARGV[$i] eq "-n" ) { $MAX_NUMBER_OF_ENTRIES = $ARGV[++$i]; }
#  else { Usage( $0, "wrong parameter $ARGV[$i]" ); }
}


$CONTENT = `cat $INPUT_MONODIC | sort | uniq`; # sort and uniq are added for precautions
# $CONTENT = `cat $INPUT_MONODIC | sort`; # sort and uniq are added for precautions
@lines = split(/\n/, $CONTENT) ;
$number_of_lines = scalar( @lines );
$temp = $CONTENT;
$temp =~ s/([^\|\n]+)\|\|[^\n]*/\1/gi;
chomp($temp);
@tlines = split(/\n/, $temp) ;
for ($i = 0; $i < scalar(@tlines); $i++) { $bag{$tlines[$i]}++; }
@LEXICON_TYPES = sort(keys( %bag ));

for ($i = 0; $i < scalar(@LEXICON_TYPES); $i++) { print $LEXICON_TYPES[$i]."\n"; }
print "number of line: ".$number_of_lines."\n";
#print "line: ".$lines[$number_of_lines-1]."\n";
#print "line: ".$lines[6046]."\n";


$split_num = 0;
$line_number = 0;
while ( $line_number < $number_of_lines ) {
  print "split number: ".$split_num."\n";
  $temp = $line_number + $MAX_NUMBER_OF_ENTRIES;
  $tag = "";
  $a = 0;
  $flag = 1;
  $result = "";
  for ( $i = $line_number; $i < $temp; $i++ ) {
    if ( defined( $lines[ $i ] ) ) {
      $tag = $lines[ $i ];
      $tag =~ s/([^\|\n]+)\|\|[^\n]*/\1/gi;

      while ( $tag ne $LEXICON_TYPES[ $a ] and $a < scalar( @LEXICON_TYPES )-1) {
        if( $a ne $c ) {
#        print "LEXICON ".$LEXICON_TYPES[ $a ]."\n\n";
        $result .= "LEXICON ".$LEXICON_TYPES[ $a ]."\n\n";
        }
        $a++;
        $flag = 1;
      }
      if ( $flag eq 1 ) {
         print "\nLEXICON ".$LEXICON_TYPES[ $a ]."\n";
        $result .= "\nLEXICON ".$LEXICON_TYPES[ $a ]."\n";
        $c = $a;
        $flag = 0;
      }
      $flag = $lines[ $i ];
      $flag =~ s/[^\|\n]+\|\|([^\n]+)/\1/gi;
#       print $flag.": ".$i."\n";  
      $result .= $flag."\n";  

    }
    else { last; }
  }
  for ( $c = ($a+1); $c < scalar( @LEXICON_TYPES ); $c++ ) {
    # print "\nLEXICON ".$LEXICON_TYPES[ $c ]."\n\n";
    $result .= "\nLEXICON ".$LEXICON_TYPES[ $c ]."\n\n";
  }



  # print $split_num."\n";
  # print $result."\n\n";
  open( TEMP, ">__temp/_temp$split_num.tmp" );
  # $command = `echo "$result" > temp$split_num.tmp`;
  print TEMP $result;
  close( TEMP );
  $line_number = $i;
  $split_num++;
  $c = 0;
  $a = 0;
  $flag = 1;
}



$net = "define nets [ ";

for ( $i = 0; $i < $split_num; $i++ ) {
#for ( $i = 0; $i < 1; $i++ ) {
  print "making split number: ".$i."\n";
  $CONTENT = `cat $INPUT_CORE`;
  $lex = `cat __temp/_temp$i.tmp`;
  $CONTENT .= "\n".$lex;
  open( TEMP, ">__temp/_temp.lexc" );
  # $command = ` echo "$CONTENT" > _temp.lexc`;
  print TEMP $CONTENT;
  close(TEMP);

  print "compiling split number: ".$i."\n";
  $CONTENT = `cat compile.foma`;
  $CONTENT = "read lexc < __temp/_temp.lexc\n".$CONTENT."\n";
  $CONTENT .= "save stack __temp/xfst-test$i.bin\n\nexit\n";
  open( TEMP, ">__temp/_temp.foma" );
  print TEMP $CONTENT;
  close(TEMP);

#  $command = `cat __temp/_temp.foma | foma`;
  $command = `foma -l __temp/_temp.foma`;


  $combining .= "load __temp/xfst-test$i.bin\n\n";
  $combining .= "define net$i ;\n\n";

  $net .= "net$i | ";

  
}

$net =~ s/\| $/\] ;\n\n/gi ;
$net .= "push nets\n\nsave stack $OUTPUT_FILE\n\nexit\n\n";

open( TEMP, ">combining.foma" );
print TEMP $combining.$net."\n\n";
close(TEMP);

$command = `cat combining.foma | foma`;
#$command = `rm -rf __temp`;

