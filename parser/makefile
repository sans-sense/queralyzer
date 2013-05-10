# plain simple makefile to build qparsertest

CXX = g++
LEX = flex
YACC = bison

CXXFLAGS = -W -Wall -Wextra -ansi -g
LDFLAGS = 

HEADERS = q_table.h q_parser.h

all: qparsertest

# Generate scanner and parser

q_parser.cc: q_parser.yy
	$(YACC) -o q_parser.cc --defines=q_parser.h q_parser.yy

q_scanner.cc: q_scanner.ll
	$(LEX) -o q_scanner.cc q_scanner.ll

# Implicit rule to compile c++ files

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Link executable

qparsertest: qparsertest.o q_parser.o q_scanner.o
	$(CXX) $(LDFLAGS) -o $@ qparsertest.o q_parser.o q_scanner.o 

clean:
	rm -f qparsertest *.o

cleanall: clean
	rm -f q_parser.cc q_parser.h q_scanner.cc
