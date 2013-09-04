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
use Net::XMPP qw(Client);
use strict;

my $version = '$Rev: 86 $';

# Jabber and IRC objects
my $irc = new Net::IRC;
my $Con = new Net::XMPP::Client();


# Bot CONFIGURATION
# Being config vars
# general config
my $myname    = "AlParrot";
# IRC config
my $ircserver = "localhost";
my $ircport   = 57914;
my $ircchan   = "##empty";
# Jabber config
my $jabserver = "jabber.org";
my $jablogin  = "almacha";
my $jabpass;
# End config vars

# IRC colors
my $colormsg   = ''; # no color
my $colorsay   = '03';
my $colorfrom  = '02';


# hash that contains users connected by Jabber
# (those we send messages to)
my %ju;

# connect to IRC
print "Connecting to IRC...\n";
my $conn = $irc->newconn(Server => $ircserver,
			 Nick   => $myname,
		         Port   => $ircport);
$conn->{channel} = $ircchan;
print "IRC connection: ", ($conn->connected() ? "OK" : "FAILED"), "\n";

# connect to Jabber
print "Connecting to Jabber...\n";
$Con->SetCallBacks(message  => \&jmess,
                   presence => \&jpres);
$Con->Connect(hostname => $jabserver);
print "Jabber connection: ", ($Con->Connected() ? "OK" : "FAILED"), "\n";

# ask user to enter password if not defined
if (not defined $jabpass) {
  print "Enter jabber password: ";
  chomp($jabpass = <STDIN>);
}

# login to Jabber server
my @jstate;
print "Authentificating...\n";
@jstate = $Con->AuthSend(username => $jablogin,
                         resource => $myname,
			 password => $jabpass);
print "Jabber login: $jstate[0]\n";

# change status to connected
$Con->PresenceSend(show   => "chat",
                   status => "Running $myname (it is a bot)");

# IRC event handlers
$conn->add_handler(376, \&icome);
$conn->add_handler('leaving', \&ileave);
$conn->add_handler('join', \&comes);
$conn->add_handler('part', \&leaves);
$conn->add_handler('quit', \&leaves);
$conn->add_handler('public', \&speaks);
$conn->add_handler('msg', \&priv);
$conn->add_handler('kick', \&kicked);
$conn->add_handler('nick', \&nick);
$conn->add_handler('topic', \&topic);
$conn->add_handler('caction', \&action);



print "Ready!\n";

# MAIN LOOP
my $jstate;
for (;;) {
  # IRC loop
  $irc->do_one_loop();
  # Jabber loop
  if (not defined $Con->Process(1)) {
    pi("LOST connection to Jabber server! Exiting!");
    die "LOST connection to Jabber server! Exiting!";
  }
}





# FUNCTIONS

# Very Very Dirty Solution
sub utf2lat {
  my $r = $_[0];
  $r =~ s/Ã /à/g;
  $r =~ s/Ã¢/â/g;
  $r =~ s/Ã¤/ä/g;
  $r =~ s/Ã€/À/g;
  $r =~ s/Ã‚/Â/g;
  $r =~ s/Ã„/Ä/g;
  $r =~ s/Ã©/é/g;
  $r =~ s/Ã¨/è/g;
  $r =~ s/Ã«/ë/g;
  $r =~ s/Ãª/ê/g;
  $r =~ s/Ã‰/É/g;
  $r =~ s/Ãˆ/È/g;
  $r =~ s/ÃŠ/Ê/g;
  $r =~ s/Ã‹/Ë/g;          # please don't commit suicide
  $r =~ s/Ã®/î/g;
  $r =~ s/Ã¯/ï/g;
  $r =~ s/ÃŽ/Î/g;
  $r =~ s/Ã/Ï/g;
  $r =~ s/Ã´/ô/g;
  $r =~ s/Ã¶/ö/g;
  $r =~ s/Ã”/Ô/g;
  $r =~ s/Ã–/Ö/g;
  $r =~ s/Ã¼/ü/g;
  $r =~ s/Ã»/û/g;
  $r =~ s/Ã¹/ù/g;
  $r =~ s/Ãœ/Ü/g;
  $r =~ s/Ã›/Û/g;
  $r =~ s/Ã™/Ù/g;
  $r =~ s/Ã¿/ÿ/g;
  $r =~ s/Ã§/ç/g;
  $r =~ s/Ã‡/Ç/g;
  $r =~ s/â‚¬/E/g;
  return $r;
}

# Jabber things

# add a jabber user
sub aj {
  my $u;
  my ($jid, $nick) = @_;
  $ju{$jid} = $nick;
  tj($jid, "YOU HAVE JOINED");
  say("$nick ($jid) has joined");
}

# delete a jabber user
sub dj {
  my $jid;
  my $iwillsay;
  ($jid) = @_;
  $iwillsay = "$ju{$jid} ($jid) has left";
  tj($jid, "YOU HAVE LEFT");
  delete $ju{$jid};
  say($iwillsay);
}

sub jmess {
  my $mess = $_[1];
  my $from = $mess->GetFrom();
  my $body = $mess->GetBody();
  if (not isinju($from)) {
    if ($body eq "JOIN") {
      aj($from, ($mess->GetFrom("jid"))->GetUserID("base"));
    }
  } else {
    # user is in JU
    # commands
    if ($body eq "PART") {
      dj($from);
    } elsif ($body eq "LIST") {
      tj($from, makelist());
      tj($from, ilist());
    } elsif ($body =~ "HELP") {
      tj($from, "Commands: HELP, LIST, PART, VERSION");
    } elsif ($body =~ "VERSION") {
      tj($from, $version);
    } else {
      # print his message to IRC
      pi("$colorfrom$ju{$from}>$colormsg $body");
      # print his message to other Jabber clients
      my $i;
      foreach $i (sort keys %ju) {
	if ($i ne $from) {
	  $Con->MessageSend(to      => $i,
			    type    => "chat",
			    body    => "$ju{$from}> $body");
	}
      }
    }
    # end of case user is in JU
  }
}

