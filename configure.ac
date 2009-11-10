# Version minimale d'autoconf requise
AC_PREREQ(2.59)
AC_INIT(colorit, 1.0.0, fargier.sylvain@free.fr)
# AC_CANONICAL_SYSTEM
AM_INIT_AUTOMAKE
AM_CONFIG_HEADER(config.h)
 
# Checks for programs.
AC_PROG_CC
AM_PROG_LEX
AC_PROG_YACC

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
