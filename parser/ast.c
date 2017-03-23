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




