%{



%}
%%


[\t ]+ /* ignore whitespace */;

gloop  |
fleep  |
bloorp |
mai    |
go     {printf("%s: is a real word\n", yytext);}

[a-zA-Z]+ { printf"%s is not a real word\n", yytext);}

.|\n      {ECHO;  /* default */ }

%%

main() {
yylex();
}

