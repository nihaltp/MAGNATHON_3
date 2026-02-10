import os
import serial
import time
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv
import msvcrt
from serial.tools import list_ports

#Load environment variables
load_dotenv()
firebase_url = os.getenv("FIREBASE_URL")

# ---------- SERIAL CONFIG ----------
def get_available_ports():
    """List all available serial ports"""
    ports = [port.device for port in list_ports.comports()]
    return ports

def find_arduino_port():
    """Try to find Arduino port, or prompt user"""
    ports = get_available_ports()
    
    if not ports:
        print("❌ No serial ports available!")
        print("Please connect your Arduino and try again.")
        exit(1)
    
    print(f"Available ports: {ports}")
    
    # Try to find Arduino (common descriptions)
    arduino_ports = [p for p in ports if 'Arduino' in p or 'CH340' in p or 'USB' in p]
    
    if arduino_ports:
        port = arduino_ports[0]
        print(f"✅ Using detected Arduino port: {port}")
        return port
    else:
        # If no obvious Arduino found, use first port
        port = ports[0]
        print(f"⚠️  Could not auto-detect Arduino. Using first available port: {port}")
        return port

SERIAL_PORT = os.getenv("SERIAL_PORT") or find_arduino_port()
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
game_active = False
timeNow = None

def update_coaster_ref(coaster_id: str):
    global coaster_ref
    coaster_ref = db.collection("coaster").document(coaster_id)

def update_user_ref(users_id: str):
    global users_ref
    users_ref = db.collection("users").document(users_id)

# 🔥 Firestore Listener (Flutter START trigger)
def on_snapshot(doc_snapshot, changes, read_time):
    global game_active, score_value

    for doc in doc_snapshot:
        data = doc.to_dict()

        if data.get("active") == True and not game_active:
            print("Game Started from Flutter!")
            score_value = 0
            game_active = True
            # Reset score in Firestore
            coaster_ref.update({
                "currScore": 0,
            })

            curr_user = coaster_ref.get().to_dict().get("currUser")
            # Extract user ID from DocumentReference
            if curr_user:
                if isinstance(curr_user, str):
                    users_id = curr_user.split("/users/")[1] if "/users/" in curr_user else curr_user
                else:
                    # It's a DocumentReference object
                    users_id = curr_user.id
                update_user_ref(users_id)

            ser.write(b"start\n")
            game_active = True
            timeNow = time.time()

# Attach listener
coaster_watch = coaster_ref.on_snapshot(on_snapshot)

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
                        coaster_ref.update({
                            "currScore": score_value,
                        })
                except (ValueError, IndexError) as e:
                    print(f"Error parsing score: {e}")

            elif data == "no phone detected! score paused.":
                print("No phone detected. Score paused.")
                remainingPoints = users_ref.get().to_dict().get("remainingPoints") or 0
                remainingPoints = remainingPoints + score_value
                score = users_ref.get().to_dict().get("score") or 0
                score = score + score_value

                users_ref.update({
                    "remainingPoints": remainingPoints,
                    "score": score,
                    "highScore": max(users_ref.get().to_dict().get("highScore") or 0, score_value)
                })
                coaster_ref.update({
                    "currScore": 0,
                    "currUser": None,
                    "active": False,
                    "startTime": None
                })

    except Exception as e:
        print("Error:", e)
        time.sleep(1)