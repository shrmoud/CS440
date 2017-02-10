%{
#include "test.h"
%}
%%

 
function {printf("FUNCTION ");}
pointer  {printf("POINTER ");}
tained   {printf("TAINTED ");}
double   {printf("DOUBLE ");}
int      {printf("INT ");}
for      {printf("FOR ");}
call     {printf("CALL ");}
array    {printf("ARRAY ");}
boolean  {printf("BOOLEAN ");}
true     {printf("TRUE ");}
false    {printf("FALSE ");}
string   {printf("STRING ");}
char     {printf("CHAR ");}
void     {printf("VOID ");}
return   {printf("RETURN ");}
cblock   {printf("CBLOCK ");}
header   {printf("HEADER ");}
if       {printf("IF ");}
else     {printf("ELSE ");}
end      {printf("END ");}



";" {printf("SEMI ");}


"\+" {printf("ADD ");}
"\-" {printf("SUBT ");}
"\*" {printf("MULT ");}
"/"  {printf("DIV ");}
"\=" {printf("ASSGN ");} 
"!"  {printf("NOT ");}
"&&" {printf("AND ");}
"||" {printf("OR ");}
"==" {printf("EQ ");}
"!=" {printf("NOTEQ ");}
"<"  {printf("LESS ");} 
">"  {printf("GRAT ");}
"<=" {printf("LEEQ ");}
">=" {printf("GREQ ");}
"("  {printf("LPAR ");}
")"  {printf("RPAR ");}	

[0-9]+\.?[0-9]* {printf("NUMBER ");}

[a-zA-Z][a-zA-Z0-9]* {printf("VAR ");}

[ \t\n]+ /* ignore whitespace */


.      {ECHO;  /* default */ }

%%
 
main(int argc, char **argv) {
    
    {
	++argv, --argc;  /* skip over program name */
	if ( argc > 0 )
	    yyin = fopen( argv[0], "r" );
	else
            yyin = stdin;
	
	yylex();
	printf("\n");
    }
}

