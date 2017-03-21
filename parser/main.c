#include <stdio.h>
#include <stdlib.h>
#include "symbols.h"

extern int yyparse();



int main(int argc, char ** argv) {
	if((argc > 1) && (freopen(argv[1], "r",stdin) == NULL)) {
		printf("error opening file\n");
		exit(EXIT_FAILURE);
	}
	int x;
	x = yyparse();
	if(x == 0) 
		printf("valid syntax\n");
	return EXIT_SUCCESS;
}

