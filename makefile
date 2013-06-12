# we can set this in the environment or hard code it here
QA_MYSQL_HOME := /home/prabinb/Downloads/source/mysql-5.6.10/
export QA_MYSQL_HOME

QA_JSONCPP_HOME := /home/prabinb/Downloads/source/jsoncpp-src-0.5.0/
export QA_JSONCPP_HOME

HTTPD_HOME := /usr/local/

QA_HOME := /home/prabinb/queralyzer/
export QA_HOME

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/include 
lib      := $(QA_MYSQL_HOME)/libmysqld 
parserlib :=  $(QA_HOME)/lib

CPP      := g++
CPPFLAGS := -I$(inc) -I$(HTTPD_HOME)/include -D_THREAD_SAFE -D_REENTRANT -D__cplusplus -fpermissive 
CFLAGS   := -g -W -Wall
LDFLAGS  := -static-libgcc 
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS   := -L$(lib) -L$(parserlib) -L$(HTTPD_HOME)/lib -L$(QA_JSONCPP_HOME)/libs/linux-gcc-4.7/ -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt -lqparser -lhttpd -ljson_linux-gcc-4.7_libmt -lqjsonserializer

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
	cd ./jsonparser && make -f ./makefile
	cd ./parser && make -f ./makefile
	cd ./plugin && make -f ./makefile
	$(CPP) $(LDFLAGS) sql_repl.o q_httpdserver.o $(LDLIBS) -o $@

# This works for simple one-file test programs
#sources := $(wildcard *.c)
#objects := $(patsubst %c,%o,$(sources))
#targets := $(basename $(sources))

all: $(targets)
clean: 
	rm -f sql_repl *.o *.core
	cd ./plugin && make clean
	cd ./jsonparser && make clean
	cd ./parser && make cleanall
