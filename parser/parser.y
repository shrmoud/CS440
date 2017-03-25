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
int  updateSymbolVal(symbol_t * val);

%}

%union {
	char  name[30];
	char  var[30];
	double dub;
	int    integer;
	struct ast_node * node;
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

assignment: VAR ASSGN exp {ast_node_t * node = $3;
	  		ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;
			if($1 == NULL) {
				printf("bad symbol node in assignment\n");
				return -1;
			}
			if(node == NULL) {
				printf("bad exp node in assignment\n");
				return -1; 
			}
			switch(node->node_type) {
				case 'N':
				{
				struct ast_number_node * num = (ast_number_node_t*) node;
				if(s->symbol->valsize  >= 0)
					free(s->symbol->val);
				s->symbol->val = malloc(sizeof(double));
				*((double*)s->symbol->val) = num->value;
				s->symbol->valid = 1;
				s->symbol->type = DOUBLE_T;
				printf("updated symbol %s with result %f\n",s->symbol->name, num->value);
				break;
				}
				case 'S':
				{
				ast_symbol_reference_node_t * ns = (ast_symbol_reference_node_t*) node;
				memcpy(s->symbol, ns->symbol, sizeof(symbol_t));
				printf("assigned %s to %s\n", ns->symbol->name, s->symbol->name);
				break;
				}
				default:
				printf("impossible ast situation in assign\n");
				return -1;
			}
				printf("updated symbol table index %d\n", updateSymbolVal(s->symbol));	
				$$ = new_ast_assignment_node(s->symbol, $3);} |
	  VAR ASSGN boolexp { 
				//printf("assign to bool %s value %d\n", $1, $3);
				//LEFT OFF HERE
				}
;


digit:SUBT NUMBER {ast_number_node_t * n = (ast_number_node_t*) $2;
     			n->value = n->value * -1;
			$$ = (ast_node_t*) n;}  
     |	SUBT DECIMAL {ast_number_node_t * n = (ast_number_node_t*) $2;
			n->value = n->value * -1;
			$$ = (ast_node_t*)  n;} 
     | NUMBER {ast_number_node_t * n = (ast_number_node_t*) $1;
		$$ = (ast_node_t*) n;} 
     | DECIMAL {ast_number_node_t * n  = (ast_number_node_t*) $1;
		$$ = (ast_node_t*) n;}
;


term: value {$$ = $1;}
    | assignment {$$ = $1;}
;

value: digit {$$ = $1;} 
     | VAR {symbol_t * sym = symbolVal(((ast_symbol_reference_node_t*)$1)->symbol->name);
            if((sym == NULL) || (sym->type != DOUBLE_T)) {
		printf("err: variable not bound\n");
		return -1;
		}	
	   double d = *((double*)sym->val);
		printf("var with value %f\n", d);
		ast_node_t * n = new_ast_symbol_reference_node(sym);
		$$ = n;}; 

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}

static void printSymbol(symbol_t s) {
	printf("name: %s\nvalid: %d\ntype %d\n", s.name, s.valid, s.type);
}

static int symbolIndex(char * name) {
	printf("searching for index for %s\n", name);
	int x; 
	for(x=0;x<SYMTABLE_LEN;x++) {
		//printSymbol(*symbols[x]);
		if(symbols[x] == NULL)  {
			//printf("null symbol\n");
			continue;
		}
		if(symbols[x]->valid == 0) {
			printf("invalid symbol\n");
		}
		if((symbols[x]->valid == 1) && (symbols[x]->name[0] == name[0])) {
			if(strcmp(symbols[x]->name, name) == 0) {
				return x;
			}
		}
	}
	return -1;
}


int updateSymbolVal(symbol_t * val) {
	int index;
	index = symbolIndex(val->name);
	if(index > 0) {
		symbols[index] = val;	
		return index;
	}
	int x;
	for(x=0;x<SYMTABLE_LEN;x++) {
		if(symbols[x]== NULL) {
			symbols[x] = val;
			return x;

		}
		else if(symbols[x]->valid == 0) {
			symbols[x] = val;
			return x;
		}
	}
	printf("error with updateSymbolVal\n");
	return -1; 

}

symbol_t * symbolVal(char * name) {
	int index;
	index = symbolIndex(name);
	if(index >= 0) {
		printf("found a symbol from table\n");
		return symbols[index];
	}
	else {
		return NULL ;
	}	
}
