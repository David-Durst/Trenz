CC = arm-linux-gnueabi-gcc
CFLAGS = -std=c99
DEPS = zynqlib.h
OBJ = zynq.o zynqlib.o

all: zynq

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c -o $@ $<

zynq: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^
	
clean:
	-rm *.o
	-rm zynq
