import os
import serial
import time
import firebase_admin
from firebase_admin import credentials, db
from dotenv import load_dotenv

#Load environment variables
load_dotenv()
firebase_url = os.getenv("FIREBASE_URL")

# ---------- SERIAL CONFIG ----------
SERIAL_PORT = "COM3"       # Windows: COM3 | Linux: /dev/ttyUSB0
BAUD_RATE = 9600

# ---------- FIREBASE CONFIG ----------
cred = credentials.Certificate("firebase_key.json")
firebase_admin.initialize_app(cred, {
    "databaseURL": firebase_url
})

ref = db.reference("arduino_data")

# ---------- SERIAL CONNECTION ----------
ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
time.sleep(2)  # wait for Arduino reset

print("Listening to Arduino...")

while True:
    try:
        if ser.in_waiting:
            data = ser.readline().decode("utf-8").strip()
            print("Received:", data)

            # Upload to Firebase
            ref.push({
                "value": data,
                "timestamp": time.time()
            })

    except Exception as e:
        print("Error:", e)
        time.sleep(1)
