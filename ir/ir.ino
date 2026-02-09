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

int score = 0;

unsigned long timeNow = 0;
unsigned long scoreInterval = 10 * 1000;

bool firstTime = true;
bool pause = false;
bool failed = false;

bool checkIR();
void displaySetup();
void showNumber(int number);
void displayScore();

void setup() {
  Serial.begin(9600);

  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);
  pinMode(IR3, INPUT);
  pinMode(IR4, INPUT);

  displaySetup();
}

void loop() {
  if (Serial.available() > 0) {
    String message = Serial.readString();
    message.trim();
    if (message == "reset" || message == "start") {
      failed = false;
      score = 0;
      timeNow = millis();
    }
    if (message == "stop") {
      Serial.println("score: " + String(score));
      failed = true;
    }
    if (message == "pause") {
      pause = true;
    }
    if (message == "unpause") {
      pause = false;
    }
    if (message == "score") {
      Serial.println("score: " + String(score));
    }
  }

  if (pause || failed) {
    return;
  }

  if (firstTime) {
    if (checkIR()) {
      firstTime = false;
    } else {
      return;
    }
  }

  if (!checkIR()) {
    Serial.println("score: " + String(score));
    score = 0;
    timeNow = millis();
    failed = true;
    return;
  }

  if (timeNow == 0) {
    timeNow = millis();
  }

  if (millis() - timeNow > scoreInterval) {
    if (checkIR()) {
      score += 1;
      Serial.println("score: " + String(score));
    }
    timeNow = millis();
  }
}

bool checkIR() {
  return digitalRead(IR1) && digitalRead(IR2) && digitalRead(IR3) && digitalRead(IR4);
}

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

void displayScore() {
  showNumber(score);
}
