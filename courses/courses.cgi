#!/usr/bin/perl

# I, Raphael Champeimont, the author of this program,
# hereby release it into the public domain.
# This applies worldwide.
# 
# In case this is not legally possible:
# I grant anyone the right to use this work for any purpose,
# without any conditions, unless such conditions are required by law.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;
use CGI;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

# DATA
# Convention: special things start with an uppercase letter,
# standard articles start with a lowercase letter
# This is to get an "intelligent" ASCII sort
my @articles = (
  {
    name => "avocats",
    place => "L",
  },
  {
    name => "pancetta",
    place => "C",
    resp => 0,
  },
  {
    name => "anchoix",
    place => "V",
  },
  {
    name => "papier imprimante",
    place => "U",
  },
  {
    name => "osso bucco",
    place => "V",
  },
  {
    name => "pois gourmands",
    place => "L",
    aliases => ["mangetout","pois mangetout"],
  },
  {
    name => "surgelés",
    place => "S",
  },
  {
    name => "coquilles St-Jacques",
    place => "P",
  },
  {
    name => "tomates entières pelées",
    place => "E",
  },
  {
    name => "merguez",
    place => "V",
    resp => 1,
  },
  {
    name => "pommes de terre rissolées",
    place => "S",
  },
  {
    name => "champignons",
    place => "L",
  },
  {
    name => "sirop de canne",
    place => "O",
  },
  {
    name => "lait d'amandes",
    place => "B",
  },
  {
    name => "aligot",
    place => "C",
    resp => 0,
  },
  {
    name => "celeri branche",
    place => "L",
  },
  {
    name => "bougies",
    place => "U",
    resp => 1,
  },
  {
    name => "raisins secs",
    place => "L",
    resp => 0,
  },
  {
    name => "concombre",
    place => "L",
  },
  {
    name => "thon en boite",
    place => "E",
  },
  {
    name => "farine",
    place => "E",
  },
  {
    name => "noix",
    place => "L",
  },
  {
    name => "clou de girofle",
    place => "L",
  },
  {
    name => "sauge",
    place => "L",
  },
  {
    name => "raviolles",
    place => "F",
  },
  {
    name => "sirop",
    place => "O",
  },
  {
    name => "lentilles",
    place => "E",
  },
  {
    name => "éponge",
    place => "N",
  },
  {
    name => "vin",
    place => "O",
  },
  {
    name => "biscottes",
    place => "D",
  },
  {
    name => "produit d'entretien",
    place => "N",
  },
  {
    name => "produit d'entretien WC",
    place => "N",
  },
  {
    name => "carpaccio",
    place => "P",
  },
  {
    name => "aubergines",
    place => "L",
  },
  {
    name => "haricots",
    place => "L",
  },
  {
    name => "lessive liquide",
    place => "N",
  },
  {
    name => "lessive",
    place => "N",
  },
  {
    name => "lapin",
    place => "V",
  },
  {
    name => "vinaigre",
    place => "E",
  },
  {
    name => "légumes",
    place => "L",
  },
  {
    name => "fruits",
    place => "L",
  },
  {
    name => "mayonnaise",
    place => "E",
  },
  {
    name => "couscous",
    place => "E",
  },
  {
    name => "amandes",
    place => "L",
  },
  {
    name => "pistaches",
    place => "L",
    resp => 0,
  },
  {
    name => "porc",
    place => "V",
    aliases => [ "cochon" ],
  },
  {
    name => "sucre",
    place => "E",
    aliases => [ "sucre de canne beige" ],
  },
  {
    name => "petits pois surgelés",
    place => "S",
  },
  {
    name => "piles",
    place => "U",
  },
  {
    name => "celeri rave",
    place => "L",
  },
  {
    name => "citron",
    place => "L",
  },
  {
    name => "crèpes",
    place => "E",
  },
  {
    name => "coton démaquillant",
    place => "U",
  },
  {
    name => "viande séchée",
    place => "C",
  },
  {
    name => "sacs poubelle",
    place => "N",
  },
  {
    name => "confiture",
    place => "D",
    resp => 1,
  },
  {
    name => "pate a pizza",
    place => "R",
  },
  {
    name => "sel pour lave-vaisselle",
    place => "N",
  },
  {
    name => "pates",
    place => "E",
  },
  {
    name => "riz",
    place => "E",
  },
  {
    name => "miel",
    place => "E",
  },
  {
    name => "salade",
    place => "L",
  },
  {
    name => "oranges",
    place => "L",
  },
  {
    name => "patates",
    place => "L",
    aliases => [ "pommes de terre"],
  },
  {
    name => "viande hachée",
    place => "V",
  },
  {
    name => "chips",
    place => "D",
  },
  {
    name => "creme",
    place => "F",
  },
  {
    name => "sel",
    place => "E",
    aliases => [ "gros sel" ],
  },
  {
    name => "levure",
    place => "E",
  },
  {
    name => "carottes",
    place => "L",
  },
  {
    name => "fromage rapé",
    place => "F",
    aliases => [ "rapé" ],
  },
  {
    name => "coton-tiges",
    place => "U",
  },
  {
    name => "eau de javel",
    place => "N",
    aliases => [ "javel" ],
  },
  {
    name => "poisson",
    place => "P",
    aliases => [ "thon frais" ],
  },
  {
    name => "nutella",
    place => "D",
  },
  {
    name => "fjords",
    place => "F",
  },
  {
    name => "savon lave-vaisselle",
    place => "N",
  },
  {
    name => "savon pour laver la vaisselle à la main",
    place => "N",
  },
  {
    name => "savon",
    place => "U",
  },
  {
    name => "feutres",
    place => "U",
  },
  {
    name => "adhésif",
    place => "U",
    aliases => [ "scotch (adhésif)", "ruban adhésif" ],
  },
  {
    name => "pain",
    place => "R",
  },
  {
    name => "brioche",
    place => "R",
  },
  {
    name => "müsli",
    place => "D",
  },
  {
    name => "serviettes en papier",
    place => "U",
  },
  {
    name => "pâte à pizza",
    place => "R",
  },
  {
    name => "cahier",
    place => "U",
  },
  {
    name => "feuilles",
    place => "U",
  },
  {
    name => "bloc",
    place => "U",
  },
  {
    name => "oeufs",
    place => "F",
  },
  {
    name => "crackers",
    place => "D",
  },
  {
    name => "bechamel",
    place => "S",
  },
  {
    name => "lasagnes",
    place => "E",
  },
  {
    name => "lasagnes fraiches",
    place => "E",
  },
  {
    name => "sauce bolognaise",
    place => "E",
    aliases => [ "bolognaise" ],
  },
  {
    name => "sauce tomate",
    place => "E",
  },
  {
    name => "pâtes",
    place => "E",
  },
  {
    name => "pâtes fraiches",
    place => "F",
  },
  {
    name => "cornichons",
    place => "E",
    aliases => [ "cornichons normaux", "cornichons doux" ],
  },
  {
    name => "moutarde",
    place => "E",
    aliases => [ "moutarde à l'ancienne" ],
  },
  {
    name => "gingembre",
    place => "L",
  },
  {
    name => "sirop d'érable",
    place => "D",
  },
  {
    name => "lait",
    place => "F",
  },
  {
    name => "poulet",
    place => "V",
    resp => 0,
  },
  {
    name => "jus de fruits",
    place => "F",
  },
  {
    name => "yaourts nature",
    place => "F",
  },
  {
    name => "yaourts aux fruits",
    place => "F",
  },
  {
    name => "fromage",
    place => "C",
  },
  {
    name => "jambon",
    place => "C",
  },
  {
    name => "boeuf pour pot au feu",
    place => "V",
    aliases => [ "pot au feu (viande)", "veau" ],
  },
  {
    name => "boeuf",
    place => "V",
  },
  {
    name => "beef steaks",
    place => "V",
  },
  {
    name => "agneau",
    place => "V",
  },
  {
    name => "saumon",
    place => "P",
  },
  {
    name => "brandade de morue",
    place => "P",
  },
  {
    name => "croutons a l'ail",
    place => "P",
  },
  {
    name => "soupe",
    place => "E",
  },
  {
    name => "crevettes",
    place => "P",
  },
  {
    name => "canard",
    place => "V",
  },
  {
    name => "chocolat",
    place => "D",
  },
  {
    name => "sopalin",
    place => "N",
  },
  {
    name => "papier toilette",
    place => "N",
    aliases => [ "pq" ],
  },
  {
    name => "huile",
    place => "E",
  },
  {
    name => "huile d'olive",
    place => "E",
  },
  {
    name => "nettoyant canalisations",
    place => "N",
  },
  {
    name => "beurre salé",
    place => "F",
  },
  {
    name => "beurre doux",
    place => "F",
  },
  {
    name => "allumettes",
    place => "N",
  },
  {
    name => "bananes",
    place => "L",
  },
  {
    name => "poivrons",
    place => "L",
  },
  {
    name => "fenouil",
    place => "L",
  },
  {
    name => "frites",
    place => "S",
  },
  {
    name => "pommes noisettes",
    place => "S",
  },
  {
    name => "MAGASIN BIO",
    place => "B",
  },
  {
    name => "pignons",
    place => "L",
  },
  {
    name => "safran",
    place => "E",
  },
  {
    name => "tomates",
    place => "L",
  },
  {
    name => "épinards surgelés",
    place => "S",
  },
  {
    name => "chocolat Van Houten",
    place => "D",
  },
  {
    name => "herbes",
    place => "L",
  },
  {
    name => "oignons",
    place => "L",
  },
  {
    name => "ail",
    place => "L",
  },
  {
    name => "mouchoirs",
    place => "U",
  },
);




