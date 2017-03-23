#include <stdlib.h>
#include <malloc.h>
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
