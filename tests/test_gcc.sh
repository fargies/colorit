#!/bin/bash
CURR_PATH=$(cd $(dirname $0) ; pwd)

echo "
x86_64-pc-linux-gnu-gcc -O2 -I/usr/include test.c -o test.o -march=nocona
gcc test.c -o test

" | ${CURR_PATH}/../src/colorit

