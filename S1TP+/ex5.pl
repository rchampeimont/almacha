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

print "Menu returned ", menu(), ".\n";

sub menu {
    my $a;
    my $b;
    for (;;) {
	do {
	    print "-0- Sortir\n-1- Action1\n-2- Action2\n";
	    $a = <STDIN>;
	} while ($a < 0 || $a > 2);
	
	if ($a == 0) {
	    return 0;
	} elsif ($a == 1) {
	    do {
		print "Entrez un nombre entre 0 et 100\n";
		$b = <STDIN>;
	    } while ($b < 0 || $b > 100);
	    Action1($b);
	} elsif ($a == 2) {
	    Action2();
	}
    }
}

sub Action1 {
    my $a = $_[0];
    printf "\n%dx2=%d\n\n", $a, $a * 2;
}

sub Action2 {
    print "Je suis la fonction Action2 !\n";
}
