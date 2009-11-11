# Version minimale d'autoconf requise
AC_PREREQ(2.59)
AC_INIT(colorit, 1.0.0, fargier.sylvain@free.fr)
# AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER(config.h)

AC_CONFIG_MACRO_DIR([m4])
 
# Checks for programs.
AC_PROG_CC
AC_PROG_LIBTOOL
AM_PROG_LEX
AC_PROG_YACC

AM_PROG_CC_C_O

AC_CHECK_LIB([dl], [dlopen], DL_LIBS="-ldl", AC_MSG_ERROR([libdl was not found !]))

AC_SUBST(DL_LIBS)

AC_ARG_ENABLE(yydebug, AS_HELP_STRING([--enable-yydebug],
                                      [Activate lexer's debug (default: disabled)]
                                     ),
              [yydebug=$enableval], [yydebug=no])
 
AM_CONDITIONAL(COLORIT_YYDEBUG, [test "x$yydebug" = xyes]) 

AC_CONFIG_FILES([
        Makefile
        src/Makefile
        tests/Makefile])
 
AC_OUTPUT
