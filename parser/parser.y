/* HIPSTER-parser */ 



%{
#include "stdio.h"
int yyerror(char * s);
int yylex(void); 
%}

%union {
	int num;

}

%start expression
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
%token TCOL
%token <int> DECIMAL 
%token <double>  NUMBER 
%token END
/* functions */ 
%token FUNCTIONDEF



/* math and arithmatic */ 
%token MOD 
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
%token identifier
%type <int>  exp
%type <int> operator
%type <int>  arithmatic
%type <int>  type_t
%type <int>  assignment
%type <int>  term
%type <int> logic
%type <int> boolexp 
%type <int> boolterm
%type <int> expression

%%
expression: boolexp | exp

/* Boolean logic */ 
boolexp:  boolterm 
       | boolexp logic boolexp
       | LPAR boolexp RPAR
;


boolterm: TRUE | FALSE | VAR;


/* functions */ 



/* math and arithmatic */ 
exp:  term
   | exp operator exp
   |  LPAR exp RPAR ;

arithmatic: ADD
	| SUBT
	| MULT	
	| MOD
	;

operator: arithmatic 
	| assignment 
        | logic;

logic: NOT 
     | AND
     | NOTEQ
     | EQ
     | LESS
     | GRAT
     | GREQ
     | OR
     | LEEQ
;

assignment: VAR ASSGN exp |
	  VAR ASSGN boolexp
;


digit:SUBT NUMBER |
    	SUBT DECIMAL|
     | NUMBER | DECIMAL;


term: digit | VAR | assignment
;



%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}
