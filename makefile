CPP=g++
CC=gcc

CPPFLAG=-I.
CFLAG=-I.

LDIR=/usr/local/lib
LIBS=-lboost_regex -lboost_serialization

DEPS=
SRC=./src
SRC_CPP=$(wildcard *.cpp $(SRC)/*.cpp)
SRC_NODIR=$(notdir $(SRC_CPP))
ODIR=obj
OBJ_CPP=$(patsubst %.cpp,$(ODIR)/%.o,$(SRC_NODIR))

$(ODIR)/%.o:$(SRC)/%.cpp $(DEPS)
	$(CPP) -c -o $@ $< $(CPPFLAG)

example:$(OBJ_CPP)
	@echo $(SRC_CPP)
	@echo $(SRC_NODIR)
	@echo $(OBJ_CPP)
	$(CPP) -o $@ $^ $(LIBS) $(CPPFLAG)

.PHONY:clean

clean:
	rm -f $(ODIR)/*.o example
