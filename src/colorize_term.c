
#include <stdio.h>
#include "colorit.h"
#include "colorize_term.h"
#if 0
#define INFO    "\033[1;30;46m"
#define WARNING "\033[1;30;43m"
#define ERROR   "\033[1;30;41m"
#define RESET   "\033[0m"

#else
#define INFO    "\033[1;34m"
#define WARNING "\033[1;33m"
#define ERROR   "\033[1;31m"
#define RESET   "\033[0m"
#endif

void print_term(FILE *file, const char *text, colorizer_status status)
{
  switch (status) {
    case STATUS_INFO:
      fprintf(file, INFO);
      break;
    case STATUS_WARNING:
      fprintf(file, WARNING);
      break;
    case STATUS_ERROR:
      fprintf(file, ERROR);
      break;
    case STATUS_RESET:
      fprintf(file, RESET);
      break;
  };
  if (text) {
    fprintf(file, text);
    if (status != STATUS_NONE)
      fprintf(file, RESET);
  }
}

colorizer *get_color_term(colorizer_type type) {
  colorizer *col = malloc(sizeof (colorizer));
  col->print = print_term;
  col->data = NULL;
  return col;
}

