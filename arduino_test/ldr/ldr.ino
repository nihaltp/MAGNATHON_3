#include <Arduino.h>

#define PIN_LDR1_CONTROL_A 12
#define PIN_LDR1_CONTROL_B 10
#define PIN_ANALOG_INPUT1 A0

#define PIN_LDR2_CONTROL_A 9
#define PIN_LDR2_CONTROL_B 8
#define PIN_ANALOG_INPUT2 A1

#define LDR_THRESHOLD 500

bool getStateCoaster1();
bool getStateCoaster2();

void setup() {
  Serial.begin(9600);

  pinMode(PIN_LDR1_CONTROL_A, OUTPUT);
  pinMode(PIN_LDR1_CONTROL_B, OUTPUT);
  pinMode(PIN_ANALOG_INPUT1, INPUT);

  digitalWrite(PIN_LDR1_CONTROL_A, LOW);
  digitalWrite(PIN_LDR1_CONTROL_B, LOW);
}

void loop() {
  Serial.print("Coaster 1: ");
  Serial.println(getStateCoaster1());
  Serial.print("Coaster 2: ");
  Serial.println(getStateCoaster2());
  delay(1000);
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
