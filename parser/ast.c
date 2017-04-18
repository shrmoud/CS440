#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include "ast.h"

ast_node_t * new_ast_node(int node_type, ast_node_t * left, 
		ast_node_t * right) {
	ast_node_t * ast_node = malloc(sizeof(ast_node_t));

	ast_node->node_type = node_type;
	ast_node->left = left;
	ast_node->right = right; 

	return ast_node; 
}


ast_node_t * new_ast_relational_node(relational_operator_t op, 
		ast_node_t * left, ast_node_t * right) {
	ast_relational_node_t * ast_node = malloc(sizeof(ast_relational_node_t));
	ast_node->node_type = 'R';
	ast_node->operator = op;
	ast_node->left = left;
	ast_node->right = right;

	return (ast_node_t * ) ast_node;
}


ast_node_t * new_ast_equality_node(equality_operator_t op, 
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



ast_node_t * new_ast_assignment_node(struct symbol_node * symbol, ast_node_t * value) {
	ast_assignment_node_t * ast_node = malloc(sizeof(ast_assignment_node_t));

	ast_node->node_type = 'A';

	ast_node->symbol = symbol; 
	ast_node->value = value; 

	return (ast_node_t*) ast_node; 
}


ast_node_t * new_ast_number_node(double value) {
	ast_number_node_t * ast_node = malloc(sizeof(ast_number_node_t));
	
	ast_node->node_type = 'N';
	ast_node->value = value;
	return (ast_node_t*) ast_node;

}

ast_node_t * new_ast_function_node(symboltype_t retval) {
	ast_function_node_t * ast_node = malloc(sizeof(ast_function_node_t));

	ast_node->node_type = 'F';
	ast_node->retval = retval;

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
	if(!tree) 
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
		case 'C':
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
			ast_symbol_reference_node_t * node = 
				(ast_symbol_reference_node_t*) tree;
			if(node->symbol != NULL) {
				if(node->symbol->val != NULL) {
					free(node->symbol->val);
				}
				free(node->symbol);
			}
			break;
		}
		case 'H':
		{
			printf("we should not be freeing a root\n");
			return;
		}
		default:
			printf("dropping out in tree (free)\n");
	}
	if(tree != NULL) {
		printf("freeing node with type %c\n",tree->node_type);
		free(tree);
	}
}

void free_ast_tree(ast_node_t * tree) {
	if(tree->node_type != 'H') {
		printf("free_ast_tree should only be called on a root\n");
		return;
	}

	ast_root_node_t * root  = (ast_root_node_t*) tree;

	while(root != NULL) {
		printf("freeing tree 1\n");
		if(root->payload != NULL) 
			free_ast_tree_sys(root->payload);
		root = (ast_root_node_t*) root->next;
	}

}



void free_symbol_table(symbol_t ** table) {
	int i;
	for(i=0;i<SYMTABLE_LEN;i++) {
		if(table[i] != NULL) {
			printf("freeing symbol %s\n", table[i]->name);
			if(table[i]->val != NULL) {
				free(table[i]->val);
			}
			free(table[i]);
		}
	}
}
