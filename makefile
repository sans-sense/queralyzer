# we can set this in the environment or hard code it here
QA_MYSQL_HOME := /home/prabinb/Downloads/source/mysql-5.6.10/
HTTPD_HOME := /usr/local/

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/include 
lib      := $(QA_MYSQL_HOME)/libmysqld 
parserlib :=  /home/prabinb/queralyzer/lib

CPP      := g++
CPPFLAGS := -I$(inc) -I$(HTTPD_HOME)/include -D_THREAD_SAFE -D_REENTRANT -D__cplusplus -fpermissive 
CFLAGS   := -g -W -Wall 
LDFLAGS  := -static-libgcc 
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS   := -L$(lib) -L$(parserlib) -L$(HTTPD_HOME)/lib -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt -lqparser -lhttpd -ljson_linux-gcc-4.7_libmt -lqjsonserializer

ifneq (,$(shell grep FreeBSD /COPYRIGHT 2>/dev/null))
# FreeBSD
LDFLAGS += -pthread
else
# Assume Linux
LDLIBS += -lpthread
endif

all: sql_repl

sql_repl.o: sql_repl.cpp
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

q_httpdserver.o: q_httpdserver.c
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

sql_repl: sql_repl.o q_httpdserver.o 
	$(CPP) $(LDFLAGS) sql_repl.o q_httpdserver.o $(LDLIBS) -o $@

# This works for simple one-file test programs
#sources := $(wildcard *.c)
#objects := $(patsubst %c,%o,$(sources))
#targets := $(basename $(sources))

all: $(targets)
clean: 
	rm -f sql_repl *.o *.core
