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

my $n;
my $i;
my $j;

print "Entrez la valeur de n : ";
$n = int(<STDIN>);

for ($i=0; $i<$n; $i++) {
    for ($j=0; $j<$n; $j++) {
	print $i == 0 || $i == $n-1 || $j == $n-1-$i ? "*" : "-";
    }
    print "\n";
}

