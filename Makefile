.PHONY: all clean openocd ocdconsole gdb reset flashdump program halgen

include Makefile.toolchain

PROJECT_NAME := cm3test
TARGETS := $(PROJECT_NAME) $(PROJECT_NAME).bin

CFLAGS += -include stdperiph/configuration.h -Istdperiph/include -Istdperiph/system -Istdperiph/cmsis
LDFLAGS := -Tlinker.ld
LDFLAGS += -Wl,--gc-sections
STATICLIBS := stdperiph/stdperiph.a

OBJS := startup.o system.o init.o
OBJS += main.o

all: $(TARGETS)

clean:
	rm -f $(OBJS) $(TARGETS)
	rm -f $(PROJECT_NAME).sym flash.bin

stdperiph:
	make -C stdperiph

openocd:
	openocd -f interface/jlink.cfg -c 'transport select swd' -f target/stm32f1x.cfg

ocdconsole:
	telnet 127.0.0.1 4444

gdb:
	$(GDB) -ex "target extended-remote :3333" $(PROJECT_NAME)

reset:
	echo "reset halt; reset run" | nc -N 127.0.0.1 4444

flashdump:
	echo "reset halt; dump_image flash.bin 0x8000000 0x8000" | nc -N 127.0.0.1 4444

program: $(PROJECT_NAME).bin
	echo "reset halt; program $(PROJECT_NAME).bin 0x8000000 reset" | nc -N 127.0.0.1 4444

halgen:
	mcuconfig project.json .

$(PROJECT_NAME): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(STATICLIBS)

$(PROJECT_NAME).bin: $(PROJECT_NAME)
	$(OBJCOPY) -O binary $< $@

$(PROJECT_NAME).sym: $(PROJECT_NAME).c
	$(CC) $(CFLAGS) -E -dM -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.s.o:
	$(CC) $(CFLAGS) -c -o $@ $<
