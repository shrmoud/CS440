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
	char op;
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
%type <node> ifstatement
%type <node> elifchain
%type <node> elif
%type <node> singleelse
%type <node> singleif
%type <node> boolterm
%type <node> boolexp
%type <op> operator
%type <op> arithmatic
%type <op> logic
%%
expression: 
	 boolexp
	| exp {$$ = $1;}
	| func {$$ = $1;}
	| call
	| calltype {$$ = $1;}
	| stringassign {$$ = $1;}
	| DECIMAL {$$ = $1;}
	| NUMBER {$$ = $1;}
;

statement: expression SEMI {
	root = (ast_root_node_t*)  new_ast_root_node($1);
	$$ = (ast_node_t*) root;
} 
	| expression SEMI statement {
	ast_node_t * n =  $1;
	root_node_add(root, n);
	$$ = (ast_node_t*) root;
}
;


/* Boolean logic */ 
boolexp:  boolterm 
       | boolexp logic boolexp
       | LPAR boolexp RPAR
;


call: CALL callable

boolterm: 
	TRUE 
      | FALSE 
      | varblob {
	
};

callable: 
	  func
	| varblob
	| type_t
;

/* strings */ 
stringassign: varblob ASSGN QUOTE {
	    	ast_node_t * node = $3;
	  	ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;
		int ret = symAssign(node, s); 
		if(ret == -2) {
			yyerror("ERR: typecheck error\n");
			YYERROR;
		}
		else if(ret != 0) {
			yyerror("error assigning string\n");
			YYERROR;
		}
		$$ = new_ast_assignment_node(s, $3);
}
|	    varblob ASSGN CHARQUOTE {
		ast_node_t * node = $3;
		ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;

		int ret = symAssign(node, s);
		if(ret == -2) {
			yyerror("ERR: typecheck error\n");
			YYERROR;
		}
		else if(ret != 0) {
			yyerror("error assigning char\n)");
			YYERROR;	
		}
		$$ = new_ast_assignment_node(s, $3);	

};



/* functions */

type_t:  INT {$$ = INT_T;} 
	| BOOLEAN {$$ = BOOLEAN_T;}
	| DOUBLE {$$ = DOUBLE_T;}
	| POINTER {$$ = PTR_T;}
	| CHAR {$$ = CHAR_T;}
	| STRING {$$ = STRING_T;};


typecheck: type_t TCOL VAR {
	symbol_t * sr = ((ast_symbol_reference_node_t*)$3)->symbol;
	sr->type = $1;
	ast_typecheck_node_t * t = (ast_typecheck_node_t*) new_ast_typecheck_node($1,sr);
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
	ast_function_node_t * f = (ast_function_node_t*) new_ast_function_node($2, $6, $4);
	$$ = (ast_node_t*) f;
	}
    |  FUNCTIONDEF VOID VAR typelist SEMI statement END {
	ast_function_node_t * f = (ast_function_node_t*) new_ast_function_node(VOID_T, $6, $4);
	f->retval = VOID_T;
	$$ = (ast_node_t*) f;
	}
;

calltype: CALL VAR

/* math and arithmatic */ 
exp:  term {$$ = $1;}
   | exp operator exp {
	ast_relational_node_t * n = 
	(ast_relational_node_t*) new_ast_relational_node($2,$1,$3);
	$$ = (ast_node_t*) n;

}
   |  LPAR exp RPAR {$$ = $2;} ;

arithmatic: ADD {$$ = '+';}
	| SUBT  {$$ = '-';}
	| MULT	{$$ = '*';}
	| MOD   {$$ = '%';}
	;

operator: arithmatic {$$ = $1;}
	| assignment {$$ = 'S';}
        | logic {$$ = $1;};

logic: NOT {$$ = '!';}
     | AND {$$ = 'A';} 
     | NOTEQ {$$ = 'K';} 
     | EQ    {$$ = '=';}
     | LESS {$$ = '<';}
     | GRAT {$$ = '>';} 
     | GREQ {$$ = 'Y';} 
     | OR   {$$ = 'O';}
     | LEEQ {$$ = 'P';}
;

assignment: varblob ASSGN exp {ast_node_t * node = $3;
	  		ast_symbol_reference_node_t * s = (ast_symbol_reference_node_t*) $1;

			int ret = symAssign(node, s);
			if(ret == -2) {
				yyerror("typecheck error\n");
				YYERROR;
			}
			else if(ret != 0) {
				yyerror("error in assigning symbol\n");
				YYERROR;	
			}
			$$ = new_ast_assignment_node(s, $3);} |
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
	}
	//else if((sym != NULL) && (sym->type == STRING_T)) {
	//	yyerror("ERR: typecheck error: string != number\n");
	//	YYERROR;
	//}
	else if(sym == NULL) {
	}

	$$ = $1;

}
       | typecheck {
	ast_typecheck_node_t * tc = (ast_typecheck_node_t*) $1;
	symbol_t * sym = symbolVal(tc->symbol->name);
	if((sym != NULL) && (sym->type != tc->typecheck)) {
		yyerror("ERR: failed typecheck on declare\n");
		YYERROR;
	}
	else if(sym == NULL) {
	}
	
	tc->symbol->enforce_type = 1; 
	$$ = (ast_node_t*) tc; 

}
;

value: digit {$$ = $1;} 
     | varblob {$$ = $1;}; 

%%

int yyerror(char * s) {
	printf("%s\n",s);
	free_ast_tree((ast_node_t*)root);
	free_symbol_table(symbols);
	return 1;
}

//static void printSymbol(symbol_t s) {
//	printf("name: %s\nvalid: %d\ntype %d\n", s.name, s.valid, s.type);
//}

static int symbolIndex(char * name) {
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
	yyerror("error with updateSymbolVal\n");
	return 0;
}

symbol_t * symbolVal(char * name) {
	int index;
	index = symbolIndex(name);
	if(index >= 0) {
		return symbols[index];
	}
	else {
		return NULL ;
	}	
}


int symAssign(const ast_node_t * node, ast_symbol_reference_node_t * s) {
			if(s == NULL) {
				return -1;
			}

			if(s->symbol == NULL) {
				return -1;
			}

			if(node == NULL) {
				return -1; 
			}
			switch(node->node_type) {
				case 'N':
				{
				struct ast_number_node * num = (ast_number_node_t*) node;
				
				if(s->symbol->type != num->type) {
					return -2;
				}

		//		if(s->symbol->valsize  >= 0)
		//			hs_safe_free(s->symbol->val);

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
			//	if(s->symbol->valsize  >= 0)
			//		hs_safe_free(s->symbol->val);
				if((s->symbol->enforce_type == 1) && (s->symbol->type != STRING_T)) {
					return -2;
				}
				s->symbol->val = malloc(sizeof(char) * strlen(num->str));
				strcpy((char*)s->symbol->val, num->str);
				s->symbol->valsize = strlen(num->str);
				s->symbol->valid = 1;
				s->symbol->type = STRING_T;
				printf("updated symbol %s with result %s\n",s->symbol->name, num->str);
				break;
				}

			}
		updateSymbolVal(s->symbol);

		return 0; 

}
