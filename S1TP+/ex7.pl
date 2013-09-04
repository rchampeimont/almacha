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

my $N = 2;
my $M = 3;
my @A = (
	 [0,0,0],
	 [0,0,0],
	 );
my @B = (
	 [0,0],
	 [0,0],
	 [0,0]
	 );
my $i;
my $j;

saisirA();

for ($i=0; $i<$N; $i++) {
    for ($j=0; $j<$M; $j++) {
	$B[$j][$i] = $A[$i][$j];
    }
}

afficherA();
afficherB();


sub saisirA {
    for ($i=0; $i<$N; $i++) {
	for ($j=0; $j<$M; $j++) {
	    print "Entrez la valeur pour A[", $i, "][", $j, "] = ";
	    $A[$i][$j] = <STDIN>;
	    chomp $A[$i][$j];
	}
    }
}

sub afficherA {
    print "Matrice A\n";
    for ($i=0; $i<$N; $i++) {
	for ($j=0; $j<$M; $j++) {
	    print $A[$i][$j], " ";
	}
	print "\n";
    }
}

sub afficherB {
    print "Matrice B\n";
    for ($i=0; $i<$M; $i++) {
	for ($j=0; $j<$N; $j++) {
	    print $B[$i][$j], " ";
	}
	print "\n";
    }
}
