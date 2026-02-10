#include <Arduino.h>
#include <LedControl.h>

#define SEGMENT_LOAD_PIN 7
#define SEGMENT_CLOCK_PIN 13
#define SEGMENT_DATA_PIN 11

#define IR1 9
#define IR2 12
#define IR3 8
#define IR4 10

LedControl lc = LedControl(SEGMENT_DATA_PIN, SEGMENT_CLOCK_PIN, SEGMENT_LOAD_PIN);

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

char buf[12];
int score = 0;
unsigned long timeNow = 0;
unsigned long scoreInterval = 1000;

bool first = true;
bool pause = false;
bool failed = false;

bool checkIR();
void displaySetup();
void scrollNumber(const char* msg);

void setup() {
  Serial.begin(9600);

  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);
  pinMode(IR3, INPUT);
  pinMode(IR4, INPUT);

  displaySetup();
  scrollNumber(itoa(0, buf, 10));
  Serial.println("System Ready. Waiting for phone...");
}

void loop() {
  // --- 1. COMMANDS ---
  if (Serial.available() > 0) {
    String message = Serial.readString();
    message.trim();

    if (message == "reset") {
      score = 0;
      failed = false;
      scrollNumber(itoa(score, buf, 10));
      Serial.println("Reset to 0");
    }
    if (message == "start") {
      score = 0;
      failed = false;
      timeNow = millis(); 
      Serial.println("Started");
    }
    if (message == "pause") {
      pause = true;
      Serial.println("Paused");
    }
    if (message == "unpause") {
      pause = false;
      Serial.println("Unpaused");
    }
  }

  if (pause) return;

  if (first) {
    if (checkIR()) {
      Serial.println("Phone detected on start, starting scoring.");
      first = false;
    } else {
      Serial.println("No phone detected on start, waiting for reset.");
      return;
    }
  }

  // --- 2. GAME LOGIC ---
  
  // If we haven't started counting yet, sync the timer
  if (timeNow == 0) timeNow = millis();

  // Check every second
  if (millis() - timeNow > scoreInterval) {
    
    if (checkIR()) {
      // Phone is PRESENT (Sensors are LOW)
      if (failed) {
        // If we were in "failed" state but phone is back, restart or wait for reset?
        // Current logic: Just print status, don't increment score until manual reset
        Serial.println("Phone detected, but need 'reset' to start scoring.");
      } else {
        score++;
        Serial.println("Score: " + String(score));
        scrollNumber(itoa(score, buf, 10));
      }
    } else {
      // Phone is GONE (Sensors are HIGH)
      if (!failed) {
        Serial.println("No Phone Detected! Score paused.");
        failed = true; // Stop scoring until reset
      }
    }
    
    timeNow = millis();
  }
}

// --- HELPER FUNCTIONS ---

bool checkIR() {
  // READ SENSORS
  int s1 = digitalRead(IR1);
  int s2 = digitalRead(IR2);
  int s3 = digitalRead(IR3);
  int s4 = digitalRead(IR4);

  // DEBUG: If you see "0000", it means phone IS detected. 
  // If you see "1111", it means phone is NOT detected.
  // Serial.print(s1); Serial.print(s2); Serial.print(s3); Serial.println(s4);

  // Return TRUE only if ALL sensors are 0 (LOW)
  return (s1 == LOW) && (s2 == LOW) && (s3 == LOW) && (s4 == LOW);
}

void displaySetup() {
  lc.shutdown(0, false);
  lc.setIntensity(0, 8);
  lc.clearDisplay(0);
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
