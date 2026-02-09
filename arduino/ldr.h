#ifndef LDR_H
#define LDR_H

#include <Arduino.h>

#define LDR_THRESHOLD 500

bool getLDRState(int coaster);
bool getStateCoaster1();
bool getStateCoaster2();

#endif
