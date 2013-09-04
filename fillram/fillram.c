/*
I, Raphael Champeimont, the author of this program,
hereby release it into the public domain.
This applies worldwide.

In case this is not legally possible:
I grant anyone the right to use this work for any purpose,
without any conditions, unless such conditions are required by law.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

/* This program writes a lot of 'B' in the memory. I wrote it to
 * test the encrypted swap feature of Linux this way:
 * 1. start this program
 * 2. kill it when it has eaten a lot of swap
 *    (or let the kernel kill it, with your apps together)
 * 3. run: strings /dev/your-swap-partition
 * If you swap is not encrypted, you should see a lot of lines
 * with 'B's. If it is encrypted, you should see only rubbish.
 * In the case your swap is encrypted, you can get the 'B's by doing
 * "strings /dev/mapper/my-decrypted-swap-partition", and you can
 * notice that they are all lost after reboot (because key changed,
 * which is the purpose of encrypted swap).
 * And the other hand, if your swap is not encrypted, you can still
 * see the 'B's after reboot when running "strings /dev/your-swap-partition".
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* 1048576B = 1MB */
#define SIZE 1048576

int main(int argc, char** argv) {
    char* p;
    while ((p = malloc(SIZE))) {
	memset(p, 'B', SIZE);
	putchar('.');
	fflush(stdout);
    }
    putchar('\n');
    fflush(stdout);
    return 0;
}
