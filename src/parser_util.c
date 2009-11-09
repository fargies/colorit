
#include <string.h>

#include "parser_util.h"

char *putil_strconcat(char *a, char *b)
{
  if (!b) {
    return strdup(a);
  } else {
    char *res = malloc(strlen(a) + strlen(b) + 1);
    strcpy(res, a);
    strcat(res, b);
    return res;
  }
}

