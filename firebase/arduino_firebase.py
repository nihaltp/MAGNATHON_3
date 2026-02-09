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

coaster_id = "tZ00L2SuCpkHV4knZs6x"
users_id = "VVeJV9wESIhv0MZri919rLqC54w2"

coaster_ref = db.collection("coaster").document(coaster_id)
users_ref = db.collection("users").document(users_id)

print("Listening to Arduino...")

input_buffer = ""
score_value = 0

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
            data = data.lower()  # Convert to lowercase for case-insensitive comparison
            print("Arduino:", data)

            # Check if this is a Firebase score update
            if data.startswith("score: "):
                try:
                    value = int(data.split(": ")[1])
                    if value > score_value:
                        score_value = value
                except (ValueError, IndexError) as e:
                    print(f"Error parsing score: {e}")

            elif data == "no phone detected! score paused.":
                print("No phone detected. Score paused.")
                remainingPoints = coaster_ref.get().to_dict().get("remainingPoints")
                remainingPoints = remainingPoints if remainingPoints + score_value is not None else score_value

                users_ref.set({
                    "remainingPoints": remainingPoints,
                    "timestamp": time.time()
                })
                coaster_ref.update({
                    "score": score_value,
                    "timestamp": time.time()
                })
                db.collection("coaster").document("tZ00L2SuCpkHV4knZs6x").update({
                    "score": score_value
                })

    except Exception as e:
        print("Error:", e)
        time.sleep(1)