# Only name, count and text are supported here.
my @initlist = (
  {
    name => "jus de fruits",
    count => 4,
  },
  {
    name => "fjords",
    count => 4,
  },
  {
    name => "yaourts aux fruits",
    count => 8,
  },
  {
    name => "chocolat",
    count => 4,
  },
  {
    name => "beurre doux",
    count => 1,
  },
);

# resp are @resp offsets
my %places = (
  N => {
    resp => 0,
  },
  E => {
    resp => 0,
  },
  S => {
    resp => 0,
  },
  F => {
    resp => 0,
  },
  O => {
    resp => 0,
  },
  D => {
    resp => 0,
  },
  C => {
    resp => 1,
  },
  L => {
    resp => 1,
  },
  P => {
    resp => 1,
  },
  U => {
    resp => 0,
  },
  V => {
    resp => 1,
  },
  R => {
    resp => 1,
  },
  B => {
    resp => 1,
  },
);

my @resp = (
  {
    name => "R",
  },
  {
    name => "E",
  },
);



# CONFIG
my $listlen = 50;




# CODE
my $thisfile = $ENV{'SCRIPT_NAME'};

sub docbegin {
  print <<EOF;
Content-type: application/xhtml+xml; charset=UTF-8

<?xml version="1.0" encoding="UTF-8"?>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr">
<head>
<title>Programme de courses</title>
<style type="text/css">
body {
  font-size: small;
}
table {
  border: solid 1px black;
  border-collapse: collapse;
}
table.in {
  width: 100%;
}
table.out {
  page-break-inside: avoid;
}
td {
  border: solid 1px black; 
  vertical-align: top;
  font-size: 100%;
  font-family: sans-serif;
}
th {
  border: solid 1px black;
}
ul {
  list-style: square outside none;
}
</style>
</head>
<body>
EOF
  # We can now send warnings as HTML comments
  warningsToBrowser(1);
}

