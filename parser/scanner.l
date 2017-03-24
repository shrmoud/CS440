%option nounput
%option noinput
%{
#include <string.h>
#include "tok.h"
#include "ast.h"
%}
W [ \t\n]*
%%

 
function {return FUNCTIONDEF;}
pointer  {return POINTER;}
tained   {return TAINTED;}
double   {return DOUBLE;}
int      {return INT;}
for      {return FOR;}
call     {return CALL;}
array    {return ARRAY;}
boolean  {return BOOLEAN;}
true     {return TRUE;}
false    {return FALSE;}
string   {return STRING;}
char     {return CHAR;}
void     {return VOID;}
return   {return RETURN;}
cblock   {return CBLOCK;}
header   {return HEADER;}
if       {return IF;}
else     {return ELSE;}
end      {return END;}



{W};{W} {return SEMI;}


{W}\+{W} {return ADD;}
{W}\-{W} {return SUBT;}
{W}\*{W} {return MULT;}
{W}"/"{W}  {return DIV;}
{W}"="{W} {return ASSGN;} 
{W}!{W}  {return NOT;}
{W}&&{W} {return AND;}
{W}"||"{W} {return OR;}
{W}"=="{W} {return EQ;}
{W}!={W} {return NOTEQ;}
{W}<{W}  {return LESS;} 
{W}>{W}  {return GRAT;}
{W}<={W} {return LEEQ;}
{W}>={W} {return GREQ;}
{W}"("{W}  {return LPAR;}
{W}")"{W}  {return RPAR;}
{W}":"{W}  {return TCOL;} /* variable type specifier */ 
{W}\".*\"{W}   {return QUOTE;}
{W}\'.\'{W}   {return CHARQUOTE;}

[0-9]+ {ast_number_node_t * n = new_ast_number_node(atoi(yytext));
		yylval.node = n; 
		 return  DECIMAL;}
[0-9]+\.[0-9]+ { ast_number_node_t * n = new_ast_number_node(atoi(yytext));
		yylval.node = n;
		 return NUMBER;}

[a-zA-Z][a-zA-Z0-9]* {
symbol_t * sym = malloc(sizeof(symbol_t));
strcpy(sym->name, yytext); 
sym->valsize = -1;
sym->val = NULL;
ast_symbol_reference_node_t * n = new_ast_symbol_reference_node(sym);
yylval.node = n;
return VAR;}

[ \t\n]+ /* ignore whitespace */


.      {return -1;  /* default */ }

%%
int yywrap (void) { return 1;}
