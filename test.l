%option noyywrap
%{
#include "test.h"
%}
%%

[\t ]+ /* ignore whitespace */

 
function {return FUNCTION;}
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



";" {return SEMI;}


"\+" {return ADD;}
"\-" {return SUBT;}
"\*" {return MULT;}
"/"  {return DIV;}
"\=" {return ASSGN;} 
"!"  {return NOT;}
"&&" {return AND;}
"||" {return OR;}
"==" {return EQ;}
"!=" {return NOTEQ;}
"<"  {return LESS;} 
">"  {return GRAT;}
"<=" {return LEEQ;}
">=" {return GREQ;}
"("  {return LPAR;}
")"  {return RPAR;}	



[a-zA-Z][a-zA-Z0-9]* {return VAR;}



.+ {printf("%s is invalid syntax\n", yytext);}

.|\n      {ECHO;  /* default */ }

%%
 
main() {
yylex();
}

