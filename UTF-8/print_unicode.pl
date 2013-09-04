#!/usr/bin/perl
# public domain

use strict;
use warnings;
use charnames ':full';
use strict 'refs';

use Encode qw(encode decode);

my $charnum;

print "Enter an unicode char number (U+something)\n";
chomp ($charnum = <STDIN>);

print("U+$charnum " . charnames::viacode(hex($charnum)) . "   UTF-8: "
  . encode("UTF-8", chr(hex($charnum)), Encode::FB_DEFAULT) . "\n");


