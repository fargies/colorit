#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)

echo -n "gcc -02" | ${abs_top_builddir}/src/colorit > $TMPDIR 2>&1

grep 'flex scanner jammed' $TMPDIR && die "FAILED: scanner jammed"
grep 'syntax error' $TMPDIR && die "FAILED: syntax error"

rm $TMPDIR

exit 0

