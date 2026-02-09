#include <Arduino.h>

#define IR1 13
#define IR2 12
#define IR3 11
#define IR4 10

int score = 0;

unsigned long timeNow = 0;
unsigned long scoreInterval = 10 * 1000;

bool pause = false;
bool failed = false;

bool checkIR();

void setup() {
  Serial.begin(9600);

  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);
  pinMode(IR3, INPUT);
  pinMode(IR4, INPUT);
}

void loop() {
  if (pause) {
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

  if (Serial.available() > 0) {
    String message = Serial.readString();
    if (message == "reset") {
      score = 0;
      failed = false;
    }
    if (message == "start") {
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
}

bool checkIR() {
  return digitalRead(IR1) && digitalRead(IR2) && digitalRead(IR3) && digitalRead(IR4);
}
