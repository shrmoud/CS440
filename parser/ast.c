#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include "ast.h"
#include "parser.tab.h"

int hs_safe_free(void * data) {
	if(data != NULL) {
		free(data);
		data = NULL;
		return 0; 
	}
	else {
		return -1;
	}
}


ast_node_t * new_ast_node(int node_type, ast_node_t * left, 
		ast_node_t * right) {
	ast_node_t * ast_node = malloc(sizeof(ast_node_t));

	ast_node->node_type = node_type;
	ast_node->left = left;
	ast_node->right = right; 

	return ast_node; 
}


ast_node_t * new_ast_relational_node(char op, 
		ast_node_t * left, ast_node_t * right) {
	ast_relational_node_t * ast_node = malloc(sizeof(ast_relational_node_t));
	ast_node->node_type = 'R';
	ast_node->operator = op;
	ast_node->left = left;
	ast_node->right = right;

	return (ast_node_t * ) ast_node;
}


ast_node_t * new_ast_equality_node(char op, 
		ast_node_t * left, ast_node_t * right) {
	ast_equality_node_t * ast_node = malloc(sizeof(ast_equality_node_t));

	ast_node->node_type = 'E';
	ast_node->operator = op;
	ast_node->left = left;
	ast_node->right = right; 

	return (ast_node_t *) ast_node; 
}


ast_node_t * new_ast_symbol_reference_node(struct symbol_node * symbol) {
	ast_symbol_reference_node_t * ast_node = malloc(sizeof(ast_symbol_reference_node_t));

	ast_node->node_type = 'S';
	ast_node->symbol = symbol;

	return (ast_node_t *) ast_node; 
}



ast_node_t * new_ast_assignment_node(ast_symbol_reference_node_t* symbol, ast_node_t * value) {
	ast_assignment_node_t * ast_node = malloc(sizeof(ast_assignment_node_t));
	
	ast_node->node_type = 'A';
	ast_node->type = symbol->symbol->type;
	ast_node->symbol = symbol; 
	ast_node->value = value; 

	return (ast_node_t*) ast_node; 
}


ast_node_t * new_ast_number_node(double value, symboltype_t type) {
	ast_number_node_t * ast_node = malloc(sizeof(ast_number_node_t));
	
	ast_node->node_type = 'N';
	ast_node->value = value;
	ast_node->type = type; 
	return (ast_node_t*) ast_node;

}

ast_node_t * new_ast_function_node(symboltype_t retval, ast_node_t * body, ast_node_t *  param) {
	ast_function_node_t * ast_node = malloc(sizeof(ast_function_node_t));

	ast_node->node_type = 'F';
	ast_node->retval = retval;
	ast_node->body = body;
	ast_node->param = param; 
	return (ast_node_t*) ast_node; 
}


ast_node_t * new_ast_typecheck_node(symboltype_t type, symbol_t * symbol) {
	ast_typecheck_node_t * ast_node = malloc(sizeof(ast_typecheck_node_t));

	ast_node->node_type = 'T';
	ast_node->symbol = symbol;
	ast_node->typecheck = type;

	return (ast_node_t*) ast_node;
}

ast_node_t * new_ast_string_node(char * str) {
	ast_string_node_t * ast_node = malloc(sizeof(ast_string_node_t));

	ast_node->node_type = 'C';
	ast_node->str = str;

	return (ast_node_t*) ast_node;
}
 
ast_node_t * new_ast_typelist_node(struct ast_typecheck_node* t) {
	ast_typelist_node_t * ast_node = malloc(sizeof(ast_typelist_node_t));

	ast_node->node_type = 'L';
	ast_node->next = NULL;
	ast_node->type = t;
	ast_node->first = ast_node;
	return (ast_node_t*) ast_node;
}

ast_node_t * new_ast_root_node(ast_node_t * base) {
	ast_root_node_t * ast_node = malloc(sizeof(ast_root_node_t));
	if(base->node_type == 'H') {
		printf("warning: tried to add a root as a payload\n");
	}
	ast_node->node_type = 'H';
	ast_node->next = NULL;
	ast_node->payload = base; 

	return (ast_node_t*) ast_node; 
}

void root_node_add(ast_root_node_t * root, ast_node_t * new) {
	root->next = new_ast_root_node(new);
}


void typelist_add(struct ast_typelist_node * n, struct ast_typecheck_node * t) {
	while(n != NULL) {
		if(n->next == NULL) {
			ast_typelist_node_t *  tp = (ast_typelist_node_t*)  new_ast_typelist_node(t);
			n->next = tp;
			n = n->first; 
			return;
		}
		else {
			n = n->next;
		}
	}
}

