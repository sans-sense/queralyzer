# we can set this in the environment or hard code it here
#QA_MYSQL_HOME := /home/prabinb/Downloads/source/mysql-5.6.10/
ifndef QA_JSONCPP_HOME
  QA_JSONCPP_HOME = /home/prabinb/Downloads/source/jsoncpp-src-0.5.0/
  export QA_JSONCPP_HOME
endif

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/sql $(QA_MYSQL_HOME)/include $(QA_MYSQL_HOME)/regex
lib      := $(QA_MYSQL_HOME)/libmysqld
inc_params=$(foreach d, $(inc), -I$d)

CC       := g++
CPPFLAGS := -g $(inc_params) -D_THREAD_SAFE -DSAFE_MUTEX -D_REENTRANT  -Dblackhole_EXPORTS -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN -fno-rtti  -fPIC
#CXX_DEFINES = -Dblackhole_EXPORTS -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN
CFLAGS   := -g -W -Wall -Wextra
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

targets:= libha_blackhole.so

all: $(targets)

#libha_blackhole.so: ha_blackhole.cc blackhole_meta_data.cc
#	$(CC) $(CPPFLAGS) -o ha_blackhole.cc blackhole_meta_data.cc $(LDLIBS) $@

#blackhole_meta_data.o: blackhole_meta_data.cc
#	$(CC) $(CPPFLAGS) -c -o $@ $<

ha_blackhole.o: ha_blackhole.cc
	$(CC) $(CPPFLAGS) -c -o $@ $<

libha_blackhole.so: ha_blackhole.o
	$(CC) $(LDFLAGS) ha_blackhole.o $(LDLIBS) -o $@

#libha_blackhole.so: blackhole_meta_data.o ha_blackhole.o
#	ld -o $@ $(LDFLAGS) $(LDLIBS) blackhole_meta_data.o ha_blackhole.o


clean:
	rm -f $(targets) *.o *.core *.so
