
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
end      |
go     {printf("%s: is a real word\n", yytext);}

[a-zA-Z]+ { printf("%s is not a real word\n", yytext);}

.|\n      {ECHO;  /* default */ }

%%

main() {
yylex();
}

