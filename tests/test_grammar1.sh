#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)

echo 'dc_install_base=`CDPATH="${ZSH_VERSION+.}:" && cd colorit-1.0.0/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \    ' | ${abs_top_builddir}/src/colorit > $TMPDIR 2>&1

grep 'syntax error' $TMPDIR && die "FAILED: syntax error"

rm $TMPDIR

exit 0

