#define VARLEN 100
#define SYMTABLE_LEN 100
//a type that a value can have for a symbol 
typedef enum symboltype {
        INT_T, VOID_T, DOUBLE_T, BOOLEAN_T, STRING_T, PTR_T, FUNCTION_T, CHAR_T
} symboltype_t;

struct symbol_node {
	char valid;
	char * name;
	symboltype_t type;
	char enforce_type; 
	size_t valsize;
	void * val;
};

struct ast_node {
	int node_type;
	struct ast_node * left;
	struct ast_node * right;
};

struct ast_root_node {
	int node_type;
	struct ast_node * payload;
	struct ast_node * next; 
};


struct ast_relational_node {
	        int node_type;
		char operator;
		struct ast_node * left;
		struct ast_node * right;
};

struct ast_equality_node {
	        int node_type;
		char operator;
		struct ast_node * left;
		struct ast_node * right; 
};

struct ast_assignment_node {
	int node_type; 
	symboltype_t type;
	struct ast_symbol_reference_node * symbol;
	struct ast_node * value; 
};

struct ast_number_node {
	int node_type;
	symboltype_t type;
	double value;
};


struct ast_symbol_reference_node {
	int node_type;
	struct symbol_node * symbol;
};

struct ast_typecheck_node {
	int node_type; 
	symboltype_t typecheck;
	struct symbol_node * symbol;
};

struct ast_function_node {
	int node_type; 
	symboltype_t retval;
	size_t typelist_size;
	struct ast_node * body; 
	struct ast_node * param; 
	struct ast_typecheck_node * typelist;
};


struct ast_string_node {
	int node_type;
	char * str; 
};

struct ast_typelist_node {
	int node_type;
	struct ast_typelist_node * next;
	struct ast_typelist_node * first;
	struct ast_typecheck_node * type; 
};



typedef struct symbol_node symbol_t;
typedef struct ast_node ast_node_t;
typedef struct ast_relational_node ast_relational_node_t; 
typedef struct ast_equality_node ast_equality_node_t;
typedef struct ast_assignment_node ast_assignment_node_t;
typedef struct ast_number_node ast_number_node_t;
typedef struct ast_symbol_reference_node ast_symbol_reference_node_t;
typedef struct ast_function_node ast_function_node_t;
typedef struct ast_typecheck_node ast_typecheck_node_t;
typedef struct ast_string_node ast_string_node_t;
typedef struct ast_typelist_node ast_typelist_node_t; 
typedef struct ast_root_node ast_root_node_t; 
typedef enum equality_operator equality_operator_t;
typedef enum relational_operator relational_operator_t;
// symbol table
symbol_t * symbols[SYMTABLE_LEN];

ast_node_t * new_ast_node(int,ast_node_t*, ast_node_t*);
ast_node_t * new_ast_relational_node(char, ast_node_t*,ast_node_t*);
ast_node_t * new_ast_equality_node(char,ast_node_t*,ast_node_t*);
ast_node_t * new_ast_symbol_reference_node(struct symbol_node*);
ast_node_t * new_ast_assignment_node(ast_symbol_reference_node_t*, ast_node_t*);
ast_node_t * new_ast_number_node(double, symboltype_t);
ast_node_t * new_ast_function_node(symboltype_t, ast_node_t*, ast_node_t*);
ast_node_t * new_ast_typecheck_node(symboltype_t, symbol_t*);
ast_node_t * new_ast_string_node(char * str);
ast_node_t * new_ast_typelist_node(ast_typecheck_node_t*);
ast_node_t * new_ast_root_node(ast_node_t*);
void root_node_add(ast_root_node_t*,ast_node_t*);
void typelist_add(ast_typelist_node_t*,ast_typecheck_node_t*);
void free_ast_tree(ast_node_t*);
void print_ast_tree(ast_node_t*);
void free_symbol_table(symbol_t **);
int hs_safe_free(void*);
ast_root_node_t * root; 
