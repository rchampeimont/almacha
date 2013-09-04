#!/usr/bin/perl

# I, Raphael Champeimont, the author of this work,
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

my $s;

while (<>) {
    $s .= $_;
}

$s =~ s!\$\$(.+?)\$\$!<math>$1</math>!gs;
$s =~ s!\$(.+?)\$!<math>$1</math>!gs;
$s =~ s!{\\em (.*?)}!''$1''!gs;
$s =~ s!\\english{(.*?)}! {{English|$1}}!gs;
$s =~ s!\\item !* !gs;
$s =~ s!\\section{(.+?)}!== $1 ==!gs;
$s =~ s!\\subsection{(.+?)}!=== $1 ===!gs;
$s =~ s!\\subsubsection{(.+?)}!==== $1 ====!gs;
$s =~ s!\\begin{itemize}\n!!gs;
$s =~ s!\\end{itemize}\n!!gs;
$s =~ s!\\\[(.+?)\\\]\n!\n<math>$1</math>\n\n!gs;
$s =~ s!\\definitionnom{\((.*?)\)}{!{{Définition|t=$1|c=!gs;
$s =~ s!\\theoremenom{\((.*?)\)}{!{{Théorème|t=$1|c=!gs;
$s =~ s!\\theoreme{!{{Théorème|c=!gs;
$s =~ s!\\propriete{\n!{{Propriété|c=\n!gs;
$s =~ s!\\remarque{\n!{{Remarque|c=\n!gs;
$s =~ s!\\corollaire{\n!{{Corollaire|c=\n!gs;

print $s;
