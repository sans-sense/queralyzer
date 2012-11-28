# we can set this in the environment or hard code it here
#QA_MYSQL_HOME := <mysql-src-dir>

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/sql $(QA_MYSQL_HOME)/include $(QA_MYSQL_HOME)/regex
lib      := $(QA_MYSQL_HOME)/libmysqld
inc_params=$(foreach d, $(inc), -I$d)

CC       := gcc
CPPFLAGS := $(inc_params) -D_THREAD_SAFE -D_REENTRANT  -Dblackhole_EXPORTS -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN -fno-rtti  -fPIC
#CXX_DEFINES = -Dblackhole_EXPORTS -DHAVE_CONFIG_H -DMYSQL_DYNAMIC_PLUGIN
CFLAGS   := -g -W -Wall 
LDFLAGS  := -static-libgcc
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS    = -L$(lib) -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt

ifneq (,$(shell grep FreeBSD /COPYRIGHT 2>/dev/null))
# FreeBSD
LDFLAGS += -pthread
else
# Assume Linux
LDLIBS += -lpthread
LDFLAGS += -shared
endif

# This works for simple one-file test programs
sources := $(wildcard *.cc)
objects := $(patsubst %c,%o,$(sources))
targets := $(basename $(sources))

all: 	$(targets)

clean: 
	rm -f $(targets) $(objects) *.core *.so
