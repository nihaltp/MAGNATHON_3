#include <Arduino.h>
#include <LedControl.h>

#include "pins.h"
#include "display.h"

LedControl lc = LedControl(SEGMENT_DATA_PIN, SEGMENT_CLOCK_PIN, SEGMENT_LOAD_PIN);

void displaySetup() {
  lc.shutdown(0, false);
  lc.setIntensity(0, 8);
  lc.clearDisplay(0);
}

void showNumber(int number) {
  lc.setDigit(0, 0, number % 10, false);         // Units
  lc.setDigit(0, 1, (number / 10) % 10, false);  // Tens
  lc.setDigit(0, 2, number / 100, false);        // Hundreds
}
