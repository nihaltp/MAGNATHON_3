#include <Arduino.h>
#include <LedControl.h>

#define SEGMENT_LOAD_PIN 7
#define SEGMENT_CLOCK_PIN 13
#define SEGMENT_DATA_PIN 11

LedControl lc = LedControl(SEGMENT_DATA_PIN, SEGMENT_CLOCK_PIN, SEGMENT_LOAD_PIN);

void setup() {
  Serial.begin(9600);

  lc.shutdown(0, false);
  lc.setIntensity(0, 8);
  lc.clearDisplay(0);
}

void showNumber(int number) {
  lc.setDigit(0, 0, number % 10, false);         // Units
  lc.setDigit(0, 1, (number / 10) % 10, false);  // Tens
  lc.setDigit(0, 2, number / 100, false);        // Hundreds
}

void loop() {
  for (int i = 0; i < 1000; i++) {
    showNumber(i);
    delay(1000);
  }
}
