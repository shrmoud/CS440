/* HIPSTER-parser */ 

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ast.h" 
int yyerror(char * s);
int yylex(void);





symbol_t * symbolVal(char * name);
int  updateSymbolVal(symbol_t * val);
int symAssign(const ast_node_t*, ast_symbol_reference_node_t*);

%}

%union {
	struct ast_node * node;
	symboltype_t ty;
};

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
%type <node> typecheck
%type <node> typelist
%type <node> varblob
/* blocks */ 

%token END
%token SEMI

/* strings */ 
%token <node> QUOTE
%token <node> CHARQUOTE
%type <node> stringassign
/* functions */ 
%token FUNCTIONDEF
%token CALL
%token RETURN 
%type <node> func
%type <ty> type_t;
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
%type <node> expression
%type <node> calltype
%type <node> statement
%%

expression: 
	 boolexp
	| exp {$$ = $1;}
	| func {$$ = $1;}
	| calltype {$$ = $1;}
	| stringassign {$$ = $1;}
;

statement: expression SEMI {
	root = $1;
	$$ = $1;
} 
	| expression SEMI statement {
	$$ = $1;
}
;


/* Boolean logic */ 
boolexp:  boolterm 
       | boolexp logic boolexp
       | LPAR boolexp RPAR
;


boolterm: 
	TRUE 
      | FALSE 
      | varblob {
	
};

/* strings */ 
stringassign: varblob ASSGN QUOTE {
	    	ast_node_t * node = $3;
	  	ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;
		if(symAssign(node, s) != 0) {
			printf("error assigning string\n");
		}
		$$ = new_ast_assignment_node(s->symbol, $3);
}
|	    varblob ASSGN CHARQUOTE {
		ast_node_t * node = $3;
		ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;
		if(symAssign(node, s) != 0) {
			printf("error assigning char\n)");
		}
		$$ = new_ast_assignment_node(s->symbol, $3);	

};



/* functions */

type_t:  INT {$$ = INT_T;} 
	| BOOLEAN {$$ = BOOLEAN_T;}
	| DOUBLE {$$ = DOUBLE_T;}
	| POINTER {$$ = PTR_T;}
	| CHAR {$$ = CHAR_T;}
	| STRING {$$ = STRING_T;};


typecheck: type_t TCOL VAR {
	ast_typecheck_node_t * t = (ast_typecheck_node_t*) new_ast_typecheck_node($1,((ast_symbol_reference_node_t*)$3)->symbol);
	$$ = (ast_node_t*) t;
}	
 ;

typelist: typecheck {
	ast_node_t * list = new_ast_typelist_node((ast_typecheck_node_t*)$1);
	$$ = list; 
}
       	|  typecheck typelist {
	typelist_add((ast_typelist_node_t*)$2, (ast_typecheck_node_t*)$1);
	$$ = $2;
};

func: FUNCTIONDEF type_t VAR typelist SEMI statement RETURN value  SEMI END {
	ast_function_node_t * f = (ast_function_node_t*) new_ast_function_node($2);
	$$ = (ast_node_t*) f;
	}
    |  FUNCTIONDEF VOID VAR typelist SEMI statement END {
	ast_function_node_t * f = (ast_function_node_t*) new_ast_function_node(VOID_T);
	f->retval = VOID_T;
	$$ = (ast_node_t*) f;
	}
	

;

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

assignment: varblob ASSGN exp {ast_node_t * node = $3;
	  		ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;
			if(symAssign(node, s) != 0) {
				printf("error in assigning symbol\n");
			}
			$$ = new_ast_assignment_node(s->symbol, $3);} |
	  varblob ASSGN boolexp { 
			//printf("assign to bool %s value %d\n", $1, $3);
			//LEFT OFF HERE
			}
;


digit:SUBT NUMBER {
     		ast_number_node_t * n = (ast_number_node_t*) $2;
     		n->value = n->value * -1;
		$$ = (ast_node_t*) n;}  
     |	SUBT DECIMAL {
		ast_number_node_t * n = (ast_number_node_t*) $2;
		n->value = n->value * -1;
		$$ = (ast_node_t*)  n;} 
     | NUMBER {
		ast_number_node_t * n = (ast_number_node_t*) $1;
		$$ = (ast_node_t*) n;} 
     | DECIMAL {
		ast_number_node_t * n  = (ast_number_node_t*) $1;
		$$ = (ast_node_t*) n;}
;


term: value {$$ = $1;}
    | assignment {$$ = $1;}
;

varblob: VAR {
	symbol_t * sym = symbolVal(((ast_symbol_reference_node_t*)$1)->symbol->name);
           if((sym != NULL) && (sym->type == DOUBLE_T)) {	
	   double d = *((double*)sym->val);
		printf("var with value %f\n", d);
		ast_node_t * n = new_ast_symbol_reference_node(sym);
		$$ = n;
		}
	else if((sym != NULL) && (sym->type == STRING_T)) {
		printf("referenced string %s in a numeric expression\n", ((char*)sym->val));
	}
	else if(sym == NULL) {
		printf("encountered a null symbol\n");
	}

}
       | typecheck {
	ast_typecheck_node_t * tc = (ast_typecheck_node_t*) $1;
	symbol_t * sym = symbolVal(tc->symbol->name);
	if((sym != NULL) && (sym->type != tc->typecheck)) {
		printf("failed typecheck on declare\n");
		return -1;
	}
        if((sym != NULL) && (sym->type == DOUBLE_T)) {	
		double d = *((double*)sym->val);
		printf("var with value %f\n", d);
		ast_node_t * n = new_ast_symbol_reference_node(sym);
		$$ = n;
	}
	else if((sym != NULL) && (sym->type == STRING_T)) {
		printf("referenced string %s in a numeric expression\n", ((char*)sym->val));
	}
	else if(sym == NULL) {
		printf("encountered a null symbol\n");
	}

}
;

value: digit {$$ = $1;} 
     | varblob {$$ = $1;}; 

%%

int yyerror(char * s) {
	printf("%s\n",s);
	return 0;
}

//static void printSymbol(symbol_t s) {
//	printf("name: %s\nvalid: %d\ntype %d\n", s.name, s.valid, s.type);
//}

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
	val->valid = 1;
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
		printf("cannot find symbol\n");
		return NULL ;
	}	
}


int symAssign(const ast_node_t * node, ast_symbol_reference_node_t * s) {
			if(node == NULL) {
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
				case 'C':
				{
				struct ast_string_node * num = (ast_string_node_t*) node;
				if(s->symbol->valsize  >= 0)
					free(s->symbol->val);
				s->symbol->val = malloc(sizeof(char) * strlen(num->str));
				s->symbol->val = (char*) num->str;
				s->symbol->valid = 1;
				s->symbol->type = STRING_T;
				printf("updated symbol %s with result %s\n",s->symbol->name, num->str);
				break;
				}

				default:
				printf("impossible ast situation in assign\n");
				return -1;
			}
		updateSymbolVal(s->symbol);

		return 0; 

}
