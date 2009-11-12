%pure-parser

%parse-param { colorit_data *pp }


%union
{     
  int ival;
  char *sval;
}

%{

#include <string.h>
#include <stdio.h>

#include "lexer.h"
#include "colorit.h"
#include "parser_util.h"

#define YYLEX_PARAM pp->scaninfo

void yyerror(colorit_data *pp, const char *s);

#define COLORIZE(type,txt,status) pp->col[type](pp->out,txt,status)
#define COLORIZE_DEF(txt, status) pp->print(pp->out,txt,status)

#ifdef COLORIT_YYDEBUG
yydebug=1;

static void print_token_value (FILE *, int, YYSTYPE);
#define YYPRINT(file, type, value) print_token_value (file, type, value)

#endif

%}

// Tokens de contexte
%token GCC_CMD    "GCC cmd"
%token GCC_LOG    "GCC log"
%token MAKE       "MAKE cmd"
%token EMERGE     "EMERGE log"
%token LIBTOOL    ""

// Tokens propres a GCC
%token <sval> GCC_COMPILER "compiler"
%token <sval> GCC_OPTIM "optim"
%token <sval> GCC_LIB   "lib"

// Tokens generiques
%token <sval> WARNING  "warning"
%token <sval> ERROR    "error"
%token <sval> INFO     "info"

%token <sval> LINE     "line"
%token <sval> FILENAME "filename"
%token <sval> WORD     "word"
%token <sval> TS       "space"
%token EOL

%start logs
%%
logs:
| logs log
| error EOL { yyerrok; }

log: EOL    { COLORIZE_DEF("\n", STATUS_NONE); }
| words EOL {
                  if ($<sval>1) {
                    COLORIZE_DEF($<sval>1, STATUS_NONE);
                    COLORIZE_DEF("\n", STATUS_NONE);
                    free($<sval>1);
                  }
             }
| GCC_LOG gcc_log EOL   { COLORIZE(COL_GCC_LOG, "\n", STATUS_RESET); }
| GCC_CMD gcc_cmd EOL   { COLORIZE(COL_GCC_CMD, "\n", STATUS_RESET); }
| MAKE make_cmd EOL     { COLORIZE(COL_MAKE, "\n", STATUS_RESET); }
| EMERGE emerge_cmd EOL { COLORIZE(COL_EMERGE, "\n", STATUS_RESET); }
;

gcc_cmd:
| gcc_cmd INFO          { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_INFO); free($<sval>2); }
| gcc_cmd word          { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2); }
;

gcc_log:
| gcc_log INFO     { COLORIZE(COL_GCC_LOG, $<sval>2, STATUS_INFO); free($<sval>2); }
| gcc_log WARNING  { COLORIZE(COL_GCC_LOG, NULL, STATUS_WARNING);  COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2);}
| gcc_log ERROR    { COLORIZE(COL_GCC_LOG, NULL, STATUS_ERROR);  COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2);}
| gcc_log word     { COLORIZE(COL_GCC_LOG, $<sval>2, STATUS_NONE); free($<sval>2); }
;

make_cmd: 
| make_cmd ERROR    { COLORIZE(COL_MAKE, NULL, STATUS_ERROR);  COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2);}
| make_cmd word     { COLORIZE(COL_MAKE, $<sval>2, STATUS_NONE); free($<sval>2); }
;

emerge_cmd: 
| emerge_cmd INFO    { COLORIZE(COL_EMERGE, $<sval>2, STATUS_INFO); free($<sval>2); } 
| emerge_cmd ERROR   { COLORIZE(COL_EMERGE, $<sval>2, STATUS_ERROR); free($<sval>2); } 
| emerge_cmd word    { COLORIZE(COL_EMERGE, $<sval>2, STATUS_NONE); free($<sval>2); } 
;

word: WORD { $<sval>$ = $<sval>1; }
| TS       { $<sval>$ = $<sval>1; }

words: { $<sval>$ = NULL; }
| words TS
{
  $<sval>$ = putil_strconcat($<sval>1, $<sval>2);
  if ($<sval>1)
    free($<sval>1);
  if ($<sval>2)
    free($<sval>2);
}
| words WORD
{
  $<sval>$ = putil_strconcat($<sval>1, $<sval>2);
  if ($<sval>1)
    free($<sval>1);
  if ($<sval>2)
    free($<sval>2);
}
;

%%

void yyerror(colorit_data *pp, const char *s)
{
  fprintf(stderr, "colorit: %s\n", s);
}

#ifdef COLORIT_YYDEBUG
static void print_token_value (FILE *file, int type, YYSTYPE value)
{
  switch (type) {
    case INFO:
    case WARNING:
    case ERROR:
    case WORD:
    case TS:
      fprintf(file, "%s", value.sval);
      break;
  }
}
#endif

