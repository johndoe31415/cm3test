/**
 *	cm3test - Hello world program for Cortex-M3.
 *	Copyright (C) 2019-2019 Johannes Bauer
 *
 *	This file is part of cm3test.
 *
 *	cm3test is free software; you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation; this program is ONLY licensed under
 *	version 3 of the License, later versions are explicitly excluded.
 *
 *	cm3test is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with cm3test; if not, write to the Free Software
 *	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 *	Johannes Bauer <JohannesBauer@gmx.de>
**/

#include <stdint.h>
#include <stdbool.h>
#include <stm32f10x_gpio.h>

#include "main.h"

static void delay(uint32_t duration) {
	volatile uint32_t ctr = duration;
	while (ctr--);
}

int main(void) {
	while (true) {
		GPIOB->BSRR = GPIO_Pin_2;
		delay(1000000);
		GPIOB->BRR = GPIO_Pin_2;
		delay(1000000);

		GPIOB->BSRR = GPIO_Pin_1;
		delay(1000000);
		GPIOB->BRR = GPIO_Pin_1;
		delay(1000000);

		GPIOB->BSRR = GPIO_Pin_0;
		delay(1000000);
		GPIOB->BRR = GPIO_Pin_0;
		delay(1000000);
	}
}