static void free_ast_tree_sys(ast_node_t * tree) {
	if(tree == NULL)
		return;
	switch(tree->node_type) {
		/* two subtrees */ 
		case '+':
		case '-':
		case '*':
		case '/':
		case '%':
			free_ast_tree_sys(tree->right);
			free_ast_tree_sys(tree->left);
		break;
		/* one subtree */ 
		/* no subtrees */ 
		case 'N': 
		case 'T': //TODO: This DOES NOT fre=e the symbol in the symbol table
		break;
		case 'R':
		 {
			ast_relational_node_t * node = 
				(ast_relational_node_t*) tree;
			free_ast_tree_sys(node->left);
			free_ast_tree_sys(node->right);
			break;
	 }
		break;
		case 'E':
		{
			ast_equality_node_t * node =
				(ast_equality_node_t*) tree;
			free_ast_tree_sys(node->left);
			free_ast_tree_sys(node->right);
			break;
		}
		break;
		case 'A':
		{
			ast_assignment_node_t * node =
				(ast_assignment_node_t*) tree;
		
			free_ast_tree_sys(node->value);
			break;
		}
		case 'L':
		{
			ast_typelist_node_t * node = 
				(ast_typelist_node_t*) tree;
			free_ast_tree_sys((ast_node_t*)node->next);
			free_ast_tree_sys((ast_node_t*)node->type);
			break;
		}
		case 'S':
		{
			//ast_symbol_reference_node_t * node = 
			//	(ast_symbol_reference_node_t*) tree;
			//	hs_safe_free(node->symbol->val);
			//	hs_safe_free(node->symbol->name);
			//	hs_safe_free(node->symbol);
			break;
		}
		case 'H':
		{
			printf("we should not be freeing a root\n");
			return;
		}
		case 'C': 
		{
			ast_string_node_t * n = 
				(ast_string_node_t*) tree;
			hs_safe_free(n->str);
			break;
		}
		case 'F': 
		{
			ast_function_node_t * n = 
				(ast_function_node_t*) tree;
			free_ast_tree_sys(n->body);
			free_ast_tree_sys(n->param);
			break;
		}
		default:
			printf("dropping out in tree (free)\n");
	}
	hs_safe_free(tree);
}

void free_ast_tree(ast_node_t * tree) {
	if(tree == NULL) {
		return;
	}
	if(tree->node_type != 'H') {
		printf("free_ast_tree should only be called on a root\n");
		return;
	}

	ast_root_node_t * root  = (ast_root_node_t*) tree;

	while(root != NULL) {
		printf("freeing tree 1\n");
		if(root->payload != NULL) 
			free_ast_tree_sys(root->payload);
		ast_root_node_t * prev = root; 
		root = (ast_root_node_t*) root->next;
		hs_safe_free(prev);
	}

}



void free_symbol_table(symbol_t ** table) {
	int i;
	for(i=0;i<SYMTABLE_LEN;i++) {
		if(table[i] != NULL) {
			if(table[i]->valid != 0) {
				if(table[i]->val != NULL) {
					hs_safe_free(table[i]->val);
				}
				hs_safe_free(table[i]);
			}
		}
	}
}


struct ast_printnode {
	char label;
	int depth;
	struct ast_printnode * next;
	struct ast_printnode * down;
};

struct ast_printnode * printroot = NULL;



static struct ast_printnode * print_ast_tree_sys(ast_node_t * tree, int depth) {
	if(tree == NULL)
		return NULL;
	switch(tree->node_type) {
		/* two subtrees */ 
		case 'R':
		 {
			ast_relational_node_t * node = 
				(ast_relational_node_t*) tree;
			print_ast_tree_sys(node->left, depth + 1);
			print_ast_tree_sys(node->right, depth + 1);
			break;
	 	}
		break;
		case 'E':
		{
			ast_equality_node_t * node =
				(ast_equality_node_t*) tree;
			print_ast_tree_sys(node->left, depth + 1);
			print_ast_tree_sys(node->right, depth + 1);
			break;
		}
		break;
		case 'A':
		{
			ast_assignment_node_t * node =
				(ast_assignment_node_t*) tree;
		
			print_ast_tree_sys(node->value, depth + 1);
			print_ast_tree_sys((ast_node_t*)node->symbol, depth + 1);
			break;
		}
		case 'L':
		{
			ast_typelist_node_t * node = 
				(ast_typelist_node_t*) tree;
			print_ast_tree_sys((ast_node_t*)node->next, depth + 1);
			print_ast_tree_sys((ast_node_t*)node->type, depth + 1);
			break;
		}
		case 'F': 
		{
			ast_function_node_t * n = 
				(ast_function_node_t*) tree;
			print_ast_tree_sys(n->body, depth + 1);
			print_ast_tree_sys(n->param, depth + 1);
			break;
		}

	}
	printf("node with type %c and depth %d\n ",tree->node_type, depth);
	if(printroot == NULL) {
		printroot = malloc(sizeof(struct ast_printnode));
		printroot->label = tree->node_type;
		printroot->depth = depth;
		printroot->next = NULL;
		printroot->down = NULL;
	}
	else  {
		int counter = 0;
		struct ast_printnode * lo = printroot;
		while(lo->down != NULL) {
			if(counter == depth) {
				break;
			}
			lo = lo->down;
			counter++;
		}
		while(lo->next != NULL) {
			lo = lo->next; 
		}

		lo->next = malloc(sizeof(struct ast_printnode));
		lo->next->label = tree->node_type;
		lo->depth = depth;
		lo->next = NULL;
		lo->down = NULL;
	}

	return printroot;
}


static void print_printnode(struct ast_printnode * input) {
	struct ast_printnode * r = input; 
	while(r != NULL) {
		struct ast_printnode * s = r;
		while(s != NULL) {
			printf(" %c ", s->label);
			s = s->next; 	
		}
		printf("\n");
		r = r->down;
	}
}

void print_ast_tree(ast_node_t * tree) {
	if(tree == NULL) {
		return;
	}
	if(tree->node_type != 'H') {
		printf("print_ast_tree should only be called on a root\n");
		return;
	}

	ast_root_node_t * root  = (ast_root_node_t*) tree;
	struct ast_printnode * print = NULL;
	while(root != NULL) {
		printf("printing tree 1\n");
		if(root->payload != NULL) 
			print = print_ast_tree_sys(root->payload,0);
		root = (ast_root_node_t*) root->next;
	}

	if(print != NULL) {
		print_printnode(print);
	}

}


