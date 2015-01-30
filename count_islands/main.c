#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXSIZE 1100

typedef struct list_element_s {
	char *line;
	struct list_element_s *next;
} list_element;

list_element *createListElement(const char *s) {
	size_t n;
	n = strlen(s) + 1;
	list_element *e = malloc(sizeof(list_element));
	e->line = malloc(n);
	memcpy(e->line, s, n);
	e->next = NULL;
	return(e);
}

void addListElement(list_element **start, list_element *e) {
	list_element *last;
	if (*start == NULL) {
		*start = e;
	} else {
		last = *start;
		while (last->next != NULL) {
			last = last->next;
		}
		last->next = e;
	}
}

int countListElements(list_element *start) {
	list_element *e = start;
	int n = 0;
	while (e != NULL) {
		n++;
		e = e->next;
	}
	return(n);
}

char **translateListToMap(list_element *list) {
	int nlines = countListElements(list);
	printf("%d lines read\n", nlines);
	char **map = malloc(sizeof(char *) * (nlines + 1));
	map[nlines] = NULL;
	list_element *e = list;
	list_element *next = NULL;
	int k = 0;
	while (e != NULL) {
		map[k] = e->line;
		next = e->next;
		free(e);
		e = next;
		k++;
	}
	return(map);
}

char **readMap(const char *path) {
	char s[MAXSIZE];
	int nlpos;
	list_element *list = NULL;
	char *r;
	FILE* f = fopen(path, "r");
	while (1) {
		r = fgets(s, MAXSIZE, f);
		if (r == NULL) {
			break;
		} else {
			nlpos = strlen(r) - 1;
			if (r[nlpos] == '\n') {
				r[nlpos] = '\0';
			}
			addListElement(&list, createListElement(s));
		}
	}
	fclose(f);
	
	return translateListToMap(list);
}

void printMap(char **map) {
	int k = 0;
	while (map[k] != NULL) {
		printf("%s\n", map[k]);
		k++;
	}
}

void findCompleteIsland(char **map, int i, int j, int nrows, int ncols, char island) {
	map[i][j] = island;
	if (i > 0 && map[i-1][j] == 'X') {
		findCompleteIsland(map, i-1, j, nrows, ncols, island);
	}
	if (i < nrows-1 && map[i+1][j] == 'X') {
		findCompleteIsland(map, i+1, j, nrows, ncols, island);
	}
	if (j > 0 && map[i][j-1] == 'X') {
		findCompleteIsland(map, i, j-1, nrows, ncols, island);
	}
	if (j < ncols-1 && map[i][j+1] == 'X') {
		findCompleteIsland(map, i, j+1, nrows, ncols, island);
	}
}

void findIslands(char **map) {
	char island = '0';
	int nrows = 0;
	int i, j;
	char *line = map[0];
	while (line) {
		nrows++;
		line = map[nrows];
	}
	int ncols = strlen(map[0]);
	printf("%d rows - %d cols\n", nrows, ncols);
	for (i=0; i<nrows; i++) {
		for (j=0; j<ncols; j++) {
			if (map[i][j] == 'X') {
				findCompleteIsland(map, i, j, nrows, ncols, island);
				if (island >= '0' && island < '9') {
					island++;
				} else {
					island = '!';
				}
				//printf("next island character: %c\n", island);
			}
		}
	}
}

int main(int argc, char *argv[]) {
	char **map = readMap("cout_island.map");
	printf("Original map:\n");
	printMap(map);
	findIslands(map);
	printf("New map:\n");
	printMap(map);
	return 0;
}
