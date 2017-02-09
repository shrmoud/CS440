
%option noyywrap
%{



%}
%%


[\t ]+ /* ignore whitespace */;


function {printf("fdef ");}
pointer  {printf("ptrt ");}
tained   {printf("tant ");}
double   {printf("ddef ");}
int      {printf("idef ");}
for      {printf("forl ");}
call     {printf("call ");}
array    {printf("adef ");}
boolean  {printf("bdef ");}
true     {printf("true ");}
false    {printf("fals ");}
string   {printf("sdef ");}
char     {printf("cdef ");}
void     {printf("void ");}
return   {printf("retu ");}
cblock   {printf("cblk ");}
header   {printf("chdr ");}
if       {printf("ifst ");}
else     {printf("else ");}
end      {printf("ends ");}

; {printf("semi ");}

\+ {printf("oadd ");}
\- {printf("osub ");}



[a-zA-Z][a-zA-Z0-9]* {printf("vari ");}


.+ {printf("%s is invalid syntax\n", yytext);}

.|\n      {ECHO;  /* default */ }

%%
 
main() {
yylex();
}

