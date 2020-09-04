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

.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

.macro _asm_memset
	# r0: destination
	# r1: pattern
	# r2: size in bytes, must be >= 0 and divisible by 4
	#ands r2, #~0x03
	#cbz r2, _asm_memset_end_\@
	cmp r2, #0
	beq _asm_memset_end_\@
	subs r2, #4

	_asm_memset_loop_\@:
		str r1, [r0, r2]
		#cbz r2, _asm_memset_end_\@
		cmp r2, #0
		beq _asm_memset_end_\@
		subs r2, #4
	b _asm_memset_loop_\@
	_asm_memset_end_\@:
.endm

.macro _asm_memcpy
	# r0: destination address
	# r1: source address
	# r2: size in bytes, must be >= 0 and divisible by 4
	#ands r2, #~0x03
	#cbz r2, _asm_memcpy_end_\@
	cmp r2, #0
	beq _asm_memcpy_end_\@
	subs r2, #4

	_asm_memcpy_loop_\@:
		ldr r3, [r1, r2]
		str r3, [r0, r2]
		#cbz r2, _asm_memcpy_end_\@
		cmp r2, #0
		beq _asm_memcpy_end_\@
		subs r2, #4
	b _asm_memcpy_loop_\@
	_asm_memcpy_end_\@:
.endm

.macro _semihosting_exit
	ldr r0, =0x18
	ldr r1, =0x20026
	bkpt #0xab
.endm

.section .text
.type Reset_Handler, %function
Reset_Handler:
	bl EarlySystemInit

	# Painting of all RAM
	ldr r0, =_sram
	ldr r1, =0xdeadbeef
	ldr r2, =_eram
	subs r2, r0
	_asm_memset

	# Load .data section
	ldr r0, =_sdata
	ldr r1, =_sidata
	ldr r2, =_edata
	subs r2, r0
	_asm_memcpy

	# Zero .bss section
	ldr r0, =_sbss
	ldr r1, =0
	ldr r2, =_ebss
	subs r2, r0
	_asm_memset

#	_semihosting_exit

	ldr r0, =0x57a0057a
	mov lr, r0
	bl SystemInit
	bl main

	_exit_loop:
	b _exit_loop
.size Reset_Handler, .-Reset_Handler
.global Reset_Handler

.section .text, "ax", %progbits
Default_Handler:
       b default_fault_handler
.size Default_Handler, .-Default_Handler
.global Default_Handler


