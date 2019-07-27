.PHONY:	all clean

# Settings

MAKEFLAGS += --no-builtin-rules --no-builtin-variables

PMD_BUILD ?= DEBUG
PMD_SHARE ?=

CC = g++
CC_OPTS = -D PMD_SHARE=\"$(PMD_SHARE)\"
LD = g++
LD_OPTS = -lSDL -lpopt -lrt

ifeq ($(PMD_BUILD), DEBUG)
CC_OPTS += -O0 -g
else ifeq ($(PMD_BUILD), RELEASE)
CC_OPTS += -O2
else
$(error)
endif

BIN = ../bin

# Targets

all: $(BIN)/simpmd

clean:
	rm -f *.o
	rm -f *.dep

# Modules

MM = sim_core sim_timing sim_display sim_keyboard sim_processor sim_speaker sim_tape
OO = $(addsuffix .o, $(MM))
DD = $(addsuffix .dep, $(MM))

%.o: %.c
	$(CC) $(CC_OPTS) -c -o $@ $<

# Executable

$(BIN)/simpmd: $(OO)
	$(LD) $(LD_OPTS) -o $@ $^

# Dependencies

include $(DD)

%.dep: %.c
	$(CC) -MM $(CC_OPTS) -MT "$@ $(basename $@).o" -o $@ $<

