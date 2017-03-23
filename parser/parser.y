/* HIPSTER-parser */ 



%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ast.h" 
int yyerror(char * s);
int yylex(void);




// symbol table
symbol_t * symbols[SYMTABLE_LEN]; 


symbol_t * symbolVal(char * name);
symbol_t * updateSymbolVal(symbol_t val);

%}

%union {
	char  name[30];
	char  var[30];
	double dub;
	int    integer;
	struct ast_node node;
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
%token <node> DECIMAL 
%token <node>  NUMBER 
%token DOUBLE
%token INT
%token STRING
%token CHAR 
%token ARRAY
%token BOOLEAN
%token TRUE
%token FALSE
%token VOID 
%type <node> digit

/* blocks */ 

%token END
%token SEMI

/* strings */ 
%token QUOTE
%token CHARQUOTE

/* functions */ 
%token FUNCTIONDEF
%token CALL
%token RETURN 

/* math and arithmatic */ 
%token MOD 
%token <node> VAR 
%token ADD 
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
%token identifier
%type <node> exp
%type <node> term
%type <node> value
%type <node> assignment
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
exp:  term {$$ = $1;}
   | exp operator exp
   |  LPAR exp RPAR {$$ = $2;} ;

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

assignment: VAR ASSGN exp {symbol_t sym;
	  			printf("assign to %s value %f\n",$1, $3 );
	     		strcpy(sym.name,$1);
			sym.valid = 1;
			sym.val = malloc(sizeof($3));
			sym.type = DOUBLE_T;
			memcpy(sym.val, &$3,sizeof($3));
			 symbol_t * res = updateSymbolVal(sym);
				
				$$ = new_assignment_node(res, $3);} |
	  VAR ASSGN boolexp
;


digit:SUBT NUMBER {double val = -1 * $2;
     			ast_number_node_t * n = new_ast_number_node(val);
			$$ = n;}  
     |	SUBT DECIMAL {double val = -1 * $2;
			ast_number_node_t * n = new_ast_number_node(val); 
			$$ = n;} 
     | NUMBER {double val = $1;
		ast_number_node_t * n = new_ast_number_node(val)l
		$$ = n;} 
     | DECIMAL {double val = $1;
		ast_number_node_t * n = new_ast_number_node(val);
		$$ = n;}
;


term: value
    | assignment
;

value: digit | VAR {symbol_t * sym = symbolVal($1);
            if((sym == NULL) || (sym->type != DOUBLE_T)) {
		printf("err: variable not bound\n");
		return -1;
		}	
	   double d = *((double*)sym->val);
		printf("var with value %f\n", d);
		$$ = //LEFT OFF HERE;}; 

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}

static void printSymbol(symbol_t s) {
	printf("name: %s\nvalid: %d\ntype %d\n", s.name, s.valid, s.type);
}

static int symbolIndex(char * name) {
	//printf("searching for index for %s\n", name);
	int x; 
	for(x=0;x<SYMTABLE_LEN;x++) {
		//printSymbol(symbols[x]);
		if(symbols[x] == NULL) 
			continue;
		if((symbols[x]->valid == 1) && (symbols[x]->name[0] == name[0])) {
			if(strcmp(symbols[x]->name, name) == 0) {
				return x;
			}
		}
	}
	return -1;
}


symbol_t *  updateSymbolVal(symbol_t val) {
	int index;
	index = symbolIndex(val.name);
	if(index > 0) {
		symbols[index] = malloc(sizeof(symbol_t));
		memcpy(symbols[index]->val, (char*)val.val, val.valsize);
		symbols[index]->type = val.type;	
		return symbols[index];
	}
	int x;
	for(x=index;x<SYMTABLE_LEN;x++) {
		if(symbols[x]== NULL) {
			symbols[x] = malloc(sizeof(symbol_t));
			memcpy(&symbols[x], &val,sizeof(val));
			return symbols[x];

		}
		else if(symbols[x]->valid == 0) {
			memcpy(&symbols[x], &val,sizeof(val));
			return symbols[x];
		}
	}

	return NULL; 

}

symbol_t * symbolVal(char * name) {
	int index;
	index = symbolIndex(name);
	if(index >= 0) {
		//printf("found a symbol from table\n");
		return symbols[index];
	}
	else {
		return NULL ;
	}	
}
