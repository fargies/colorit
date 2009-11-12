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
%token LIBTOOL    "LIBTOOL cmd"

%token <sval> WARNING  "warning"
%token <sval> ERROR    "error"
%token <sval> INFO     "info"

%token <sval> WORD     "word"
%token <sval> TS       "space"
%token EOL

%start logs
%%
logs: 
| logs words EOL {
    if ($<sval>2) {
      COLORIZE_DEF($<sval>2, STATUS_NONE);
      COLORIZE_DEF("\n", STATUS_NONE);
      free($<sval>2);
    }
  }
| logs error EOL { yyerrok; }
| logs log_type log_txt EOL { COLORIZE(pp->col_type, "\n", STATUS_RESET); }
;

log_type:
  GCC_LOG { pp->col_type = COL_GCC_LOG; }
| GCC_CMD { pp->col_type = COL_GCC_CMD; }
| MAKE    { pp->col_type = COL_MAKE; }
| EMERGE  { pp->col_type = COL_EMERGE; }
| LIBTOOL { pp->col_type = COL_LIBTOOL; }
;

log_txt:
| log_txt INFO     { COLORIZE(pp->col_type, $<sval>2, STATUS_INFO); free($<sval>2); }
| log_txt WARNING  { COLORIZE(pp->col_type, $<sval>2, STATUS_WARNING); free($<sval>2);}
| log_txt ERROR    { COLORIZE(pp->col_type, $<sval>2, STATUS_ERROR); free($<sval>2);}
| log_txt word     { COLORIZE(pp->col_type, $<sval>2, STATUS_NONE); free($<sval>2); }
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

