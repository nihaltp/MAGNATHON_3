#include <Arduino.h>
#include "pins.h"

void setupPins() {
  // coaster 1
  pinMode(PIN_LDR1_CONTROL_A, OUTPUT);
  pinMode(PIN_LDR1_CONTROL_B, OUTPUT);
  pinMode(PIN_ANALOG_INPUT1, INPUT);
  pinMode(LED_STRIP1_CONTROL, OUTPUT);

  // coaster 2
  pinMode(PIN_LDR2_CONTROL_A, OUTPUT);
  pinMode(PIN_LDR2_CONTROL_B, OUTPUT);
  pinMode(PIN_ANALOG_INPUT2, INPUT);
  pinMode(LED_STRIP2_CONTROL, OUTPUT);
}
