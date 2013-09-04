#!/usr/bin/perl -w

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

my @quote = (
  "Le maximum de profit n\'est limité que par le minimum physiologique du salaire et le maximum physiologique de la journée de travail.  Karl Marx", 
  "La religion n\'est que le Soleil illusoire qui tourne autour de l\'homme aussi longtemps que l\'homme ne se prend pas lui-même pour centre de son propre mouvement.  Karl Marx",
  "Au vu de la science la philosophie ne peut être que matérialiste et athée.  Jacques Monod", 
  "Le libéralisme c'est le renard libre dans le poulailler libre.  Jean Jaurès.",
  "Dans une société fondée sur le pouvoir de l'argent, tandis que quelques poignées de riches ne savent être que des parasites, il ne peut y avoir de \"liberté\", réelle et véritable.  Lénine",
  "Prolétaires de tous les pays, unissez-vous !  Karl Marx",
  "Les prolétaires n'ont pas de patrie.  Karl Marx",
  "Le problème se pose uniquement ainsi : idéologie bourgeoise ou idéologie socialiste. Il n\'y a pas de milieu.  Lénine",
  "Soyez réalistes : demandez l\'impossible.  Che Guevara",
  "Nos vies valent plus que leurs profits !  LCR",
  "La science moderne [...] nous considère comme un accident qui aurait pu ne pas se produire.  Jacques Monod",
  "[Le capitalisme] a accumulé des masses de richesses, et il a fait des hommes les esclaves de cette richesse.  Lénine",
  "Vive la révolution communiste ☭ !",
  "Encore un des ces trucs inutiles...",
  "Vive OpenBSD !",
  "Windows, c'est un OS ça ?",
  "Voila un des grands mystères de l'humanité...",
  "Évidemment, je sais tout.",
  ":-\)",
  "Salut à toi camarade !",
  "^^",
  "Unix pawaa!",
  "OpenBSD : Free, Functional, Secure",
  "Emacs Makes All Computers Slow",
  "Perl rocks!",
  "Emacs or VI, that's the question.",
  "Tu m'insultes là ?",
  "Je revendique le droit à ma liberté d'expression !",
  "MOZILLA !",
  "Ce qui est affirmé sans preuve peut être nié sans preuve.  Euclide",
  "/part et /quit sont sur un bateau, /part tombe à l'eau. Qui reste ?",
);

my $irc = new Net::IRC;

# nick of last person that did something
my $nick;

my $server = "leopard";
my $chan = '##b';
my $myname = 'AlmaRat';

my $lastlastquote = -1;
my $lastquote = -1;

my $conn = $irc->newconn(
  Server => $server,
  Nick   => $myname,
  Port   => 57914
);

$conn->{channel} = $chan;

delete $ENV{"LC_ALL"};
delete $ENV{"LANG"};
delete $ENV{"DISPLAY"};

my %commands;
#$commands{"uptime"} = "uptime";
#$commands{"uname"} = "uname -a";
#$commands{"tetris"} = "tetris-bsd -s";
#$commands{"date"} = "date";

my $version = '$Rev: 84 $';

my $quiet = 0;

$conn->add_handler(376, \&icome);
$conn->add_handler('join', \&comes);
$conn->add_handler('part', \&leaves);
$conn->add_handler('quit', \&leaves);
$conn->add_handler('public', \&speaks);
$conn->add_handler('msg', \&priv);
$conn->add_handler('cversion', \&ver);
$conn->add_handler('kick', \&kicked);

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

sub ex {
  my $out;
  if (open(FH, "@_ 2>&1 |")) {
    while (defined ($out = <FH>)) {
      chomp($out);
      $conn->privmsg($conn->{channel}, "$out");
    }
    close(FH);
  } else {
    $conn->privmsg($conn->{channel}, "Error executing command.");
  }
}

sub dp {
  if ($_[0] != $lastquote && $_[0] != $lastlastquote) {
    $conn->privmsg($conn->{channel}, "$quote[$_[0]]");
    $lastlastquote = $lastquote;
    $lastquote = $_[0];
  }
}

sub ikick {
  $conn->kick($conn->{channel}, $_[0], "J'obéis !");
}

sub icome {
  $conn->join($conn->{channel});
  $conn->privmsg($conn->{channel}, 'Salut camarades !');
  $conn->{connected} = 1;
}

sub icomeback {
  $conn->join($conn->{channel});
}

sub hop {
  if ($_[0] ne $myname) {
    $conn->mode($conn->{channel}, "-o", $_[0]);
  }
}


sub comes {
  my $event = $_[1];
  my $nick = $event->{nick};
  if ($_[0] ne $myname) {
    $conn->mode($conn->{channel}, "-o", $_[0]);
  }
  if (!$quiet) {
    if ($nick ne $myname) {
      $conn->privmsg($conn->{channel}, "Salut camarade $nick !");
    }
  }
  hop($nick);
}

sub leaves {
  if ($quiet) {
    return;
  }
  my $event = $_[1];
  my $nick = $event->{nick};
#  $conn->privmsg($conn->{channel}, "A plus tard camarade $nick !");
}

sub iamkicked {
  icomeback();
}

sub kicked {
  my $event = $_[1];
  my $nick = $event->{nick};
  if ($nick ne $myname) {
    iamkicked();
  }
}

sub priv {
  my $event = $_[1];
  my $nick = $event->{nick};
  $conn->privmsg($nick, "Je ne reponds qu'en public.");
}

sub ver {
  my $event = $_[1];
  my $nick = $event->{nick};
  $conn->ctcp_reply($nick, "VERSION AlmaCat $version");
}

