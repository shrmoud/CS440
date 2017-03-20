#include <stdio.h>
#include <stdlib.h>
#include "symbols.h"

extern int yyparse();



int main(int argc, char ** argv) {
	if((argc > 1) && (freopen(argv[1], "r",stdin) == NULL)) {
		printf("error opening file\n");
		exit(EXIT_FAILURE);
	}
	yyparse();
	return EXIT_SUCCESS;
}

