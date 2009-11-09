
%union
{     
  int ival;
  char *sval;
}

%{

void yyerror(const char *s);

#include <string.h>
#include <stdio.h>

#include "parser_util.h"

%}

%token GCC_CMD    "GCC cmd"
%token GCC_LOG    "GCC log"
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
| words log { printf("%s\n", $<sval>1); }
| GCC_LOG gcc_logs log
| GCC_CMD gcc_cmd log
;

gcc_cmd:
| WORD gcc_cmd
| TS gcc_cmd
| LIB gcc_cmd
| INCLUDE gcc_cmd
| OPTIM gcc_cmd
;


gcc_logs: 
| gcc_start_line TS WARNING words EOL
;

words: { $<sval>$ = NULL; }
| TS words
{
  $<sval>$ = putil_strconcat($<sval>1, $<sval>2);
  free($<sval>1);
  if ($<sval>2)
    free($<sval>2);
}
| WORD words
{
  $<sval>$ = putil_strconcat($<sval>1, $<sval>2);
  free($<sval>1);
  if ($<sval>2)
    free($<sval>2);
}
;

gcc_notif:
  gcc_start_line ' ' WARNING ':' words EOL

gcc_start_line:
  FILENAME ':' LINE ':' { printf("%s\n", $1); }
| FILENAME ':'

%%

void yyerror(const char *s)
{
  fprintf(stderr, "%s\n", s);
}

