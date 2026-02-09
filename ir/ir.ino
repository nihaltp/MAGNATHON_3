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
unsigned long scoreInterval = 1000;

bool pause = false;
bool failed = false;

bool checkIR();
void displaySetup();
void showNumber(int number);

void setup() {
  Serial.begin(9600);

  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);
  pinMode(IR3, INPUT);
  pinMode(IR4, INPUT);

  displaySetup();
  showNumber(0);
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
      showNumber(score);
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
        showNumber(score);
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

void showNumber(int number) {
  lc.setDigit(0, 0, number % 10, false);         
  lc.setDigit(0, 1, (number / 10) % 10, false); 
  lc.setDigit(0, 2, number / 100, false);        
}