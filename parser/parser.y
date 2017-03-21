/* HIPSTER-parser */ 



%{
#include "stdio.h"
int yyerror(char * s);
int yylex(void); 
%}

%union {
	int num;
	char id;
}

%start input
%token PRINT
%token POINTER
%token TAINTED 
%token DOUBLE
%token INT
%token FOR 
%token CALL
%token ARRAY
%token BOOLEAN
%token TRUE
%token FALSE
%token STRING
%token CHAR 
%token VOID 
%token RETURN 
%token CBLOCK 
%token HEADER 
%token IF 
%token ELSE 
%token END 
%token VAR 
%token ADD 
%token SEMI 
%token SUBT 
%token MULT 
%token DIV  
%token ASSGN 
%token NOT 
%token AND 
%token OR 
%token EQ 
%token NOTEQ 
%token LESS 
%token GRAT 
%token LEEQ 
%token GREQ  
%token LPAR 
%token RPAR 
%token TCOL 
%token NUMBER 
%token FUNCTIONDEF

%%


input: PRINT { printf("Result \n");} 
	;
%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}


