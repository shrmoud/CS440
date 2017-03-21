/* HIPSTER-parser */ 



%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define SYMTABLE_LEN 100
#define VARLEN 30
int yyerror(char * s);
int yylex(void);

//a type that a value can have for a symbol 
typedef enum {
	INT_T, VOID_T, DOUBLE_T, BOOLEAN_T, STRING_T, PTR_T
} symboltype_t;



//represents a single symbol for the symbol table
typedef struct {
	char valid;
	char name[VARLEN];
	symboltype_t type;
	size_t valsize; 
	void * val;
} symbol_t;

// symbol table
symbol_t symbols[SYMTABLE_LEN]; 


symbol_t symbolVal(char * name);
int updateSymbolVal(symbol_t val);

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

static int symbolIndex(char * name) {
	int x; 
	for(x=0;x<SYMTABLE_LEN;x++) {
		if((symbols[x].valid == 1) && (symbols[x].name[0] == name[0])) {
			if(strcmp(symbols[x].name, name) == 0) {
				return x;
			}
		}
	}
	return -1;
}


int updateSymbolVal(symbol_t val) {
	int index;
	index = symbolIndex(val.name);
	if(index > 0) {
		memcpy(symbols[index].val, (char*)val.val, val.valsize);
		symbols[index].type = val.type;
		return 0;
	}
	int x;
	for(x=index;x<SYMTABLE_LEN;x++) {
		if(symbols[x].valid == 0) {
			memcpy(&symbols[x], &val,sizeof(val));
			return 0;
		}
	}

	return -1; 

}

symbol_t symbolVal(char * name) {
	int index;
	index = symbolIndex(name);
	if(index > 0) {
		return symbols[index];
	}
	else {
		symbol_t ret;
		ret.valid = 0;
		return ret;
	}	
}
