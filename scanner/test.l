%{
#include "test.h"
%}
W [ \t\n]*
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



{W};{W} {printf("SEMI ");}


{W}\+{W} {printf("ADD ");}
{W}\-{W} {printf("SUBT ");}
{W}\*{W} {printf("MULT ");}
{W}"/"{W}  {printf("DIV ");}
{W}"="{W} {printf("ASSGN ");} 
{W}!{W}  {printf("NOT ");}
{W}&&{W} {printf("AND ");}
{W}"||"{W} {printf("OR ");}
{W}"=="{W} {printf("EQ ");}
{W}!={W} {printf("NOTEQ ");}
{W}<{W}  {printf("LESS ");} 
{W}>{W}  {printf("GRAT ");}
{W}<={W} {printf("LEEQ ");}
{W}>={W} {printf("GREQ ");}
{W}"("{W}  {printf("LPAR ");}
{W}")"{W}  {printf("RPAR ");}
{W}":"{W}  {printf("TCOL ");} /* variable type specifier */ 
{W}\".*\"{W}      {printf("QUOTE ");}

[0-9]+ {printf("DECIMAL ");}
[0-9]+\.[0-9]+ {printf("NUMBER ");}

[a-zA-Z][a-zA-Z0-9]* {printf("VAR ");}

[ \t\n]+ /* ignore whitespace */


.      {printf("error\n");  /* default */ }

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