.section .vectors, "a", %progbits
.type vectors, %object
vectors:
	.word	_eram
	.word	Reset_Handler		// 0x4
	.word	NMI_Handler		// 0x8
	.word	HardFault_Handler		// 0xc
	.word	MemManage_Handler		// 0x10
	.word	BusFault_Handler		// 0x14
	.word	UsageFault_Handler		// 0x18
	.word	0		// 0x1c: Reserved
	.word	0		// 0x20: Reserved
	.word	0		// 0x24: Reserved
	.word	0		// 0x28: Reserved
	.word	SVCall_Handler		// 0x2c
	.word	DebugMonitor_Handler		// 0x30
	.word	0		// 0x34: Reserved
	.word	PendSV_Handler		// 0x38
	.word	SysTick_Handler		// 0x3c
	.word	WWDG_Handler		// 0x40
	.word	PVD_Handler		// 0x44
	.word	TAMPER_Handler		// 0x48
	.word	RTC_Handler		// 0x4c
	.word	FLASH_Handler		// 0x50
	.word	RCC_Handler		// 0x54
	.word	EXTI0_Handler		// 0x58
	.word	EXTI1_Handler		// 0x5c
	.word	EXTI2_Handler		// 0x60
	.word	EXTI3_Handler		// 0x64
	.word	EXTI4_Handler		// 0x68
	.word	DMA1_Channel1_Handler		// 0x6c
	.word	DMA1_Channel2_Handler		// 0x70
	.word	DMA1_Channel3_Handler		// 0x74
	.word	DMA1_Channel4_Handler		// 0x78
	.word	DMA1_Channel5_Handler		// 0x7c
	.word	DMA1_Channel6_Handler		// 0x80
	.word	DMA1_Channel7_Handler		// 0x84
	.word	ADC1_2_Handler		// 0x88
	.word	USB_HP_CAN_TX_Handler		// 0x8c
	.word	USB_HP_CAN_RX0_Handler		// 0x90
	.word	CAN_RX1_Handler		// 0x94
	.word	CAN_SCE_Handler		// 0x98
	.word	EXTI9_5_Handler		// 0x9c
	.word	TIM1_BRK_Handler		// 0xa0
	.word	TIM1_UP_Handler		// 0xa4
	.word	TIM1_TRG_COM_Handler		// 0xa8
	.word	TIM1_CC_Handler		// 0xac
	.word	TIM2_Handler		// 0xb0
	.word	TIM3_Handler		// 0xb4
	.word	TIM4_Handler		// 0xb8
	.word	I2C1_EV_Handler		// 0xbc
	.word	I2C1_ER_Handler		// 0xc0
	.word	I2C2_EV_Handler		// 0xc4
	.word	I2C2_ER_Handler		// 0xc8
	.word	SPI1_Handler		// 0xcc
	.word	SPI2_Handler		// 0xd0
	.word	USART1_Handler		// 0xd4
	.word	USART2_Handler		// 0xd8
	.word	USART3_Handler		// 0xdc
	.word	EXTI15_10_Handler		// 0xe0
	.word	RTCAlarm_Handler		// 0xe4
	.word	USBWAkeup_Handler		// 0xe8
	.word	TIM8_BRK_Handler		// 0xec
	.word	TIM8_UP_Handler		// 0xf0
	.word	TIM8_TRG_COM_Handler		// 0xf4
	.word	TIM8_CC_Handler		// 0xf8
	.word	ADC3_Handler		// 0xfc
	.word	FSMC_Handler		// 0x100
	.word	SDIO_Handler		// 0x104
	.word	TIM5_Handler		// 0x108
	.word	SPI3_Handler		// 0x10c
	.word	UART4_Handler		// 0x110
	.word	UART5_Handler		// 0x114
	.word	TIM6_Handler		// 0x118
	.word	TIM7_Handler		// 0x11c
	.word	DMA2_Channel1_Handler		// 0x120
	.word	DMA2_Channel2_Handler		// 0x124
	.word	DMA2_Channel3_Handler		// 0x128
	.word	DMA2_Channel4_5_Handler		// 0x12c

	.weak	NMI_Handler
	.thumb_set	NMI_Handler, Default_Handler
	.weak	HardFault_Handler
	.thumb_set	HardFault_Handler, Default_Handler
	.weak	MemManage_Handler
	.thumb_set	MemManage_Handler, Default_Handler
	.weak	BusFault_Handler
	.thumb_set	BusFault_Handler, Default_Handler
	.weak	UsageFault_Handler
	.thumb_set	UsageFault_Handler, Default_Handler
	.weak	SVCall_Handler
	.thumb_set	SVCall_Handler, Default_Handler
	.weak	DebugMonitor_Handler
	.thumb_set	DebugMonitor_Handler, Default_Handler
	.weak	PendSV_Handler
	.thumb_set	PendSV_Handler, Default_Handler
	.weak	SysTick_Handler
	.thumb_set	SysTick_Handler, Default_Handler
	.weak	WWDG_Handler
	.thumb_set	WWDG_Handler, Default_Handler
	.weak	PVD_Handler
	.thumb_set	PVD_Handler, Default_Handler
	.weak	TAMPER_Handler
	.thumb_set	TAMPER_Handler, Default_Handler
	.weak	RTC_Handler
	.thumb_set	RTC_Handler, Default_Handler
	.weak	FLASH_Handler
	.thumb_set	FLASH_Handler, Default_Handler
	.weak	RCC_Handler
	.thumb_set	RCC_Handler, Default_Handler
	.weak	EXTI0_Handler
	.thumb_set	EXTI0_Handler, Default_Handler
	.weak	EXTI1_Handler
	.thumb_set	EXTI1_Handler, Default_Handler
	.weak	EXTI2_Handler
	.thumb_set	EXTI2_Handler, Default_Handler
	.weak	EXTI3_Handler
	.thumb_set	EXTI3_Handler, Default_Handler
	.weak	EXTI4_Handler
	.thumb_set	EXTI4_Handler, Default_Handler
	.weak	DMA1_Channel1_Handler
	.thumb_set	DMA1_Channel1_Handler, Default_Handler
	.weak	DMA1_Channel2_Handler
	.thumb_set	DMA1_Channel2_Handler, Default_Handler
	.weak	DMA1_Channel3_Handler
	.thumb_set	DMA1_Channel3_Handler, Default_Handler
	.weak	DMA1_Channel4_Handler
	.thumb_set	DMA1_Channel4_Handler, Default_Handler
	.weak	DMA1_Channel5_Handler
	.thumb_set	DMA1_Channel5_Handler, Default_Handler
	.weak	DMA1_Channel6_Handler
	.thumb_set	DMA1_Channel6_Handler, Default_Handler
	.weak	DMA1_Channel7_Handler
	.thumb_set	DMA1_Channel7_Handler, Default_Handler
	.weak	ADC1_2_Handler
	.thumb_set	ADC1_2_Handler, Default_Handler
	.weak	USB_HP_CAN_TX_Handler
	.thumb_set	USB_HP_CAN_TX_Handler, Default_Handler
	.weak	USB_HP_CAN_RX0_Handler
	.thumb_set	USB_HP_CAN_RX0_Handler, Default_Handler
	.weak	CAN_RX1_Handler
	.thumb_set	CAN_RX1_Handler, Default_Handler
	.weak	CAN_SCE_Handler
	.thumb_set	CAN_SCE_Handler, Default_Handler
	.weak	EXTI9_5_Handler
	.thumb_set	EXTI9_5_Handler, Default_Handler
	.weak	TIM1_BRK_Handler
	.thumb_set	TIM1_BRK_Handler, Default_Handler
	.weak	TIM1_UP_Handler
	.thumb_set	TIM1_UP_Handler, Default_Handler
	.weak	TIM1_TRG_COM_Handler
	.thumb_set	TIM1_TRG_COM_Handler, Default_Handler
	.weak	TIM1_CC_Handler
	.thumb_set	TIM1_CC_Handler, Default_Handler
	.weak	TIM2_Handler
	.thumb_set	TIM2_Handler, Default_Handler
	.weak	TIM3_Handler
	.thumb_set	TIM3_Handler, Default_Handler
	.weak	TIM4_Handler
	.thumb_set	TIM4_Handler, Default_Handler
	.weak	I2C1_EV_Handler
	.thumb_set	I2C1_EV_Handler, Default_Handler
	.weak	I2C1_ER_Handler
	.thumb_set	I2C1_ER_Handler, Default_Handler
	.weak	I2C2_EV_Handler
	.thumb_set	I2C2_EV_Handler, Default_Handler
	.weak	I2C2_ER_Handler
	.thumb_set	I2C2_ER_Handler, Default_Handler
	.weak	SPI1_Handler
	.thumb_set	SPI1_Handler, Default_Handler
	.weak	SPI2_Handler
	.thumb_set	SPI2_Handler, Default_Handler
	.weak	USART1_Handler
	.thumb_set	USART1_Handler, Default_Handler
	.weak	USART2_Handler
	.thumb_set	USART2_Handler, Default_Handler
	.weak	USART3_Handler
	.thumb_set	USART3_Handler, Default_Handler
	.weak	EXTI15_10_Handler
	.thumb_set	EXTI15_10_Handler, Default_Handler
	.weak	RTCAlarm_Handler
	.thumb_set	RTCAlarm_Handler, Default_Handler
	.weak	USBWAkeup_Handler
	.thumb_set	USBWAkeup_Handler, Default_Handler
	.weak	TIM8_BRK_Handler
	.thumb_set	TIM8_BRK_Handler, Default_Handler
	.weak	TIM8_UP_Handler
	.thumb_set	TIM8_UP_Handler, Default_Handler
	.weak	TIM8_TRG_COM_Handler
	.thumb_set	TIM8_TRG_COM_Handler, Default_Handler
	.weak	TIM8_CC_Handler
	.thumb_set	TIM8_CC_Handler, Default_Handler
	.weak	ADC3_Handler
	.thumb_set	ADC3_Handler, Default_Handler
	.weak	FSMC_Handler
	.thumb_set	FSMC_Handler, Default_Handler
	.weak	SDIO_Handler
	.thumb_set	SDIO_Handler, Default_Handler
	.weak	TIM5_Handler
	.thumb_set	TIM5_Handler, Default_Handler
	.weak	SPI3_Handler
	.thumb_set	SPI3_Handler, Default_Handler
	.weak	UART4_Handler
	.thumb_set	UART4_Handler, Default_Handler
	.weak	UART5_Handler
	.thumb_set	UART5_Handler, Default_Handler
	.weak	TIM6_Handler
	.thumb_set	TIM6_Handler, Default_Handler
	.weak	TIM7_Handler
	.thumb_set	TIM7_Handler, Default_Handler
	.weak	DMA2_Channel1_Handler
	.thumb_set	DMA2_Channel1_Handler, Default_Handler
	.weak	DMA2_Channel2_Handler
	.thumb_set	DMA2_Channel2_Handler, Default_Handler
	.weak	DMA2_Channel3_Handler
	.thumb_set	DMA2_Channel3_Handler, Default_Handler
	.weak	DMA2_Channel4_5_Handler
	.thumb_set	DMA2_Channel4_5_Handler, Default_Handler

.size vectors, .-vectors
.global vectors
