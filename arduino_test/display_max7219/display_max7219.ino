#include <Arduino.h>
#include <LedControl.h>

#define SEGMENT_LOAD_PIN 3
#define SEGMENT_CLOCK_PIN 13
#define SEGMENT_DATA_PIN 11

LedControl lc = LedControl(SEGMENT_DATA_PIN, SEGMENT_CLOCK_PIN, SEGMENT_LOAD_PIN, 1);

// 8x8 font for digits 0–9
byte digits[10][8] = {
  {0x3C,0x66,0x6E,0x76,0x66,0x66,0x3C,0x00}, // 0
  {0x18,0x38,0x18,0x18,0x18,0x18,0x3C,0x00}, // 1
  {0x3C,0x66,0x06,0x0C,0x30,0x60,0x7E,0x00}, // 2
  {0x3C,0x66,0x06,0x1C,0x06,0x66,0x3C,0x00}, // 3
  {0x0C,0x1C,0x3C,0x6C,0x7E,0x0C,0x0C,0x00}, // 4
  {0x7E,0x60,0x7C,0x06,0x06,0x66,0x3C,0x00}, // 5
  {0x1C,0x30,0x60,0x7C,0x66,0x66,0x3C,0x00}, // 6
  {0x7E,0x66,0x06,0x0C,0x18,0x18,0x18,0x00}, // 7
  {0x3C,0x66,0x66,0x3C,0x66,0x66,0x3C,0x00}, // 8
  {0x3C,0x66,0x66,0x3E,0x06,0x0C,0x38,0x00}  // 9
};

void setup() {
  lc.shutdown(0, false);
  lc.setIntensity(0, 8);
  lc.clearDisplay(0);
}

void loop() {
  const char message[] = "123";
  scrollNumber(message);
  delay(500);
}

void scrollNumber(const char* msg) {
  int length = strlen(msg);
  int totalWidth = length * 8 + length; // digit width + spacing

  for (int shift = 8; shift >= -totalWidth; shift--) {
    lc.clearDisplay(0);

    for (int row = 0; row < 8; row++) {
      byte rowData = 0;

      for (int i = 0; i < length; i++) {
        int digit = msg[i] - '0';
        int offset = shift + i * 7;

        if (offset > -8 && offset < 8) {
          byte d = digits[digit][row];
          if (offset >= 0)
            rowData |= d >> offset;
          else
            rowData |= d << (-offset);
        }
      }

      lc.setRow(0, row, rowData);
    }

    delay(120);
  }
}
