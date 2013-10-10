# we can set this in the environment or hard code it here
#QA_MYSQL_HOME := /home/prabinb/Downloads/source/mysql-5.6.10/
ifndef QA_JSONCPP_HOME
  QA_JSONCPP_HOME = /home/prabinb/Downloads/source/jsoncpp-src-0.5.0/
  export QA_JSONCPP_HOME
endif

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/sql $(QA_MYSQL_HOME)/include $(QA_MYSQL_HOME)/regex $(QA_MYSQL_HOME)/extra/yassl/include $(QA_MYSQL_HOME)/extra/yassl/taocrypt/include $(QA_MYSQL_HOME)/zlib
lib      := $(QA_MYSQL_HOME)/libmysqld
inc_params=$(foreach d, $(inc), -I$d)

CC       := g++
CPPFLAGS := $(inc_params) -fPIC -Wall -Wno-unused-parameter -Wall -Wextra -Wunused -Wwrite-strings -Wno-strict-aliasing -Woverloaded-virtual -g -fabi-version=2 -fno-omit-frame-pointer -fno-strict-aliasing -DENABLED_DEBUG_SYNC -D_THREAD_SAFE -DSAFE_MUTEX -D_REENTRANT  -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN -fno-rtti
#CXX_DEFINES = -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN
CFLAGS   := 
LDFLAGS  := -static-libgcc 
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS    = -L$(lib) -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt $(QA_JSONCPP_HOME)/libs/linux-gcc-4.7/libjson_linux-gcc-4.7_libmt.so

ifneq (,$(shell grep FreeBSD /COPYRIGHT 2>/dev/null))
# FreeBSD
LDFLAGS += -pthread
else
# Assume Linux
LDLIBS += -lpthread
LDFLAGS += -shared
endif

targets:= libanalysisengine.so

all: $(targets)

ha_analysisengine.o: ha_analysisengine.cc
	$(CC) $(CPPFLAGS) -c -o $@ $<

libanalysisengine.so: ha_analysisengine.o
	$(CC) $(LDFLAGS) ha_analysisengine.o $(LDLIBS) -o $@


clean:
	rm -f $(targets) *.o *.core *.so
