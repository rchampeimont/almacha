/* File under GNU GPLv2 or later */

#include <stdio.h>
#include <stdlib.h>
#include "igraph.h"

void pause(void) {
    if (feof(stdin)) {
        return;
    }
    printf("Press ENTER to continue...\n");
    while (getchar() != '\n') {
        if (feof(stdin)) {
            return;
        }
    }
}

int main(void) {

    // This needs to be done *first*. See igraph doc for why.
    igraph_i_set_attribute_table(&igraph_cattribute_table);

    printf("sizeof(int)=%d sizeof(long)=%d sizeof(igraph_integer_t)=%d\n", (int) sizeof(int), (int) sizeof(long), (int) sizeof(igraph_integer_t));

    pause();

    printf("Loading graph from file...\n");
    FILE* f = fopen("donnees/arretes.test", "r");
    //FILE* f = fopen("graph_a.ncol", "r");
    igraph_t gr;
    igraph_read_graph_ncol(&gr, f, NULL, 1, 0, 0);
    fclose(f);
    f = NULL;
    long vcount = igraph_vcount(&gr);
    long ecount = igraph_ecount(&gr);
    printf("Main graph: |V| = %ld, |E| = %ld\n", vcount, ecount);

    pause();

    // get connected components
    printf("Computing connected components...\n");
    igraph_vector_t membership;
    igraph_vector_t csize;
    igraph_integer_t cnum = 0;
    igraph_vector_init(&membership, 1);
    igraph_vector_init(&csize, 1);
    igraph_clusters(&gr, &membership, &csize, &cnum, IGRAPH_STRONG);
    printf("There are %ld connected components.\n", (long) cnum);

    // work with connected components
    {  
        printf("Writing connected components to file...\n");
        // open file
        FILE* filout = fopen("groupes", "w");

        long membership_size = igraph_vector_size(&membership);
        if (membership_size != vcount) {
            fprintf(stderr, "FATAL ERROR: membership_size != vcount\n");
            exit(1);
        }
        for (long i = 0; i < membership_size; i++) {
            fprintf(filout,
                "%ld\t%s\n",
                // connected component id:
                (long) igraph_vector_e(&membership , i),
                // veretex name:
                igraph_cattribute_VAS(&gr, "name", i));
        }

        fclose(filout);
        filout = NULL;
        printf("Connected components written.\n");
    }


    pause();


    // free connected components
    igraph_vector_destroy(&membership);
    igraph_vector_destroy(&csize);
    // free main graph
    igraph_destroy(&gr);

    printf("Program ends.\n");

    pause();

    return 0;
}