sub docend {
  print <<EOF;
</body>
</html>
EOF
}

sub form {
  print <<EOF;
<form action="$thisfile" method="post" accept-charset="UTF-8">
EOF
}

sub endform {
  print <<EOF;
</form>
EOF
}

sub submitbutton {
  print <<EOF;
<p><button type="submit">Calculer</button></p>
EOF
}

sub h1 {
  print <<EOF;
<h1>@_</h1>
EOF
}

sub item {
  my ($n) = @_;
  my $article;
  die "In item: n < 0" if $n < 0;
  if ($n < @initlist) {
    $article = $initlist[$n];
  }
  print <<EOF;
<tr><td>
<select name="item$n">
EOF
  print qq{<option value="n">_</option>\n};
  print qq{<option value="o">AUTRE</option>\n};
  for (my $i=0; $i<@articles; $i++) {
    if (defined $article and $article->{'name'} eq $articles[$i]{'name'}) {
      print qq{<option selected="selected" value="$i">$articles[$i]{'name'}</option>\n};
    } else {
      print qq{<option value="$i">$articles[$i]{'name'}</option>\n};
    }
  }
  print <<EOF;
</select>
</td>
<td>
EOF
  if (defined $article and defined $article->{'count'}) {
    print qq{<input name="count$n" value="$article->{'count'}" />\n};
  } else {
    print qq{<input name="count$n" />\n};
  }
  print <<EOF;
</td>
<td>
EOF
  if (defined $article and defined $article->{'text'}) {
    print qq{<input name="text$n" value="$article->{'text'}" />\n};
  } else {
    print qq{<input name="text$n" />\n};
  }
  print <<EOF;
</td>
<td>
<select name="place$n">
EOF
  print qq{<option selected="selected" value="autoplace">Auto</option>\n};
  foreach my $place (sort keys %places) {
    print qq{<option value="$place">$place</option>\n};
  }
  print <<EOF;
</select>
</td>
<td>
<select name="resp$n">
EOF
  print qq{<option selected="selected" value="a">Auto</option>\n};
  for (my $i=0; $i<@resp; $i++) {
    print qq{<option value="$i">$resp[$i]{'name'}</option>\n};
  }
  print <<EOF;
</select>
</td>
</tr>
EOF
}

