%option noyywrap nodefault yylineno reentrant bison-bridge

%option header-file="lexer.h"

%{
#include "parser.h"

#include <string.h>
#include <ctype.h>

#define yysval yylval->sval
#define yyival yylval->ival

typedef void * colorit_data;

/* Use this to force the lexer to be interactive */
inline int isatty (int __fd) { return 1; } 

%}

%s L_GCC_CMD
%s L_GCC_LOG
%x L_GCC_LOG_START
%s L_MAKE
%s L_EMERGE
%s L_LT
%s L_LT_GCC L_LT_INSTALL

WARNING warning(:)?
ERROR   error(:)?
NUMBER      [0-9]+
WORD        [^[:space:]\n]+
TS          [ \t]+

GCC_OPTIM   (-g(gdb3)?|-O([0-3]|s)|(-march|-mtune)=[[:alnum]]*)
GCC_LIB     ({WORD}\.la|-l{WORD})

EMERGE_INFO (Emerging|{WORD}ing[ \t]source|Source[ \t]{WORD}ed|Test[ \t]phase|Completed[ \t]installing)

%%
%{
    colorit_data *pp = yyextra;
%}

<INITIAL>^[^[:space:]\n]*cc[[:space:]].* { BEGIN(L_GCC_CMD); yyless(0); return GCC_CMD; }
<INITIAL>^make(\[[0-9]+\])?:.*           { BEGIN(L_MAKE); yyless(0); return MAKE; }
<INITIAL>^libtool:.*                     { BEGIN(L_LT); yyless(0); return LIBTOOL; }
<INITIAL>^{WORD}:.*                      { BEGIN(L_GCC_LOG_START); yyless(0); return GCC_LOG; }
<INITIAL>^(>>>|!!!){TS}.*                { BEGIN(L_EMERGE); yyless(0); return EMERGE; }

<L_GCC_CMD,L_LT_GCC>(({WORD}-)*g?|dist)?cc[ \t\n] {
    yyless(yyleng - 1);
    yysval = strndup(yytext, yyleng);
    return INFO;
  }

<L_GCC_CMD,L_LT_GCC>{GCC_LIB}   {
    yysval = strdup(yytext);
    return INFO;
  }

<L_GCC_CMD,L_LT_GCC>{GCC_OPTIM} {
    yysval = strdup(yytext);
    return INFO;
  }

<L_GCC_LOG_START>{NUMBER}: {
    yyless(yyleng - 1);
    yysval = strdup(yytext);
    return INFO;
  }

<L_GCC_LOG_START>[^[:space:]\n:]+: {
    yyless(yyleng - 1);
    yysval = strdup(yytext); return INFO;
  }

<L_GCC_LOG_START>":" {
    yysval = strdup(yytext); return WORD;
  }

<L_GCC_LOG_START>.|\n {
    yyless(0);
    BEGIN(L_GCC_LOG);
  }

<L_GCC_LOG,L_LT_INSTALL>{WARNING}.* {
    yysval = strdup(yytext);
    return WARNING;
  }
<L_GCC_LOG>{ERROR}.* {
    yysval = strdup(yytext);
    return ERROR;
  }

<L_MAKE>\*\*\*.* {
    yysval = strdup(yytext);
    return ERROR;
  }

<L_EMERGE>{EMERGE_INFO} {
    yysval = strdup(yytext);
    return INFO;
  }

<L_EMERGE>!!![ \t].* {
    yysval = strdup(yytext);
    return ERROR;
  }

<L_LT>(compile|link): {
    yyless(yyleng - 1);
    yysval = strdup(yytext);
    BEGIN(L_LT_GCC);
    return WORD;
  }

<L_LT>install: {
    yyless(yyleng - 1);
    yysval = strdup(yytext);
    BEGIN(L_LT_INSTALL);
    return WORD;
  }

{TS}     { yysval = strdup(yytext); return TS; }
{WORD}|. { yysval = strdup(yytext); return WORD; }
\n       { BEGIN(INITIAL); return EOL; } 

%%

