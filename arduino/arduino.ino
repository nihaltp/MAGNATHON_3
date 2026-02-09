#include <Arduino.h>
#include "pins.h"
#include "ldr.h"
#include "light.h"
#include "display.h"

int score = 0;
bool coaster1Start = false;
bool coaster2Start = false;
bool pause = false;
int scoreInterval = 10 * 1000;
int timeNow = 0;

void setup() {
  Serial.begin(9600);

  setupPins();
  displaySetup();
}

void loop() {
  if (timeNow == 0) {
    timeNow = millis();
  }

  if (Serial.available() > 0) {
    String message = Serial.readString();
    if (message == "reset") {
      score = 0;
      coaster1Start = false;
      coaster2Start = false;
    }
    if (message == "start") {
      coaster1Start = getLDRState(1);
      coaster2Start = getLDRState(2);
    }
    if (message == "stop") {
      coaster1Start = false;
      coaster2Start = false;
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

  if (!coaster1Start || !coaster2Start) {
    if (!coaster1Start) {
      Coaster1Off();
      coaster1Start = getLDRState(1);
    }
    if (!coaster2Start) {
      Coaster2Off();
      coaster2Start = getLDRState(2);
    }
  } else {
    if (pause) {
    } else if (getLDRState(1) && getLDRState(2)) {
      if (timeNow >= scoreInterval) {
        score += 1;
        showNumber(score);
        timeNow = millis();
      }
    } else {
      if (!getLDRState(1)) {
        Coaster1Red();
      }
      if (!getLDRState(2)) {
        Coaster2Red();
      }
      Serial.println("score: " + String(score));
      score = 0;
      coaster1Start = false;
      coaster2Start = false;
    }
  }
}
