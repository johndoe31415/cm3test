# cm3test
Very simple hello world example for Cortex-M3 STM32F103C8T6. It fires up the
PLL to 72 MHz from an 8 MHz HSE and creates a "blinky" on PB0, PB1 and PB2.

## Usage
First, you need to download the STM32F10x standard peripheral library as a ZIP
file. In my case this was called "en.stsw-stm32054.zip" and contained the
subdirectory "STM32F10x_StdPeriph_Lib_V3.5.0/". Place this file in the `stdperiph/` subdirectory and compile it:

```
$ make stdperiph -j16
```

Then, build the project:

```
$ make
```

Finally, fire up OpenOCD to connect to your Cortex-M3 using SWD:

```
$ make openocd
openocd -f interface/jlink.cfg -c 'transport select swd' -f target/stm32f1x.cfg
Open On-Chip Debugger 0.10.0
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
swd
adapter speed: 1000 kHz
adapter_nsrst_delay: 100
none separate
cortex_m reset_config sysresetreq
Info : No device selected, using first device.
Info : J-Link V9 compiled May 17 2019 09:50:41
Info : Hardware version: 9.10
Info : VTarget = 3.304 V
Info : clock speed 1000 kHz
Info : SWD DPIDR 0x1ba01477
Info : stm32f1x.cpu: hardware has 6 breakpoints, 4 watchpoints
```

Then, in another terminal, program the device:

```
$ make program
```

Your Cortex-M should now blink.

## License
GNU GPL-3.
