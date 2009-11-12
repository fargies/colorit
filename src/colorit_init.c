
#include <stdint.h>
#include <dlfcn.h>
#include "colorit.h"

int colorit_init(colorit_data *data, const char *libname) {
    colorizer (*color_getter)(colorize_type);
    uint8_t i;
    void *lib = dlopen(libname, RTLD_NOW);

    data->col_type = 0;

    if (!lib)
        return 1;

    color_getter = dlsym(lib, "get_colorizer");
    if (!color_getter) {
        dlclose(lib);
        return 2;
    }
    for (i = 0; i < COL_TOTAL_NUMBER; ++i) {
        data->col[i] = color_getter(i);
    }
    color_getter = dlsym(lib, "get_default_colorizer");
    if (!color_getter) {
        dlclose(lib);
        return 3;
    }
    data->print = color_getter();

    if (!data->print) {
        return 3;
    }
    return 0;
}

