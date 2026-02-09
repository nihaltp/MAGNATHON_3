#include <Arduino.h>

#define LED_STRIP1_CONTROL 6
#define LED_STRIP2_CONTROL 5

void setup() {
  pinMode(LED_STRIP1_CONTROL, OUTPUT);
  pinMode(LED_STRIP2_CONTROL, OUTPUT);
}

void loop() {
  Coaster1Off();
  Coaster2Off();
  Coaster1Green();
  Coaster2Red();
  delay(1000);
  Coaster1Off();
  Coaster2Off();
  Coaster1Red();
  Coaster2Green();
  delay(1000);
}

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
