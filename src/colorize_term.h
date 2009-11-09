
#ifndef __COLORIZE_TERM_H__
#define __COLORIZE_TERM_H__

#include <colorit.h>

void print_term(FILE *file, const char *text, colorizer_status status);
colorizer *get_color_term();

#endif

