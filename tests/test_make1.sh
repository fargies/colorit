#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..
[ -n "$abs_top_srcdir" ] || abs_top_srcdir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)


cat ${abs_top_srcdir}/tests/sample1.txt | ${abs_top_builddir}/src/colorit > $TMPDIR

awk '/make\[3\]: \033\[1\;31m\*\*\*.*\033\[0m/ { exit 1 }' $TMPDIR && die "FAILED: make error not highlighted"

rm $TMPDIR

exit 0

