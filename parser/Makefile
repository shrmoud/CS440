
OBJS = main.o scanner.o parser.o ast.o
CC = gcc
CFLAGS = -g -Wall

all: hc

hc: ${OBJS}
	${CC} ${CFLAGS} ${OBJS} -o hc -lfl 


main.o: main.c
	${CC} ${CFLAGS} -c main.c -o main.o 

scanner.o: scanner.c
	${CC} ${CFLAGS} -c scanner.c -o scanner.o

scanner.c: scanner.l parser.o ast.o
	flex scanner.l
	cp lex.yy.c scanner.c

ast.o: ast.c
	${CC} ${CFLAGS} -c ast.c -o ast.o

parser.o: parser.c ast.o
	${CC} ${CFLAGS} -c parser.c -o parser.o

parser.c: parser.y
	bison -d -v parser.y
	cp parser.tab.c parser.c
	cmp -s parser.tab.h tok.h || cp parser.tab.h tok.h

clean: 
	rm -f *.o
	rm -f lex.yy.c
	rm -f parser.tab.h
	rm -f parser.tab.c
	rm -f hc
	rm -f parser.output