sub speaks {
  my $cmd;
  my @cwa;
  my $event = $_[1];
  my $text = $event->{args}[0];
  my $nick = $event->{nick};
  my @cmdlist;

  if ($nick ne $myname) {
    $conn->mode($conn->{channel}, "-o", $nick);
  }

  # help
  if ($text =~ m/^$myname help/i) {
    @cmdlist = keys(%commands);
    mm("Je suis un bot mis dans le domaine public.\nCommandes internes : quiet talk kick hop\nCommandes externes : ($myname exec commande) :\n@cmdlist");
    return;
  }

  # quiet
  if ($text =~ m/^$myname quiet/i) {
    $quiet = 1;
    say("Je me tais.\n");
    return;
  }

  # talk
  if ($text =~ m/^$myname talk/i) {
    $quiet = 0;
    say("Je vais �tre � nouveau bavard !\n");
    return;
  }

  # exec
  if ($text =~ m/^$myname exec /i) {
    @cwa = split(/ /, $text);
    $cmd = $cwa[2];
    if (defined($commands{$cmd})) {
      ex($commands{$cmd});
    } else {
      mm("command not found");
    }
    return;
  }

  # kick
  if ($text =~ m/^$myname kick \b/i) {
    my @victim = split(/kick /, $text);
    if ($victim[1] =~ m/^$myname\b/i) {
      $conn->privmsg($conn->{channel}, "Faut pas me prendre pour un pigeon !");
    } else {
      ikick($victim[1]);
    }
    return;
  }

  # hop
  if ($text =~ m/^$myname hop \b/i) {
    my @victim = split(/hop /, $text);
    if ($victim[1] =~ m/^$myname\b/i) {
      $conn->privmsg($conn->{channel}, "Non.");
    } else {
      hop($victim[1]);
    }
    return;
  }


  if ($quiet) {
    return;
  }
  if ($text =~ m/profit/i) {
    dp(0);
  } elsif ($text =~ m/religion/i) {
    dp(1);
  } elsif ($text =~ m/philosophie/i || $text =~ m/matérialis/i || $text =~ m/materialis/i) {
    dp(2);
  } elsif ($text =~ m/libéralisme/i || $text =~ m/liberalisme/i) {
    dp(3);
  } elsif ($text =~ m/liberté/i || $text =~ m/liberte/i) {
    dp(4);
  } elsif ($text =~ m/prolétaire/i || $text =~ m/proletaire/i) {
    dp(5);
  } elsif ($text =~ m/patrie/i) {
    dp(6);
  } elsif ($text =~ m/ideologie/i || $text =~ m/idéologie/i) {
    dp(7);
  } elsif ($text =~ m/réaliste/i || $text =~ m/realiste/i) {
    dp(8);
  } elsif ($text =~ m/sens de la vie/i || $text =~ m/sens de ma vie/i || $text =~ m/sens de ta vie/i) {
    dp(10);
  } elsif ($text =~ m/\bvie\b/i) {
    dp(9);
  } elsif ($text =~ m/capitalisme/i) {
    dp(11);
  } elsif ($text =~ m/communis/i) {
    dp(12);
  } elsif ($text =~ m/\bberyl\b/i || $text =~ m/\bXAML\b/i) {
    dp(13);
  } elsif ($text =~ m/\bOS\b/ && !($text =~ m/\bMac\b/i)) {
    dp(14);
  } elsif ($text =~ m/Windows/) {
    dp(15);
  } elsif ($text =~ m/^mais pourquoi/i) {
    dp(16);
  } elsif ($text =~ m/tu savais que/i && $text =~ m/\?/) {
    dp(17);
#    } elsif ($text eq ":-D") {
#	dp(18);
  } elsif ($text =~ m/$myname/i && ($text =~ m/\bhello\b/i || $text =~ m/\bsalut\b/i ||$text =~ m/\bre\b/i ) ) {
    dp(19);
#    } elsif ($text =~ m/^lol\b/i) {
#	dp(20);
  } elsif ($text =~ m/unix/i) {
    dp(21);
  } elsif ($text =~ m/openbsd/i) {
    dp(22);
  } elsif ($text =~ m/emacs/i && $text =~ m/\bvi\b/i) {
    dp(25);
  } elsif ($text =~ m/emacs/i) {
    dp(23);
  } elsif ($text =~ m/perl\b/i) {
    dp(24);
  } elsif ($text =~ m/$myname/i && !($text =~ m/\bpas\b/i) && ($text =~ m/\bcrétin\b/i || $text =~ m/\bcretin\b/i || $text =~ m/\bidiot\b/i || $text =~ m/\bdébile\b/i || $text =~ m/\bdebile\b/i || $text =~ m/\bneuneu\b/i || $text =~ m/\bcon\b/i || $text =~ m/\bstupide\b/i || $text =~ m/\bstupid\b/i)) {
    dp(26);
  } elsif ($text =~ m/ta gueule $myname/i || $text =~ m/la ferme $myname/i || $text =~ m/$myname ta gueule/i || $text =~ m/$myname la ferme/i || $text =~ m/tais-toi $myname/i || $text =~ m/tais toi $myname/i || $text =~ m/$myname tais-toi/i || $text =~ m/$myname tais toi/i || $text =~ m/$myname ferme la/i || $text =~ m/$myname ferme-la/i) {
    dp(27);
  } elsif ($text =~ m/\bmozilla\b/i || $text =~ m/\bseamonkey\b/i || $text =~ m/\bfirefox\b/i) {
    dp(28);
  } elsif ($text =~ m/\bdieu existe\b/i) {
    dp(29);
  } elsif ($text =~ m/\bblague\b/i) {
    dp(30);
  }
}


