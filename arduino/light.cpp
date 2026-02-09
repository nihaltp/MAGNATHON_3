#include <Arduino.h>
#include "pins.h"

void Coaster1Off() {
  digitalWrite(PIN_LDR1_CONTROL_A, LOW);
  digitalWrite(PIN_LDR1_CONTROL_B, LOW);
}

void Coaster1Green() {
  digitalWrite(PIN_LDR1_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR1_CONTROL_B, LOW);
}

void Coaster1Red() {
  digitalWrite(PIN_LDR1_CONTROL_A, LOW);
  digitalWrite(PIN_LDR1_CONTROL_B, HIGH);
}

void Coaster2Off() {
  digitalWrite(PIN_LDR2_CONTROL_A, LOW);
  digitalWrite(PIN_LDR2_CONTROL_B, LOW);
}

void Coaster2Green() {
  digitalWrite(PIN_LDR2_CONTROL_A, HIGH);
  digitalWrite(PIN_LDR2_CONTROL_B, LOW);
}

void Coaster2Red() {
  digitalWrite(PIN_LDR2_CONTROL_A, LOW);
  digitalWrite(PIN_LDR2_CONTROL_B, HIGH);
}