sub itemlist {
  print <<EOF;
<table class="in">
<tr><th>Article</th><th>Nombre</th><th>Nom si "Autre" ou remarques</th>
<th>Où ?</th><th>Qui ?</th></tr>
EOF
  for (my $i=0; $i<$listlen; $i++) {
    item $i;
  }
  print <<EOF;
</table>
EOF
}



sub warnings {
  print "<pre>";
  CGI::Carp::warningsToBrowser(1);
  print "</pre>\n";
}



# Main
docbegin;

# Expand aliases
foreach my $article (@articles) {
  my $aliases = $article->{'aliases'};
  if (defined $aliases and @$aliases > 0) {
    foreach my $alias (@$aliases) {
      my $newarticle = {
	name => $alias,
      };
      foreach my $key (keys %$article) {
	# don't put aliases again in the alias
	next if ($key eq "aliases");
	# alias name is different (that is the purpose of aliases)
	next if ($key eq "name");
	$newarticle->{$key} = $article->{$key};
      }
      $articles[@articles] = $newarticle;
    }
  }
}

# Do some checking on data
# Check article places are known
for (my $i=0; $i<@articles; $i++) {
  if (not defined $places{$articles[$i]{'place'}}) {
    die qq{article $i with name "$articles[$i]{'name'}" has incorrect place: "$articles[$i]{'place'}"};
  }
}
# Check place responsibles are known
{
  my @placesarray = keys %places;
  foreach my $i (@placesarray) {
    if (not defined $resp[$places{$i}{'resp'}]) {
      die qq{place $i has incorrect resp: "$places{$i}{'resp'}"};
    }
  }
}

# Sort articles
{
  my $order = sub {
    return $a->{'name'} cmp $b->{'name'};
  };
  @articles = sort $order @articles;
}

