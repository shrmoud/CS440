/* HIPSTER-parser */ 



%{
#include "stdio.h"
int yyerror(char * s);
int yylex(void); 
%}

%union {
	int num;

}

%start exp
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
%token MOD 
%token END 
%token VAR 
%token ADD 
%token SEMI
%token SUBT 
%token MULT 
%token DIV  
%token <int> ASSGN 
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
%token DECIMAL
%token <int> DECIMAL 
%token <double>  NUMBER 
%token FUNCTIONDEF
%token identifier
%type <int>  exp
%type <int> operator
%type <int>  arithmatic
%type <int>  type_t
%type <int>  assignment
%type <int>  term
%%

exp:  NUMBER;
arithmatic: ADD
	| SUBT
	| MULT	
	| MOD
	;

assignment: identifier ASSGN exp
	  ;
operator: arithmatic 
	| assignment ;

assignment: identifier ASSGN exp
;

exp: term                  //{$$ = $1;}
   | exp ADD term          //{$$ = $1 + $3;}
   | exp SUBT term          //{$$ = $1 - $3;}
   | exp MULT term          //{$$ = $1 * $3;}
   | exp DIV term          //{$$ = $1 / $3;}
   | exp MOD term          //{$$ = $1 % $3;}
   | exp ASSGN term          //{$$ = $1 = $3;}
   | exp NOT term          //{$$ = $1 ! $3;}
   | exp AND term         //{$$ = $1 && $3;}
   | exp EQ term         //{$$ = $1 == $3;}
   | exp OR term         //{$$ = $1 || $3;}
   | exp NOTEQ term         //{$$ = $1 != $3;}
   | exp LESS term          //{$$ = $1 < $3;}
   | exp GRAT term          //{$$ = $1 > $3;}
   | exp LEEQ term         //{$$ = $1 <= $3;}
   | exp GREQ term         //{$$ = $1 >= $3;}
;
digit: NUMBER | DECIMAL;

 term: digit
	| identifier 
;

/*
term: double
	| identifier
;

term: decimal
	| identifier
;

*/ 


%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}
