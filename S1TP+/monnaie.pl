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

printf("Entrez le prix en centimes : ");
$prix = <STDIN>;
printf("Entrez la somme payee en centimes : ");
$somme_versee = <STDIN>;
$difference = $somme_versee - $prix;

if ($difference <= 0) {
    print "Il ne faut rien rendre.\n";
    exit(0);
}


$nb5e = int($difference/500);
$reste = int($difference%500);
$nb2e = int($reste/200);
$reste = int($reste%200);
$nb1e = int($reste/100);
$reste = int($reste%100);
$nb50c = int($reste/50);
$reste = int($reste%50);
$nb20c = int($reste/20);
$reste = int($reste%20);
$nb10c = int($reste/10);
$nb1c = int($reste%10);

printf("Il faut rendre :\n");

if ($nb5e > 0) {
    if ($nb5e > 1) {
	printf " - %d billets de 5 E\n", $nb5e;
    } else {
	printf " - 1 billet de 5E\n";
    }
}
if ($nb2e>0) {
    printf " - %d pieces de 2 E\n", $nb2e;
}
if ($nb1e>0) {
    printf " - %d pieces de 1 E\n", $nb1e;
}
if ($nb50c>0) {
    printf " - %d pieces de 50 c\n", $nb50c;
}
if ($nb20c>0) {
    printf " - %d pieces de 20 c\n", $nb20c;
}
if ($nb10c>0) {
    printf " - %d pieces de 10 c\n", $nb10c;
}
if ($nb1c>0) {
    printf " - %d pieces de 1c\n", $nb1c;
}
