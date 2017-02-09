
%option noyywrap
%{



%}
%%


[\t ]+ /* ignore whitespace */;


function |
pointer  |
tained   |
double   |
int      |
for      |
call     |
array    |
boolean  |
true     |
false    |
string   |
char     |
void     |
return   |
cblock   |
header   |
if       |
else     |
end       {printf("%s: is a keyword\n", yytext);}

[a-zA-Z][a-zA-Z0-9]* {printf("%s is a variable\n",yytext);}


.+ {printf("%s is invalid syntax\n", yytext);}

.|\n      {ECHO;  /* default */ }

%%

main() {
yylex();
}

