#include <Arduino.h>
#include "pins.h"
#include "ldr.h"

bool getLDRState(int coaster) {
  if (coaster == 1) {
    return getStateCoaster1();
  } else if (coaster == 2) {
    return getStateCoaster2();
  } else {
    return false;
  }
}

bool getStateCoaster1() {
  digitalWrite(PIN_LDR1_CONTROL_A, LOW);
  digitalWrite(PIN_LDR1_CONTROL_B, LOW);
  if (analogRead(PIN_ANALOG_INPUT1) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR1_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR1_CONTROL_B, LOW);
  if (analogRead(PIN_ANALOG_INPUT1) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR1_CONTROL_A, LOW);
  digitalWrite(PIN_LDR1_CONTROL_B, HIGH);
  if (analogRead(PIN_ANALOG_INPUT1) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR1_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR1_CONTROL_B, HIGH);
  if (analogRead(PIN_ANALOG_INPUT1) > LDR_THRESHOLD) {
    return false;
  }
  return true;
}

bool getStateCoaster2() {
  digitalWrite(PIN_LDR2_CONTROL_A, LOW);
  digitalWrite(PIN_LDR2_CONTROL_B, LOW);
  if (analogRead(PIN_ANALOG_INPUT2) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR2_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR2_CONTROL_B, LOW);
  if (analogRead(PIN_ANALOG_INPUT2) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR2_CONTROL_A, LOW);
  digitalWrite(PIN_LDR2_CONTROL_B, HIGH);
  if (analogRead(PIN_ANALOG_INPUT2) > LDR_THRESHOLD) {
    return false;
  }
  digitalWrite(PIN_LDR2_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR2_CONTROL_B, HIGH);
  if (analogRead(PIN_ANALOG_INPUT2) > LDR_THRESHOLD) {
    return false;
  }
  return true;
}
