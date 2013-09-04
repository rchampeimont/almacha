#!/usr/bin/perl

#  I, Raphael Champeimont, the author of this program,
#  hereby release it into the public domain.
#  This applies worldwide.
#  
#  In case this is not legally possible:
#  I grant anyone the right to use this work for any purpose,
#  without any conditions, unless such conditions are required by law.
#  
#  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# IMPORTANT NOTE: This program is not secure in this way:
# IRC users might make this bot loop forever or consume
# memory. But they cannot make it write files or do "dangerous"
# things because it uses the Safe module to execute
# untrusted code.

use Net::IRC;
use strict;
use warnings;
use charnames ':full';
use Safe;

my $irc = new Net::IRC;

my $server = "leopard";
my $chan = '##empty';
my $myname = 'AlmaRegex';

my $conn = $irc->newconn(
  Server => $server,
  Nick   => $myname,
  Port   => 57914
);

my %last;

$conn->{channel} = $chan;

my $appname = 'AlmaRegex';
my $rev = '$Rev: 253 $';
$rev =~ /^\$Rev: (.+?) \$$/;
my $version = $1;

$conn->add_handler(376, \&icome);
$conn->add_handler('join', \&comes);
$conn->add_handler('msg', \&priv);
$conn->add_handler('cversion', \&ver);
$conn->add_handler('public', \&speaks);
$conn->add_handler('part', \&leaves);
$conn->add_handler('quit', \&leaves);
$conn->add_handler('nick', \&nick);

$irc->start();

# Functions

sub say {
  $conn->privmsg($conn->{channel}, "@_");
}

sub mm {
  my @line = split(/\n/, $_[0]);
  foreach (@line) {
    $conn->privmsg($conn->{channel}, $_);
  }
}

sub icome {
  $conn->join($conn->{channel});
  $conn->privmsg($conn->{channel}, "Hi! I am $appname (Revision $version).");
  $conn->{connected} = 1;
}

sub comes {
  my $event = $_[1];
  my $nick = $event->{nick};
  $last{$nick} = "";
}

sub priv {
  my $event = $_[1];
  my $nick = $event->{nick};
  $conn->privmsg($nick, "Sorry, I do not answer private messages.");
}

sub ver {
  my $event = $_[1];
  my $nick = $event->{nick};
  $conn->ctcp_reply($nick, "VERSION $appname $version");
}

sub leaves {
  my $event = $_[1];
  my $nick = $event->{nick};
  delete $last{$nick};
}

sub nick {
  my $event = $_[1];
  my $old = $event->{nick};
  my $new = $event->{args}[0];
  $last{$new} = $last{$old};
  delete $last{$old};
}

sub ikick {
  my ($who,$why) = @_;
  $conn->kick($conn->{channel}, $who, $why);
}

sub speaks {
  my $event = $_[1];
  my $text = $event->{args}[0];
  my $nick = $event->{nick};

  if ($text =~ m!^s/(.*?)/(.*?)/([imsxg]*?)$!) {
    my ($a,$b,$c) = ($1,$2,$3);
    my $s = $last{$nick};
    if (not defined $s) {
      $last{$nick} = $text;
      return;
    }

    my $result;
    {
      my $box = Safe->new();
      $box->reval('my $s');
      my $boxsref = $box->reval('\$s');
      $$boxsref = $s;
      $box->reval("\$r = \$s =~ $text");
      if ($@) {
	say($@);
	if ($@ =~ /^'.*?' trapped/) {
	  ikick($nick, "I use the Safe perl module!");
	}
	return;
      }
      $result = $box->reval('$r');
      $s = $box->reval('$s');
    }

    if (not $result) {
      ikick($nick,"Regex does not match.");
    } else {
      $last{$nick} = $s;
      say($last{$nick});
    }
  } else {
    $last{$nick} = $text;
  }
}


