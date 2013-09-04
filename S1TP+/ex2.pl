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

my @t = (55, 4, 8, 13, 43, 89, 44);

sub echange {
    my $k;
    $k = $t[$_[0]];
    $t[$_[0]] = $t[$_[1]];
    $t[$_[1]] = $k;
}

sub triselection {
    return $_[0] > $_[1];
}

my $min;
my $i;
my $j;

$min = 0;
for ($i=0; $i<@t; $i++) {
    $min = $i;
    for ($j=$i+1; $j<@t; $j++) {
	if (triselection($t[$j], $t[$min])) {
	    $min = $j;
	}
    }
    echange($i, $min);
}

for ($i=0; $i<@t; $i++) {
    print "t[", $i, "]=", $t[$i], "\n";
}

