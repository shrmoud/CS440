/* HIPSTER-parser */ 



%{
#include "stdio.h"
#define SYMTABLE_LEN 100
int yyerror(char * s);
int yylex(void);
char* symbols[SYMTABLE_LEN]; 
int q;
typedef enum {
	INT_T, VOID_T, DOUBLE_T, BOOLEAN_T
} symbol_t;
void * symbolVal(char * symbol, symbol_t * type);

void updateSymbolVal(char* symbol, symbol_t type,const void * val);

%}

%union {
	int num;
}

%start statement
%token PRINT

/* C constructs */ 
%token POINTER
%token TAINTED 
%token FOR 
%token IF 
%token ELSE
%token CBLOCK 
%token HEADER 

/* types */ 

%token TCOL
%token <int> DECIMAL 
%token <double>  NUMBER 
%token DOUBLE
%token INT
%token STRING
%token CHAR 
%token ARRAY
%token BOOLEAN
%token TRUE
%token FALSE
%token VOID 


/* blocks */ 

%token END
%token SEMI
%type <int> statement

/* strings */ 
%token QUOTE
%token CHARQUOTE
%type <int> stringassign

/* functions */ 
%token FUNCTIONDEF
%token CALL
%token RETURN 
%type <int> func
%type <int> typecheck
%type <int> typelist
%type <int> calltype

/* math and arithmatic */ 
%token MOD 
%token VAR 
%token ADD 
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
%type <int> value
%%

expression: boolexp | exp | func | calltype | stringassign ;

statement: expression SEMI | expression SEMI statement  ;


/* Boolean logic */ 
boolexp:  boolterm 
       | boolexp logic boolexp
       | LPAR boolexp RPAR
;


boolterm: TRUE | FALSE | VAR;

/* strings */ 
stringassign: VAR ASSGN QUOTE |
	    VAR ASSGN CHARQUOTE;



/* functions */

type_t:  INT | BOOLEAN | DOUBLE | POINTER | CHAR | STRING;


typecheck: type_t TCOL VAR

typelist: typecheck |  typecheck typelist;

func: FUNCTIONDEF type_t VAR typelist SEMI statement RETURN value  SEMI END
    |  FUNCTIONDEF VOID VAR typelist SEMI statement END;

calltype: CALL VAR

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

value: digit | VAR

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}

static int computeSymbolTableIndex(char * in) {
}
void * symbolVal(char * symbol, symbol_t * type) {

	return NULL;
}

void updateSymbolVal(char* symbol, symbol_t type,const void * val) {
	int index = -1;
	int x;
	int idx = -1;
	if(islower(symbol[0]))
		idx = symbol[0] - 'a' + 26;
	else if(isupper(symbol[0]))
		idx = symbol[0] - 'A'; 
	for(x=idx;x<SYMTABLE_LEN;x++) {
		if(symbols[x] == NULL) {
			symbols[x] = malloc(sizeof(char) * strlen(symbol));
			strcpy(symbols[x], symbol);
			return;
		}
	}

}

