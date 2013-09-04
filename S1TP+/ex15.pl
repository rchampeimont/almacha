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

use strict;

my @Histo = (0, 0, 0, 0, 0,
	     0, 0, 0, 0, 0,
	     0, 0, 0, 0, 0,
	     0, 0, 0, 0, 0, 0);
my $note_entree;
my $i;
my $minimum = -1;
my $maximum = -1;
my $MaNote;
my $NNI = 0;

do {
    print "Entrez une note ou -1 pour terminer : ";
    $note_entree = <STDIN>;
    if ($note_entree != -1) {
	if ($note_entree >= 0 && $note_entree <= 20) {
	    $Histo[$note_entree]++;
	} else {
	    print "Note incorrecte !\n";
	}
    }
} while ($note_entree != -1);

for ($i=0; $i<=20; $i++) {
    if ($Histo[$i] != 0) {
	$minimum = $i;
	last;
    }
}

if ($minimum == -1){
    printf("Erreur : Aucune valeur entree !\n");
    exit(1);
}

print "Le minium est ", $minimum, ".\n";

for ($i=20; $i>=0; $i--) {
    if ($Histo[$i] != 0) {
	$maximum = $i;
	last;
    }
}

print "Le maximum est ", $maximum, ".\n";

print "Sasissez votre note : ";
$MaNote = <STDIN>;

unless ($MaNote >= 0 && $MaNote <= 20) {
    printf("Votre note est incorrecte !\n");
    exit(1);
}

if ($Histo[$MaNote] == 0) {
    print "Votre note n'est pas dans la liste !\n";
    exit(1);
}

for ($i=0; $i<=$MaNote; $i++) {
    $NNI = $NNI + $Histo[$i];
}
$NNI = $NNI - 1;

print "Il y a ", $NNI, " personnes qui ont eu une note inferieur ou egale a la votre.\n";

