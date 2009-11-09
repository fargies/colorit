%option noyywrap nodefault yylineno reentrant bison-bridge

%option header-file="lexer.h"

%{
#include "parser.h"

#include <string.h>
#include <ctype.h>

#define yysval yylval->sval
#define yyival yylval->ival

typedef void * colorit_data;
%}

%s L_GCC_CMD
%s L_GCC_LOG
%x L_GCC_LOG_START
%s L_MAKE

GCC_WARNING warning(:)?
GCC_ERROR   error(:)?
NUMBER      [0-9]+
WORD        [^[:space:]\n]+
TS          [ \t]+

GCC_OPTIM   (-g(gdb3)?|-O([0-3]|s)|(-march|-mtune)=[[:alnum]]*)

%%
%{
    colorit_data *pp = yyextra;
%}

^[^[:space:]\n]*cc[[:space:]].* { BEGIN(L_GCC_CMD); yyless(0); return GCC_CMD; }

^{WORD}:.* { BEGIN(L_GCC_LOG_START); yyless(0); return GCC_LOG; }

<L_GCC_CMD>[^[:space:]\n]*cc[ \t] {
                                    yyless(yyleng - 1);
                                    yysval = strndup(yytext, yyleng);
                                    return GCC_COMPILER;
                                   }
<L_GCC_CMD>{GCC_OPTIM} { yysval = strdup(yytext); return GCC_OPTIM; }

<L_GCC_LOG_START>{NUMBER} {
                            yysval = strdup(yytext); return LINE;
                          }
<L_GCC_LOG_START>[^[:space:]\n:]+ {
                                    yysval = strdup(yytext); return FILENAME;
                                  }
<L_GCC_LOG_START>":" {
                        yysval = strdup(yytext); return WORD;
                     }
<L_GCC_LOG_START>{TS} {
                        yyless(0);
                        BEGIN(L_GCC_LOG);
                      }

<L_GCC_LOG>{GCC_WARNING} { yysval = strdup(yytext); return WARNING; }
<L_GCC_LOG>{GCC_ERROR}   { yysval = strdup(yytext); return ERROR; }

{TS}    { yysval = strdup(yytext); return WORD; }
{WORD}  { yysval = strdup(yytext); return WORD; }
\n      { BEGIN(INITIAL); return EOL; } 


%%

