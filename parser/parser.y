/* HIPSTER-C parser */ 



%{
#include "stdio.h"
#include "symbols.h"
int yyerror(char * s);
int yylex(void); 
%}

%union {
	int	int_val;
	char* op_val;
}

%start input
%token <int_val> integer

%%


input: /* empty */ 
     | exp { printf("Result \n"); }
	;

exp: integer{ printf("test1\n");}
   | integer exp  { printf("test2\n");} ;

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}


