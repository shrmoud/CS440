/* HIPSTER-C parser */ 



%{
#include "symbols.h"
int yyerror(char * s);
int yylex(void); 
%}


%start input

%left FUNCTION

%%


input: /* empty */ 
     | exp { printf("Result %s\n", $1); }
	;

exp: FUNCTION | FUNCTION exp;

%%

int yyerror(char * s) {
	printf("%s\n",s);
}


