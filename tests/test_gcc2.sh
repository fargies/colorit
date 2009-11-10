#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)

echo "gcc" | ${abs_top_builddir}/src/colorit > $TMPDIR

awk '/\033\[1\;34mgcc\033\[0m/ { exit 1 }' $TMPDIR && die "FAILED: gcc not highlighted"

# This one won't work with our grammar :(
#echo -n "gcc" | ${abs_top_builddir}/src/colorit > $TMPDIR

#awk '/\033\[1\;34mgcc\033\[0m/ { exit 1 }' $TMPDIR && die "FAILED: gcc not highlighted(2)"

rm $TMPDIR

exit 0
