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

ast_node_t * new_ast_typelist_node(struct ast_typecheck_node * list, int size) {
	ast_typelist_node_t * ast_node = malloc(sizeof(ast_typelist_node_t));

	ast_node->node_type = 'L'; 
	ast_node->types = malloc(sizeof(struct ast_typecheck_node*)*size);
	memcpy(ast_node->types, list, sizeof(struct ast_typecheck_node*));
	ast_node->size = size; 

	return (ast_node_t*) ast_node;
}

void free_ast_tree(ast_node_t * tree) {
	if(!tree) 
		return;

	switch(tree->node_type) {
		/* two subtrees */ 
		case '+':
		case '-':
		case '*':
		case '/':
		case '%':
		case 'L':
			free_ast_tree(tree->right);
			free_ast_tree(tree->left);
		break;
		/* one subtree */ 
		/* no subtrees */ 
		case 'S':
		case 'N': 
		break;
		case 'R':
		 {
			ast_relational_node_t * node = 
				(ast_relational_node_t*) tree;
			free_ast_tree(node->left);
			free_ast_tree(node->right);
	 }
		break;
		case 'E':
		{
			ast_equality_node_t * node =
				(ast_equality_node_t*) tree;
			free_ast_tree(node->left);
			free_ast_tree(node->right);
		}
		break;
		case 'A':
		{
			ast_assignment_node_t * node =
				(ast_assignment_node_t*) tree;

			free_ast_tree(node->value);
		}
		break;
		default:
			printf("bad node in tree (free)\n");
	}

	free(tree);
}
