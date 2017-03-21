
OBJS = main.o 
CC = gcc
CFLAGS = -g -Wall

all: lex

lex: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -o hc -lfl 


main.o: scanner.c
	${CC} ${CFLAGS} -c scanner.c -o main.o

scanner.c: test.l
	flex test.l
	cp lex.yy.c scanner.c


clean: 
	rm -f *.o
	rm -f lex.yy.c
	rm -f parser.tab.h
	rm -f parser.tab.c
	rm -f hc
	rm -f parser.output
