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

#define COLORIZE(type,txt,status) pp->col[type]->print(pp->out,txt,status)
%}

%token GCC_CMD    "GCC cmd"
%token GCC_LOG    "GCC log"
%token <sval> GCC_COMPILER "compiler"
%token <sval> GCC_OPTIM "optim"

%token <sval> WARNING  "warning"
%token <sval> ERROR    "error"
%token <ival> LINE     "line"
%token <sval> FILENAME "filename"
%token <sval> WORD
%token <sval> TS
%token <sval> LIB
%token <sval> INCLUDE
%token <sval> OPTIM
%token EOL

%start log
%%
log:
| log EOL
| log words EOL {
                  if ($<sval>2) {
                    pp->print(pp->out, $<sval>2, STATUS_NONE);
                    pp->print(pp->out, "\n", STATUS_NONE);
                    free($<sval>2);
                  }
                  fflush(pp->out);
                }
| log GCC_LOG gcc_log EOL { COLORIZE(COL_GCC_LOG, "\n", STATUS_RESET); fflush(pp->out); }
| log GCC_CMD gcc_cmd EOL { COLORIZE(COL_GCC_CMD, "\n", STATUS_RESET); fflush(pp->out); }
;

gcc_cmd: GCC_COMPILER   { COLORIZE(COL_GCC_CMD, $<sval>1, STATUS_INFO); free($<sval>1); }
| gcc_cmd GCC_OPTIM      { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_INFO); free($<sval>2); }
| gcc_cmd WORD           { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2); }
| gcc_cmd TS             { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2); }
;


gcc_log: FILENAME { COLORIZE(COL_GCC_LOG, $<sval>1, STATUS_INFO); free($<sval>1); }
| gcc_log LINE     { COLORIZE(COL_GCC_LOG, $<sval>2, STATUS_INFO); free($<sval>2); }
| gcc_log WARNING  { COLORIZE(COL_GCC_LOG, NULL, STATUS_WARNING);  COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2);}
| gcc_log ERROR    { COLORIZE(COL_GCC_LOG, NULL, STATUS_ERROR);  COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2);}
| gcc_log TS       { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2); }
| gcc_log WORD     { COLORIZE(COL_GCC_CMD, $<sval>2, STATUS_NONE); free($<sval>2); }
;

words: WORD { $<sval>$ = $<sval>1; }
| TS { $<sval>$ = $<sval>1; }
| words TS
| words WORD
{
  $<sval>$ = putil_strconcat($<sval>1, $<sval>2);
  free($<sval>1);
  if ($<sval>2)
    free($<sval>2);
}
;

%%

void yyerror(colorit_data *pp, const char *s)
{
  fprintf(stderr, "%s\n", s);
}

