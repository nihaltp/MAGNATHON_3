#ifndef PINS_H
#define PINS_H
#include <Arduino.h>

#define PIN_LDR1_CONTROL_A 12
#define PIN_LDR1_CONTROL_B 10
#define PIN_ANALOG_INPUT1 A0
#define LED_STRIP1_CONTROL 6

#define PIN_LDR2_CONTROL_A 9
#define PIN_LDR2_CONTROL_B 8
#define PIN_ANALOG_INPUT2 A1
#define LED_STRIP2_CONTROL 5

#define SEGMENT_LOAD_PIN 7
#define SEGMENT_CLOCK_PIN 13
#define SEGMENT_DATA_PIN 11

void setupPins();

#endif