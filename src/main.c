
#include <stdio.h>
#include <errno.h>

#include "colorit.h"
#include "colorize_term.h"

int main() {
    colorit_data data = { NULL, NULL};

    if (yylex_init_extra(&data, &data.scaninfo)) {
        perror("init alloc failed");
        return -1;
    }
    yyset_in(stdin, data.scaninfo);

    data.col[COL_GCC_CMD] = data.col[COL_GCC_LOG] = data.col[COL_MAKE] = data.col[COL_EMERGE] = get_color_term(COL_GCC_CMD);
    data.out = stdout;
    data.print = print_term;

    return yyparse(&data);
}

