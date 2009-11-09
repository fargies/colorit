
#ifndef __COLORIT_H__
#define __COLORIT_H__

#ifndef YY_TYPEDEF_YY_SCANNER_T
#define YY_TYPEDEF_YY_SCANNER_T
typedef void* yyscan_t;
#endif

#include <stdio.h>

typedef enum {
    COL_GCC_CMD,
    COL_GCC_LOG,
    COL_MAKE,
    COL_TOTAL_NUMBER,
} colorizer_type;

typedef enum {
    STATUS_INFO,
    STATUS_WARNING,
    STATUS_ERROR,
    STATUS_NONE,
    STATUS_RESET,
} colorizer_status;

typedef struct {
    void (*print)(FILE *, const char *, colorizer_status);
    void *data;
} colorizer;

typedef struct {
    yyscan_t  scaninfo;
    FILE *out;
    void (*print)(FILE *, const char *, colorizer_status);
    colorizer *col[COL_TOTAL_NUMBER];
} colorit_data;

#endif

