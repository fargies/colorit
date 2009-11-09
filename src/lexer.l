%option noyywrap nodefault

%{
#include "parser.h"

#include <string.h>

#define yysval yylval.sval
#define yyival yylval.ival
%}

%x L_GCC_CMD
%x L_GCC_LOG
%x L_MAKE

GCC_WARNING warning
GCC_ERROR   error
NUMBER      [0-9]+
WORD        [^[:space:]]+
TS          [[:space:]]+

%%

<*>^[^[:space:]]*cc[[:space:]].* { BEGIN(L_GCC_CMD); return GCC_CMD; }


{TS}    { yysval = strdup(yytext); return WORD; }
{WORD}  { yysval = strdup(yytext); return WORD; }
\n      { return EOL; } 

%%

