
bin_PROGRAMS = colorit

AM_YFLAGS = -d -r all
AM_LFLAGS =

if COLORIT_YYDEBUG
AM_YFLAGS += -t
AM_LFLAGS += -d
colorit_CFLAGS = -DCOLORIT_YYDEBUG
endif

lexer.h: lexer.l
	$(am__skiplex) $(SHELL) $(YLWRAP) $< $@ $@ -- $(LEXCOMPILE)

colorit_SOURCES = parser.y lexer.l main.c parser_util.h parser_util.c colorit.h colorit_init.c
colorit_LDADD = ${DL_LIBS}

lib_LTLIBRARIES = libcolorit-term.la libcolorit-preload.la

libcolorit_term_la_SOURCES = colorize_term.c colorit.h

libcolorit_preload_la_SOURCES = colorit_preload.c parser.y lexer.l parser_util.h parser_util.c colorit.h colorit_init.c
libcolorit_preload_la_LIBADD = ${DL_LIBS}

BUILT_SOURCES = parser.c parser.h lexer.h lexer.c
CLEANFILES = ${BUILT_SOURCES}
