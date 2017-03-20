/* HIPSTER-C parser */ 



%{
#include "stdio.h"
#include "symbols.h"
int yyerror(char * s);
int yylex(void); 
%}


%start input

%left FUNCTION

%%


input: /* empty */ 
     | exp { printf("Result %d\n", $1); }
	;

exp: FUNCTION | FUNCTION exp;

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}


