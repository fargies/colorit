
dist_check_SCRIPTS = \
	test_gcc.sh \
	test_gcc2.sh \
	test_make1.sh \
	test_preload1.sh \
	test_grammar1.sh \
	test_scanner1.sh \
	test_trash_input1.sh \
	test_trash_input2.sh \
	test_libtool1.sh

TESTS = ${dist_check_SCRIPTS}

TESTS_ENVIRONMENT = LD_LIBRARY_PATH="${abs_top_builddir}/src/.libs" abs_top_srcdir=${abs_top_srcdir} abs_top_builddir=${abs_top_builddir}

EXTRA_DIST = utils.sh sample1.txt