sub jpres {
  my $pres = $_[1];
  my $fromstr = $pres->GetFrom();
  isinju($fromstr) or return;
  my $type = $pres->GetType();
  my $nick = ($pres->GetFrom("jid"))->GetUserID("base");
  my $status = $pres->GetStatus();
  if ($type eq "unavailable") {
    dj($fromstr);
    say("$nick is now unavailable ($status)");
  } else {
    my $show = $pres->GetShow() || "online";
    say("$nick has changed status to \U$show\E ($status)");
  }
}


# IRC things

# Print on IRC
sub pi {
  my $i;
  my @lines;
  @lines = split(/\n/, $_[0]);
  foreach $i (@lines) {
    $conn->privmsg($conn->{channel}, "$i");
  }
}

# Tell someone on IRC
sub ti {
  my $i;
  my @lines;
  @lines = split(/\n/, $_[1]);
  foreach $i (@lines) {
    $conn->privmsg($_[0], $i);
  }
}


# Print on Jabber (to our Jabber clients)
sub pj {
  my $i;
  foreach $i (sort keys %ju) {
    $Con->MessageSend(to      => $i,
                      type    => "chat",
		      body    => utf2lat($_[0]));
  }
}

# Tell someone on Jabber
sub tj {
  $Con->MessageSend(to    => $_[0],
                    type  => "chat",
		    body  => utf2lat($_[1]));
}

# I say something (sent to Jabber and IRC)
sub say {
  pi("$colorsay$_[0]");
  pj("$myname> $_[0]");
}


# non-specific functions
sub whatiam {
  return "I am a bot written in Perl by Almacha and dedicated to the public domain.";
}

sub isinju {
  return exists $ju{$_[0]};
}



# IRC event handling

# I come
sub icome {
  $conn->join($conn->{channel});
  $conn->{connected} = 1;
  say("Hi!");
  say(whatiam());
}

sub icomeback {
  $conn->join($conn->{channel});
}

sub ileave {
  say("Bye!");
}

# someone comes
sub comes {
  my $event = $_[1];
  my $nick = $event->{nick};
  pj("$nick has joined.");
  if ($nick ne $myname and scalar(hmju()) != 0) {
    say("Hi $nick! There are " . hmju() . " Jabber users here.\n");
  }
}

sub leaves {
  my $event = $_[1];
  my $nick = $event->{nick};
  pj("$nick has left.");
}

sub iamkicked {
  icomeback();
}

sub kicked {
  my $event = $_[1];
  my $nick = $event->{nick};
  my $victim = $event->{args}[1];
  pj("$victim was kicked by $nick.");
  if ($nick ne $myname) {
    iamkicked();
  }
}

# returns the list of Jabber users
sub makelist {
  my @users = sort keys %ju;
  my $list;
  my $i;
  foreach $i (@users) {
    $list .= "$ju{$i} ($i)\n";
  }
  return "There are " . @users . " Jabber users here.\n${list}End";
}

# returns the list of IRC users
sub ilist {
#  my %list;
#  my $list;
#  my $i;
#  $list = "IRC users:";
#  %list = $conn->names($conn->{channel});
#  foreach $i (sort keys %list) {
#    $list .= " $i";
#  }
#  return $list;
  return "Not Yet Implemented";
}

# How Many Jabber Users?
sub hmju {
  my @users = sort keys %ju;
  return @users;
}

sub priv {
  my $event = $_[1];
  my $text = $event->{args}[0];
  my $nick = $event->{nick};
  my @who;

  if ($text =~ /^help/i) {
    ti($nick, "Commands: HELP, ABOUT, LIST, KICK, VERSION");
  } elsif ($text =~ /^copy/i or $text =~ /^license/i or $text =~ /^about/i) {
    ti($nick, whatiam());
  } elsif ($text =~ /^list/i) {
    ti($nick, makelist());
  } elsif ($text =~ /^version/i) {
    ti($nick, $version);
  } elsif ($text =~ /^version/i) {
    ti($nick, $version);
  } elsif ($text =~ /^kick/i) {
    @who = split(/ /, $text);
    if (not isinju($who[1])) {
      ti($nick, "User not found: $who[1]");
    } else {
      say("$ju{$who[1]} ($who[1]) was kicked by $nick!");
      tj($who[1], "YOU WERE KICKED BY $nick!");
      dj($who[1]);
    }
  }

}

sub speaks {
  my $event = $_[1];
  my $text = $event->{args}[0];
  my $nick = $event->{nick};

  pj("$nick> $text");

  # help
  if ($text =~ /^$myname help/i) {
    say("Commands: Use them on private chat (tell me 'help').");
  }
}

sub nick {
  my $event = $_[1];
  my $old = $event->{nick};
  my $new = $event->{args}[0];
  pj("$old has changed his nick to $new.");
}

sub topic {
  my $event = $_[1];
  my $who = $event->{nick};
  my $topic = $event->{args}[0];
  pj("$who has changed the topic to \"$topic\"");
}

# for CTCP ACTION, when someone does "/me does something"
sub action {
  my $event = $_[1];
  my $who = $event->{nick};
  my $action = $event->{args}[0];
  pj("* $who $action");
}


