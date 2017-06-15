# YACCFLAGS=-Wall
DEBUG=--debug --verbose
trans: lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c -ll -ly -o a.out -g -w

lex.yy.c: orion.l y.tab.h
	lex orion.l

y.tab.c: orion.y
	yacc orion.y -d ${YACCFLAGS} ${DEBUG}

y.tab.h: orion.y
	yacc orion.y -d ${YACCFLAGS} ${DEBUG}
