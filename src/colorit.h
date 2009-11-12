
#ifndef __COLORIT_H__
#define __COLORIT_H__

#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

#include <stdio.h>

#define LIBCOLORIT_TERM "libcolorit-term.so"

typedef enum {
    COL_GCC_CMD,
    COL_GCC_LOG,
    COL_MAKE,
    COL_EMERGE,
    COL_LIBTOOL,
    COL_TOTAL_NUMBER,
} colorizer_type;

typedef enum {
    STATUS_INFO,
    STATUS_WARNING,
    STATUS_ERROR,
    STATUS_NONE,
    STATUS_RESET,
} colorizer_status;

typedef void (*colorizer)(FILE *, const char *, colorizer_status);

typedef struct {
    yyscan_t  scaninfo;
    FILE *out;
    void (*print)(FILE *, const char *, colorizer_status);
    colorizer col[COL_TOTAL_NUMBER];
    colorizer_type col_type;
} colorit_data;

int colorit_init(colorit_data *data, const char *libname);

// Define those one to check prototypes when compiling outputs
colorizer *get_colorizer(colorizer_type type);
colorizer *get_default_colorizer();

#endif

