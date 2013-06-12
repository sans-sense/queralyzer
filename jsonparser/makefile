# plain simple makefile to build q_parsertest

OUT = $(QA_HOME)/lib/libqjsonserializer.a
inc := $(QA_JSONCPP_HOME)/include/json/
lib := $(QA_JSONCPP_HOME)/libs/linux-gcc-4.7/
CPP := g++

CPPFLAGS := -Wall -Wextra -ansi -g 
LDFLAGS  := 

LDLIBS   := -L$(lib) -ljson_linux-gcc-4.7_libmt

HEADERS = q_JsonSerializer.h q_JsonSerializable.h

all: q_jsonserializertest $(OUT)
#all: $(OUT)
# Implicit rule to compile c++ files

%.o: %.cpp
	$(CPP) $(CPPFLAGS) $< -c -o $@

$(OUT): q_MetaData.o
	ar rcs $(OUT) q_MetaData.o 

# Link executable

q_jsonserializertest: q_testJsonSerializer.o q_MetaData.o 
	$(CPP) $(LDFLAGS) q_testJsonSerializer.o q_MetaData.o $(LDLIBS) -o $@

clean:
	rm -f q_jsonserializertest *.o $(OUT) 

