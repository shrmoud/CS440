struct ast_node {
	int node_type;
	struct ast_node * left;
	struct ast_node * right;
};

enum relational_operator {
	        LESSTHAN, LESS_OR_EQUAL, GREATERTHAN, GREATER_OR_EQUAL
};


enum equality_operator {
	        EQUAL, NOT_EQUAL
};

struct ast_relational_node {
	        int node_type;
		enum relational_operator operator;
		struct ast_node * left;
		struct ast_node * right;
};

struct ast_equality_node {
	        int node_type;
		enum equality_operator operator;
		struct ast_node * left;
		struct ast_node * right; 
};



typedef struct ast_node ast_node_t;
typedef struct ast_relational_node ast_relational_node_t; 
typedef struct ast_equality_node ast_equality_node_t;
typedef enum equality_operator equality_operator_t;
typedef enum relational_operator relational_operator_t;
