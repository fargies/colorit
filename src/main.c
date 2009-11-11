
#include <stdio.h>
#include <errno.h>

#include "colorit.h"

int main() {
    colorit_data data = { NULL, NULL};

    if (yylex_init_extra(&data, &data.scaninfo)) {
        perror("init alloc failed");
        return -1;
    }
    yyset_in(stdin, data.scaninfo);
    data.out = stdout;

    if (colorit_init(&data, LIBCOLORIT_TERM) != 0) {
      fprintf(stderr, "Can't init %s\n", LIBCOLORIT_TERM);
      return 1;
    }

    return yyparse(&data);
}

