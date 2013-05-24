# plain simple makefile to build q_parsertest

OUT = ../lib/libqparser.a

CXX = g++
LEX = flex
YACC = bison

CXXFLAGS = -W -Wall -Wextra -ansi -g
LDFLAGS  = 

HEADERS = q_table.h q_parser.h

all: q_parsertest $(OUT)

# Generate scanner and parser

q_parser.cc: q_parser.yy
	$(YACC) -o q_parser.cc -p "q_sql_" --defines=q_parser.h q_parser.yy

q_scanner.cc: q_scanner.ll
	$(LEX) -o q_scanner.cc -P "q_sql_" q_scanner.ll

# Implicit rule to compile c++ files

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

$(OUT): q_parser.o q_scanner.o
	ar rcs $(OUT) q_parser.o q_scanner.o

# Link executable

q_parsertest: q_parsertest.o q_parser.o q_scanner.o
	$(CXX) $(LDFLAGS) -o $@ q_parsertest.o q_parser.o q_scanner.o 

clean:
	rm -f q_parsertest *.o $(OUT) 

cleanall: clean
	rm -f q_parser.cc q_parser.h q_scanner.cc