if (not CGI::param()) {
  h1 "Liste";
  form;
  itemlist;
  submitbutton;
  endform;
} else {
  my @reallist;
  # Articles By Place
  my %abyp;
  # Total article count
  my $total = 0;

  # Put user data in @reallist
  for (my $i=0; $i<$listlen; $i++) {
    my $id;
    my $name;
    my $text;
    my $count;
    my $resp;
    my $place;
    $id = CGI::param("item$i");
    if ($id eq "n") {
      # Nothing
    } elsif ($id eq "o" or (int $id) >= 0) {
      $count = CGI::param("count$i");
      $text = CGI::param("text$i");
      $resp = CGI::param("resp$i");
      $place = CGI::param("place$i");
      if ($place eq "autoplace") {
	if ($id eq "o") {
	  $place = "U";
	} else {
	  $place = $articles[$id]{'place'};
	}
      }
      if (not defined $places{$place}) {
	die "place is strange: $place";
      }
      if ($id ne "o") {
	if (not defined ($name = $articles[$id]{'name'})) {
	  die "id $id has no name field in articles array";
	}
	# If resp was specified, use it
	if ($resp eq "a") {
	  # If article has resp, use it
	  if (not defined ($resp = $articles[$id]{'resp'})) {
	    # else use place resp
	    if (not defined ($resp =
		$places{$place}{'resp'})) {
	      # and if place has no resp, put 0
	      $resp = 0;
	    }
	  }
	}
      } else {
	$name = $text;
	$text = undef;
	# If resp was specified, use it
	if ($resp eq "a") {
	  # else use place resp
	  if (not defined ($resp = $places{$place}{'resp'})) {
	    # and if place has no resp, put 0
	    $resp = 0;
	  }
	}

      }
      $reallist[@reallist] = {
	id => $id,
	name => $name,
	count => $count,
	text => $text,
	resp => $resp,
	place => $place,
      };
      $total++;
    } else {
      die "id has strange value: $id";
    }
  }


  # Send articles from @reallist to %abyp
  { 
    my $place;
    foreach my $article (@reallist) {
      $place = $article->{'place'};
      $abyp{$place}[@{$abyp{$place}}] = $article;
    }
  }

  # This function prints list of a responsible
  my $printlistofresp = sub {
    my ($resp) = @_;
    $resp = int $resp;
    my $listofplace = sub {
      my $tmp;
      my $s = <<EOF;
<ul>
EOF
      my $listofthisplace;
      my ($place) = @_;
      $listofthisplace = $abyp{$place};
      die if not defined $listofthisplace;
      foreach my $article (@$listofthisplace) {
	$tmp = $article->{'resp'};
	die qq{undefined resp id} if not defined $tmp;
	$tmp = int $tmp;
	die qq{invalid resp id: "$tmp"} if not defined $resp[$tmp];
	die qq{invalid (>\@resp) resp id: "$tmp"} if $tmp > @resp;
	die qq{invalid (<0) resp id: "$tmp"} if $tmp <0;
	next if $tmp != $resp;
	$s .= qq{<li>};
	if (defined ($tmp = $article->{'count'}) and $tmp ne "") {
	  $s .= "$tmp ";
	}
	$s .= $article->{'name'};
	if (defined ($tmp = $article->{'text'}) and $tmp ne "") {
	  $s .= " ($tmp)";
	}
	$s .= "</li>\n";
	$total--;
      }
      $s .= <<EOF;
</ul>
EOF
      return $s;
    };

    # Place Strings
    my %ps;
    foreach my $place (keys %abyp) {
      $ps{$place} = &$listofplace($place);
    }

    print <<EOF;
<table class="out">
<caption>
$resp[$resp]{'name'}
</caption>
<tr>
<td>
[N] Produits d'entretien
$ps{'N'}
</td>
<td colspan="2">
[O] Boissons
$ps{'O'}
</td>
</tr>
<tr>
<td>
[E] Épicerie
$ps{'E'}
</td>
<td>
[D] Petit-déjeuner et autres
$ps{'D'}
</td>
<td rowspan="3">
[V] Viande
$ps{'V'}
</td>
</tr>
<tr>
<td rowspan="2">
[S] Surgelés
$ps{'S'}
</td>
<td>
[C] Formagerie / Charcuterie
$ps{'C'}
</td>
</tr>
<tr>
<td>
[L] Légumes
$ps{'L'}
</td>
</tr>
<tr>
<td>
[F] Frais
$ps{'F'}
</td>
<td>
[P] Poisson
$ps{'P'}
</td>
<td>
[R] Boulangerie
$ps{'R'}
</td>
</tr>
<tr>
<td>
[U] Emplacement inconnu ou plus bas
$ps{'U'}
</td>
<td colspan="2">
[B] Bio
$ps{'B'}
</td>
</tr>
</table>
EOF
    print "<pre>";

    print "</pre>\n";
  };

  # Call the above function
  for (my $i=0; $i<@resp; $i++) {
    &$printlistofresp($i);
  }

  if ($total != 0) {
    die "total should be back to 0 but it is: $total";
  }

}

docend;

