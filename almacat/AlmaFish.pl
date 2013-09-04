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

use Net::IRC;
use strict;
use warnings;
use charnames ':full';

my $irc = new Net::IRC;

my $server = "localhost";
my $chan = '##пустой';
my $myname = 'AlmaFish';

my $conn = $irc->newconn(
  Server => $server,
  Nick   => $myname,
  Port   => 57914
);

$conn->{channel} = $chan;

my $appname = 'AlmaFish';
my $rev = '$Rev: 572 $';
$rev =~ /^\$Rev: (.+?) \$$/;
my $version = $1;

$conn->add_handler(376, \&icome);
$conn->add_handler('join', \&comes);
$conn->add_handler('msg', \&priv);
$conn->add_handler('cversion', \&ver);

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

sub hop {
  $conn->mode($conn->{channel}, "+h", $_[0]);
}

sub comes {
  my $event = $_[1];
  my $nick = $event->{nick};
  hop($nick);
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

