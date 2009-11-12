#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..
[ -n "$abs_top_srcdir" ] || abs_top_srcdir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)


cat ${abs_top_srcdir}/tests/sample_scanner1.txt | ${abs_top_builddir}/src/colorit > $TMPDIR 2>&1

grep 'flex scanner jammed' $TMPDIR && die "FAILED: scanner jammed"

rm $TMPDIR

exit 0

