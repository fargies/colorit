#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)

LD_PRELOAD="${abs_top_builddir}/src/.libs/libcolorit-preload.so" /bin/echo "
x86_64-pc-linux-gnu-gcc -O2 -I/usr/include test.c -o test.o -march=nocona
gcc test.c -o test

" > $TMPDIR

awk '/\033\[1\;34mx86_64-pc-linux-gnu-gcc\033\[0m/ { exit 1 }' $TMPDIR && die "FAILED: gcc not highlighted"
awk '/\033\[1\;34m-O2\033\[0m/ { exit 1 }' $TMPDIR && die "FAILED: optim not highlighted"

rm $TMPDIR

exit 0

