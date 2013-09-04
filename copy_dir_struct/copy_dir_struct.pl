#!/usr/bin/perl
# By Raphael Champeimont, public domain

# This programs copies a directory structure.

use strict;
use warnings;

sub usage {
  print "Usage: $0 source_dir dest_dir\n";
  exit 0;
}

sub dodir {
  my ($sdir, $path, $ddir) = @_;
  die if (not defined $ddir);

  # list dir contents
  opendir(DIR, "$sdir$path") || die "can't opendir \"$ddir$path\": $!";
  my @subdirs = readdir DIR;
  closedir DIR;

  # make dir copy
  print "mkdir \"$ddir$path\"\n";
  if (system "mkdir", "-p", "$ddir$path") {
    die $!;
  }

  # go in subdirs
  foreach my $dir (@subdirs) {
    next if ($dir eq "." or $dir eq "..");
    next if not -d "$sdir$path/$dir";
    dodir($sdir, "$path/$dir", $ddir);
  }
}

sub main {

  if (not defined $ARGV[1]) {
    usage();
  }

  my $sdir = $ARGV[0];
  my $ddir = $ARGV[1];

  print "Source: $sdir\nDestination: $ddir\n";

  if (not -d $sdir) {
    die "$sdir is not a directory";
  }

  dodir($sdir, "", $ddir);

}

main();
