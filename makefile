# we can set this in the environment or hard code it here
QA_MYSQL_HOME := /home/prabinb/Downloads/source/mysql-5.6.10/

# we use the embedded server so we may need to build it from scratch
inc      := $(QA_MYSQL_HOME)/include
lib      := $(QA_MYSQL_HOME)/libmysqld 
parselib :=  /home/prabinb/queralyzer/

CC       := g++
CPPFLAGS := -I$(inc) -D_THREAD_SAFE -D_REENTRANT
CFLAGS   := -g -W -Wall
LDFLAGS  := -static-libgcc
# You can change -lmysqld to -lmysqlclient to use the
# client/server library
LDLIBS    = -L$(lib) -L$(parselib) -lmysqld -lz -lm -ldl -lcrypt -lstdc++ -lrt libqparser.a

ifneq (,$(shell grep FreeBSD /COPYRIGHT 2>/dev/null))
# FreeBSD
LDFLAGS += -pthread
else
# Assume Linux
LDLIBS += -lpthread
endif

# This works for simple one-file test programs
sources := $(wildcard *.c)
objects := $(patsubst %c,%o,$(sources))
targets := $(basename $(sources))

all: $(targets)
clean: 
	rm -f $(targets) $(objects) *.core
