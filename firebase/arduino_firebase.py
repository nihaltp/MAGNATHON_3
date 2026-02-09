import os
import serial
import time
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv
import msvcrt

#Load environment variables
load_dotenv()
firebase_url = os.getenv("FIREBASE_URL")

# ---------- SERIAL CONFIG ----------
SERIAL_PORT = "COM3"       # Windows: COM3 | Linux: /dev/ttyUSB0
BAUD_RATE = 9600

# ---------- FIREBASE CONFIG ----------
cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# ---------- SERIAL CONNECTION ----------
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
time.sleep(2)  # wait for Arduino reset

print("Listening to Arduino...")

input_buffer = ""

while True:
    try:
        if msvcrt.kbhit():
            char = msvcrt.getwch()

            if char == '\r':  # Enter key
                if input_buffer:
                    ser.write((input_buffer + "\n").encode("utf-8"))
                    print(f"Sent to Arduino: {input_buffer}")
                    input_buffer = ""
            elif char == '\b':  # Backspace
                input_buffer = input_buffer[:-1]
            else:
                input_buffer += char

        if ser.in_waiting:
            data = ser.readline().decode("utf-8").strip()
            print("Received:", data)

            # Check if this is a Firebase score update
            if data.startswith("score: "):
                try:
                    score_value = int(data.split(": ")[1])
                    
                    # Update Firestore database
                    db.collection("coaster").document("tZ00L2SuCpkHV4knZs6x").set({
                        "score": score_value,
                        "timestamp": time.time()
                    })
                    print(f"Successfully updated Firebase with score: {score_value}")
                    
                except (ValueError, IndexError) as e:
                    print(f"Error parsing score: {e}")
            
            else:
                # Store other sensor data in arduino_data collection
                db.collection("arduino_data").add({
                    "value": data,
                    "timestamp": time.time()
                })

    except Exception as e:
        print("Error:", e)
        time.sleep(1)
