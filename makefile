CPP=g++
CC=gcc

DEPS=
SRC=./src
UTILITY=${SRC}/utility
ODIR=obj
LDIR=${SRC}/../lib
LIBS=-lboost_serialization
CPPFLAG=-I. -g -I${SRC}/include -L${LDIR}
CFLAG=-I. -g -I${SRC}/include
# get Cpp file
SRC_CPP=$(wildcard *.cpp $(SRC)/*.cpp)
SRC_NODIR_CPP=$(notdir $(SRC_CPP))
OBJ_CPP=$(patsubst %.cpp,$(ODIR)/%.o,$(SRC_NODIR_CPP))
# get c file
SRC_C=$(wildcard *.c $(SRC)/*.c)
SRC_NODIR_C=$(notdir $(SRC_C))
OBJ_C=$(patsubst %.c,$(ODIR)/%.o,$(SRC_NODIR_C))

$(ODIR)/%.o:$(SRC)/%.cpp $(DEPS)
	$(CPP) -c -o $@ $< $(CPPFLAG)

$(ODIR)/%.o:$(SRC)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAG)

example:$(OBJ_CPP) $(OBJ_C)
	$(CPP) -o $@ $^ $(LIBS) $(CPPFLAG)

utilit.so: src/utility.c
	$(CC) -shared -fPIC -c -o $@ $< $(CFLAG) 

.PHONY:clean

clean:
	rm -f $(ODIR)/*.o example
