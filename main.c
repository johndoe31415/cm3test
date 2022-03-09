#include <stdio.h>
#include <stdbool.h>
#include "system.h"

static void delay(uint32_t duration) {
	volatile uint32_t ctr = duration;
	while (ctr--);
}

int main(void) {
	while (true) {
		led_red_set_active();
		delay(1000000);
		led_red_set_inactive();
		delay(1000000);

		led_yellow_set_active();
		delay(1000000);
		led_yellow_set_inactive();
		delay(1000000);

		led_green_set_active();
		delay(1000000);
		led_green_set_inactive();
		delay(1000000);
	}
}
