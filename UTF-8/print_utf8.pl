#!/usr/bin/perl
# public domain

use strict;
use warnings;
use charnames ':full';
use strict 'refs';

use Encode qw(encode decode);

my $char;

print "Enter an UTF-8 char\n";
chomp ($char = <STDIN>);

if (defined $char and $char ne "") {
  my $unicodechar = decode("UTF-8", $char, Encode::FB_DEFAULT);
  my $charnum = sprintf("%X",ord($unicodechar));
  print("U+$charnum " . charnames::viacode(hex($charnum)) . "   UTF-8: "
    . encode("UTF-8", chr(hex($charnum)), Encode::FB_DEFAULT) . "\n");
} else {
  print("Syntax error.");
}

