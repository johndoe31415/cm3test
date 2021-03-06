.PHONY: all clean extract

SUBDIR := STM32F10x_StdPeriph_Lib_V3.5.0

TARGETS := stdperiph.a

PREFIX := arm-none-eabi-
CC := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
OBJDUMP := $(PREFIX)objdump
AR := $(PREFIX)ar
GDB := $(PREFIX)gdb

CFLAGS := $(CFLAGS) -std=c11
CFLAGS += -Wall -Wmissing-prototypes -Wstrict-prototypes -Werror=implicit-function-declaration -Werror=format -Wimplicit-fallthrough -Wshadow
CFLAGS += -Os -g3
CFLAGS += -mcpu=cortex-m0 -mthumb
CFLAGS += -include configuration.h
CFLAGS += -I$(SUBDIR)/Libraries/STM32F10x_StdPeriph_Driver/inc -I$(SUBDIR)/Libraries/CMSIS/CM3/CoreSupport -I$(SUBDIR)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CFLAGS += -ffunction-sections -fdata-sections

SRCS := $(wildcard $(SUBDIR)/Libraries/STM32F10x_StdPeriph_Driver/src/*.c)
OBJS := $(SRCS:%.c=%.o)

all: $(TARGETS)

clean:
	rm -f $(OBJS) $(TARGETS)
	rm -f cm0test.sym flash.bin

extract:
	rm -fr $(SUBDIR)
	rm -f include system cmsis
	unzip en.stsw-stm32054.zip
	ln -sf $(SUBDIR)/Libraries/STM32F10x_StdPeriph_Driver/inc include
	ln -sf $(SUBDIR)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x system
	ln -sf $(SUBDIR)/Libraries/CMSIS/CM3/CoreSupport cmsis
	sed -i 's/\(static __INLINE void [_a-zA-Z]\+\)()/\1(void)/g;' $(SUBDIR)/Libraries/CMSIS/CM3/CoreSupport/core_cm3.h

stdperiph.a: $(OBJS)
	$(AR) cm $@ $^

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $<

.s.o:
	$(CC) $(CFLAGS) -c -o $@ $<
