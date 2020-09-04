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

#include <stdbool.h>
#include <stm32f10x_rcc.h>
#include <stm32f10x_gpio.h>
#include <stm32f10x_flash.h>
#include "system.h"

void default_fault_handler(void) {
	while (true);
}

static void clock_switch_hsi_pll(void) {
	/* Enable HSE oscillator */
	RCC->CR |= RCC_CR_HSEON;

	/* Wait for HSE to become ready */
	while (!(RCC->CR & RCC_CR_HSERDY));

	/* HSE 8 MHz x 9 = 72 MHz */
	/* Set PLL source to HSE */
	/* APB1 prescaler needs to be /2, 36 MHz max */
	RCC->CFGR = RCC_CFGR_PLLMULL9 | RCC_CFGR_PLLSRC | RCC_CFGR_PPRE1_DIV2;

	/* Enable the PLL */
	RCC->CR |= RCC_CR_PLLON;

	/* Wait for PLL to become ready */
	while (!(RCC->CR & RCC_CR_PLLRDY));

	/* Set Flash latency to two wait states */
	FLASH_SetLatency(FLASH_Latency_2);

	/* Switch clock source to PLL */
	RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_SW) | RCC_CFGR_SW_PLL;

	/* Wait for PLL to become active clock */
	while ((RCC->CFGR & RCC_CFGR_SWS) != RCC_CFGR_SWS_PLL);

#if 0
	/* Switch clock source to HSE */
	RCC->CFGR = (RCC->CFGR & ~RCC_CFGR_SW) | RCC_CFGR_SW_HSE;

	/* Wait for HSE to become active */
	while ((RCC->CFGR & RCC_CFGR_SWS) != RCC_CFGR_SWS_HSE);
#endif
}

void EarlySystemInit(void) {
	clock_switch_hsi_pll();
}

static void init_gpio(void) {
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	GPIO_InitTypeDef gpio_init_struct = {
			.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_2,
			.GPIO_Mode = GPIO_Mode_Out_PP,
			.GPIO_Speed = GPIO_Speed_2MHz,
	};
	GPIO_Init(GPIOB, &gpio_init_struct);
}

void SystemInit(void) {
	init_gpio();
}
