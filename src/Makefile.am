
bin_PROGRAMS = colorit

BUILT_SOURCES = parser.c parser.h lexer.h
CLEANFILES = ${BUILT_SOURCES}
AM_YFLAGS = -d -r all

lexer.h: lexer.l
	$(am__skiplex) $(SHELL) $(YLWRAP) $< $@ $@ -- $(LEXCOMPILE)

colorit_SOURCES = parser.y lexer.l main.c parser_util.h parser_util.c colorit.h colorize_term.h colorize_term.c

