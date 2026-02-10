#include <Arduino.h>
#include <LedControl.h>

#define SEGMENT_LOAD_PIN 7
#define SEGMENT_CLOCK_PIN 13
#define SEGMENT_DATA_PIN 11

LedControl lc = LedControl(SEGMENT_DATA_PIN, SEGMENT_CLOCK_PIN, SEGMENT_LOAD_PIN, 1);

void setup() {
  Serial.begin(9600);

  lc.shutdown(0, false);   // Wake up MAX7219
  lc.setIntensity(0, 8);  // Brightness: 0–15
  lc.clearDisplay(0);
}

void showNumber(int number) {
  lc.clearDisplay(0);

  bool negative = false;
  if (number < 0) {
    negative = true;
    number = -number;
  }

  int digitPos = 0;

  // Display digits from right to left
  do {
    int digit = number % 10;
    lc.setDigit(0, digitPos, digit, false);
    number /= 10;
    digitPos++;
  } while (number > 0 && digitPos < 8);

  // Show minus sign if needed
  if (negative && digitPos < 8) {
    lc.setChar(0, digitPos, '-', false);
  }
}

void loop() {
  for (int i = 0; i < 1000; i++) {
    showNumber(i);
    delay(1000);
  }
}
