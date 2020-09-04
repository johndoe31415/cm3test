.PHONY: all clean build_spl openocd ocdconsole gdb reset flashdump program

TARGETS := cm3test cm3test.bin

PREFIX := arm-none-eabi-
CC := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
AR := $(PREFIX)ar
GDB := $(PREFIX)gdb

CFLAGS := $(CFLAGS) -std=c11
CFLAGS += -Wall -Wmissing-prototypes -Wstrict-prototypes -Werror=implicit-function-declaration -Werror=format -Wimplicit-fallthrough -Wshadow
CFLAGS += -Os -g3
CFLAGS += -mcpu=cortex-m3 -mthumb
#CFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16 -mthumb
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -include stdperiph/configuration.h -Istdperiph/include -Istdperiph/system -Istdperiph/cmsis
LDFLAGS := -Tstm32f103c8.ld
WRITE_ADDR := 0x08000000
LDFLAGS += -Wl,--gc-sections
#-nostdlib
STATICLIBS := stdperiph/stdperiph.a

OBJS := main.o system.o ivt.o

all: $(TARGETS)

clean:
	rm -f $(OBJS) $(TARGETS)
	rm -f cm3test.sym flash.bin

stdperiph:
	make -C stdperiph

openocd:
	openocd -f interface/jlink.cfg -c 'transport select swd' -f target/stm32f1x.cfg

ocdconsole:
	telnet 127.0.0.1 4444

gdb:
	$(GDB) -ex "target extended-remote :3333" cm3test

reset:
	echo "reset halt; reset run" | nc -N 127.0.0.1 4444

flashdump:
	echo "reset halt; dump_image flash.bin 0x8000000 0x8000" | nc -N 127.0.0.1 4444

program: cm3test.bin
	echo "reset halt; program cm3test.bin 0x8000000 reset" | nc -N 127.0.0.1 4444

cm3test: $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(STATICLIBS)

cm3test.bin: cm3test
	$(OBJCOPY) -O binary $< $@

cm3test.sym: cm3test.c
	$(CC) $(CFLAGS) -E -dM -o $@ $<

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.s.o:
	$(CC) $(CFLAGS) -c -o $@ $<
