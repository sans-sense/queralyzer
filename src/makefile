# we can set this in the environment or hard code it here
ifndef QA_MYSQL_HOME
  QA_MYSQL_HOME = /home/prabinb/Downloads/source/mysql-5.6.10/
  export QA_MYSQL_HOME
endif

ifndef QA_JSONCPP_HOME
  QA_JSONCPP_HOME = /home/prabinb/Downloads/source/jsoncpp-src-0.5.0/
  export QA_JSONCPP_HOME
endif

#HTTPD_HOME := /usr/local/

ifndef QA_HOME
  QA_HOME = /home/prabinb/queralyzer/
  export QA_HOME
endif

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/include
lib      := $(QA_MYSQL_HOME)/libmysqld 
parserlib := $(QA_HOME)/lib

CPP      := g++
CPPFLAGS := -I$(inc) -I$(QA_MYSQL_HOME)/sql -I$(HTTPD_HOME)/include -D_THREAD_SAFE -D_REENTRANT -fpermissive 
CFLAGS   := -g -W -Wall -fno-elide-constructors 
LDFLAGS  := -static-libgcc 
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS   := -L$(lib) -L$(parserlib) -L$(HTTPD_HOME)/lib -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt -lqparser -lhttpd $(QA_JSONCPP_HOME)/libs/linux-gcc-4.7/libjson_linux-gcc-4.7_libmt.a

ifneq (,$(shell grep FreeBSD /COPYRIGHT 2>/dev/null))
# FreeBSD
LDFLAGS += -pthread
else
# Assume Linux
LDLIBS += -lpthread
endif

all: queralyzer

main.o: http_server.cc
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

embedded_mysql.o: embedded_mysql.cc
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

query.o: query.cc
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

meta_data.o: meta_data.cc
	$(CPP) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

queralyzer: main.o embedded_mysql.o query.o meta_data.o
	cd ./parser && make -f ./makefile
	cd ../plugin && make -f ./makefile
	$(CPP) $(LDFLAGS) main.o embedded_mysql.o query.o meta_data.o $(LDLIBS) -o $@

all: $(targets)
clean: 
	rm -f queralyzer *.o *.core
	cd ../plugin && make clean
	cd ./parser && make cleanall

