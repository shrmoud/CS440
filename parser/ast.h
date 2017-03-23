#define VARLEN 30
#define SYMTABLE_LEN 100

//a type that a value can have for a symbol 
typedef enum {
        INT_T, VOID_T, DOUBLE_T, BOOLEAN_T, STRING_T, PTR_T
} symboltype_t;

struct symbol_node {
	char valid;
	char name[VARLEN];
	symboltype_t type;
	size_t valsize;
	void * val;
};

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

struct ast_assignment_node {
	int node_type; 
	struct symbol_node * symbol;
	struct ast_node * value; 
};

struct ast_number_node {
	int node_type;
	double value;
};


struct ast_symbol_reference_node {
	int node_type;
	struct symbol_node * symbol;
};

typedef struct symbol_node symbol_t;
typedef struct ast_node ast_node_t;
typedef struct ast_relational_node ast_relational_node_t; 
typedef struct ast_equality_node ast_equality_node_t;
typedef struct ast_assignment_node ast_assignment_node_t;
typedef struct ast_number_node ast_number_node_t;
typedef struct ast_symbol_reference_node ast_symbol_reference_node_t;
typedef enum equality_operator equality_operator_t;
typedef enum relational_operator relational_operator_t;

ast_node_t * new_ast_node(int,ast_node_t*, ast_node_t*);
ast_node_t * new_ast_relational_node(relational_operator_t, ast_node_t*,ast_node_t*);
ast_node_t * new_ast_equality_node(equality_operator_t,ast_node_t*,ast_node_t*);
ast_node_t * new_ast_symbol_reference_node(struct symbol_node*);
ast_node_t * new_ast_symbol_assignment_node(struct symbol_node*, ast_node_t*);
ast_node_t * new_ast_number_node(double);
